require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  render_views

  before (:each) do
    @user = User.create!({
      username: 'testuser',
      first_name: 'Test',
      last_name: 'User',
      email: 'user@test.com',
      password: '12345678',
      password_confirmation: '12345678',
      country: 'CA'
    })
    sign_in @user
    @user.admin = true
    @user.save

    #controller.class.skip_before_action :verify_is_admin
  end

  let(:valid_attributes) {
    {
      title: "Good title",
      author: "Me!",
      short_desc: "A short desc",
      long_desc: "Longer description",
      price: 8.88,
      rank: 1,
      coming_soon: true
    }
  }

  let(:invalid_attributes) {
    {
      bad_attr: "Bahhh"
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all products as @products" do
      product = Product.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:products)).to eq([product])
    end
  end

  describe "GET #new" do
    it "assigns a new product as @product" do
      get :new, params: {}, session: valid_session
      expect(assigns(:product)).to be_a_new(Product)
    end
  end

  describe "GET #edit" do
    it "assigns the requested product as @product" do
      product = Product.create! valid_attributes
      get :edit, params: {:id => product.to_param}, session: valid_session
      expect(assigns(:product)).to eq(product)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Product" do
        expect {
          post :create, params: {:product => valid_attributes}, session: valid_session
        }.to change(Product, :count).by(1)
      end

      it "assigns a newly created product as @product" do
        post :create, params: {:product => valid_attributes}, session: valid_session
        expect(assigns(:product)).to be_a(Product)
        expect(assigns(:product)).to be_persisted
      end

      it "makes a product with specified attrs" do
        post :create, params: {:product => valid_attributes}, session: valid_session
        expect(assigns(:product).coming_soon).to be_truthy
        expect(assigns(:product).title).to eq("Good title")
      end

      it "redirects to the main products index" do
        post :create, params: {:product => valid_attributes}, session: valid_session
        expect(response).to redirect_to(products_url)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved product as @product" do
        post :create, params: {:product => invalid_attributes}, session: valid_session
        expect(assigns(:product)).to be_a_new(Product)
      end

      it "re-renders the 'new' template" do
        post :create, params: {:product => invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          title: "New title",
          author: "New author",
          short_desc: "Better short desc",
          long_desc: "Better longer description",
          price: 16.66,
          rank: 2,
          coming_soon: false
        }
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        put :update, params: {:id => product.to_param, :product => new_attributes}, session: valid_session
        product.reload

        expect( product.title ).to eq("New title")
        expect( product.author ).to eq("New author")
        expect( product.short_desc ).to eq("Better short desc")
        expect( product.long_desc ).to eq("Better longer description")
        expect( product.price ).to eq(16.66)
        expect( product.rank ).to eq(2)
        expect(assigns(:product).coming_soon).to be_falsy
      end

      it "assigns the requested product as @product" do
        product = Product.create! valid_attributes
        put :update, params: {:id => product.to_param, :product => valid_attributes}, session: valid_session
        expect(assigns(:product)).to eq(product)
      end

      it "redirects to the product" do
        product = Product.create! valid_attributes
        put :update, params: {:id => product.to_param, :product => valid_attributes}, session: valid_session
        expect(response).to redirect_to(products_url)
      end
    end

    context "with invalid params" do
      it "assigns the product as @product" do
        product = Product.create! valid_attributes
        put :update, params: {:id => product.to_param, :product => invalid_attributes}, session: valid_session
        expect(assigns(:product)).to eq(product)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete :destroy, params: {:id => product.to_param}, session: valid_session
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      product = Product.create! valid_attributes
      delete :destroy, params: {:id => product.to_param}, session: valid_session
      expect(response).to redirect_to(products_url)
    end
  end

  describe "GET downloads" do

    let(:product1) { FactoryGirl.create(:product) }
    let(:product2) { FactoryGirl.create(:product) }

    let(:release1) { FactoryGirl.create(:release, product: product1, format: "PDF") }
    let(:release2) { FactoryGirl.create(:release, product: product1, format: "ePub") }
    let(:release3) { FactoryGirl.create(:release, product: product2, format: "PDF") }

    let!(:download1) { FactoryGirl.create(:download, release: release1) }
    let!(:download2) { FactoryGirl.create(:download, release: release2) }
    let!(:download3) { FactoryGirl.create(:download, release: release2) }
    let!(:download4) { FactoryGirl.create(:download, release: release3) }

    it "should show all the products and their respective downloads" do
      get :index, params: {}, session: valid_session
      expect(assigns(:products)).to include(product1, product2)

      downloads = []

      assigns(:products).each do |product|
        product.downloads.map{ |d| downloads << d }
      end

      expect( downloads.size ).to eq(4)
    end

  end

end
