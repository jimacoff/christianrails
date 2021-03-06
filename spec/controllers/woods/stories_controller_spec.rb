require 'rails_helper'

RSpec.describe Woods::StoriesController, type: :controller do

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
  end

  let(:blank_session) { {} }

  describe "GET #index" do

    it "renders the index" do
      get :index, params: {}, session: blank_session
      expect( response ).to be_ok
    end

  end

  describe "GET #show" do
    let!(:story) { FactoryBot.create(:story) }

    it "renders the show" do
      get :show, params: {id: story.to_param}, session: blank_session
      expect( response ).to be_ok
    end

  end

  describe "GET #diamondfind" do

    let!(:story) { FactoryBot.create(:story, id: 1) }

    it "renders diamondfind homepage" do
      get :diamondfind, params: {}, session: blank_session
      expect( response ).to be_ok
    end

  end

  describe "GET #thecalicobrief" do

    let!(:story) { FactoryBot.create(:story, id: 15) }

    it "renders the thecalicobrief homepage" do
      get :thecalicobrief, params: {}, session: blank_session
      expect( response ).to be_ok
    end

  end

  describe "GET #up" do

    it "ensures the woods API is up" do
      get :up, params: {}, session: blank_session, format: :json
      expect( response ).to be_ok
    end

  end

  describe "-Gameplay -" do

    let!(:player) { FactoryBot.create(:player, user: @user) }

    let(:story) { FactoryBot.create(:story, name: "Clamstory") }
    let(:storytree) { FactoryBot.create(:storytree, story_id: story.id, name: "Main Tree") }

    let!(:node1) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 1) }
    let!(:node2) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 2) }
    let!(:node3) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 3) }
    let!(:node4) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 4) }
    let!(:node5) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 5) }
    let!(:node6) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 6) }
    let!(:node7) { FactoryBot.create(:node, storytree_id: storytree.id, tree_index: 7) }

    before (:each) do
      story.entry_tree = storytree
      story.save
    end

    describe "GET #play" do

      it "JSON starts a new game" do
        get :play, params: {id: story.to_param}, format: :json

        resp = JSON.parse( response.body )
        expect( response ).to be_success
      end

      it "HTML starts a new game" do
        get :play, params: {id: story.to_param}, format: :json
        expect( response ).to be_success
      end

    end

    describe "GET #move_to" do

      it "JSON moves to a node" do
        get :move_to, params: {id: story.to_param, target_node: node3.id}, format: :json

        resp = JSON.parse( response.body )
        expect( response ).to be_success
      end

      it "HTML moves to a node" do
        get :move_to, params: {id: story.to_param, target_node: node3.id}
        expect( response ).to be_success
      end

    end

  end

end
