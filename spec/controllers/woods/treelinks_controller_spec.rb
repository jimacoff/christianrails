require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe Woods::TreelinksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Woods::Treelink. As you add validations to Woods::Treelink, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Woods::TreelinksController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all woods_treelinks as @woods_treelinks" do
      treelink = Woods::Treelink.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:woods_treelinks)).to eq([treelink])
    end
  end

  describe "GET #show" do
    it "assigns the requested woods_treelink as @woods_treelink" do
      treelink = Woods::Treelink.create! valid_attributes
      get :show, {:id => treelink.to_param}, valid_session
      expect(assigns(:woods_treelink)).to eq(treelink)
    end
  end

  describe "GET #new" do
    it "assigns a new woods_treelink as @woods_treelink" do
      get :new, {}, valid_session
      expect(assigns(:woods_treelink)).to be_a_new(Woods::Treelink)
    end
  end

  describe "GET #edit" do
    it "assigns the requested woods_treelink as @woods_treelink" do
      treelink = Woods::Treelink.create! valid_attributes
      get :edit, {:id => treelink.to_param}, valid_session
      expect(assigns(:woods_treelink)).to eq(treelink)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Woods::Treelink" do
        expect {
          post :create, {:woods_treelink => valid_attributes}, valid_session
        }.to change(Woods::Treelink, :count).by(1)
      end

      it "assigns a newly created woods_treelink as @woods_treelink" do
        post :create, {:woods_treelink => valid_attributes}, valid_session
        expect(assigns(:woods_treelink)).to be_a(Woods::Treelink)
        expect(assigns(:woods_treelink)).to be_persisted
      end

      it "redirects to the created woods_treelink" do
        post :create, {:woods_treelink => valid_attributes}, valid_session
        expect(response).to redirect_to(Woods::Treelink.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved woods_treelink as @woods_treelink" do
        post :create, {:woods_treelink => invalid_attributes}, valid_session
        expect(assigns(:woods_treelink)).to be_a_new(Woods::Treelink)
      end

      it "re-renders the 'new' template" do
        post :create, {:woods_treelink => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested woods_treelink" do
        treelink = Woods::Treelink.create! valid_attributes
        put :update, {:id => treelink.to_param, :woods_treelink => new_attributes}, valid_session
        treelink.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested woods_treelink as @woods_treelink" do
        treelink = Woods::Treelink.create! valid_attributes
        put :update, {:id => treelink.to_param, :woods_treelink => valid_attributes}, valid_session
        expect(assigns(:woods_treelink)).to eq(treelink)
      end

      it "redirects to the woods_treelink" do
        treelink = Woods::Treelink.create! valid_attributes
        put :update, {:id => treelink.to_param, :woods_treelink => valid_attributes}, valid_session
        expect(response).to redirect_to(treelink)
      end
    end

    context "with invalid params" do
      it "assigns the woods_treelink as @woods_treelink" do
        treelink = Woods::Treelink.create! valid_attributes
        put :update, {:id => treelink.to_param, :woods_treelink => invalid_attributes}, valid_session
        expect(assigns(:woods_treelink)).to eq(treelink)
      end

      it "re-renders the 'edit' template" do
        treelink = Woods::Treelink.create! valid_attributes
        put :update, {:id => treelink.to_param, :woods_treelink => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested woods_treelink" do
      treelink = Woods::Treelink.create! valid_attributes
      expect {
        delete :destroy, {:id => treelink.to_param}, valid_session
      }.to change(Woods::Treelink, :count).by(-1)
    end

    it "redirects to the woods_treelinks list" do
      treelink = Woods::Treelink.create! valid_attributes
      delete :destroy, {:id => treelink.to_param}, valid_session
      expect(response).to redirect_to(woods_treelinks_url)
    end
  end

end
