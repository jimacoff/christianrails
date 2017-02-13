require 'rails_helper'

RSpec.describe Woods::SyncController, type: :controller do

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

  let(:valid_session) { {} }

  describe "GET #find_node_by_desc" do

    let(:story) { FactoryGirl.create(:story, name: "Carrot Story") }
    let(:storytree) { FactoryGirl.create(:storytree, story_id: story.id, name: "Main Tree") }

    let!(:node1) { FactoryGirl.create(:node, storytree_id: storytree.id, tree_index: 1) }
    let!(:node2) { FactoryGirl.create(:node, storytree_id: storytree.id, tree_index: 2) }
    let!(:node3) { FactoryGirl.create(:node, storytree_id: storytree.id, tree_index: 3) }

    it "finds a node that exists" do
      get :find_node_by_desc, params: {story_name: story.name, storytree_name: storytree.name, tree_index: 2, sync_token: 'lol-a-sync-token'}, format: :json

      expect( response ).to be_success
      resp = JSON.parse( response.body )

      expect( resp['node']['id'] ).to eq( node2.id )
      expect( resp['storytree_id'] ).to eq( storytree.id )
      expect( resp['story_id'] ).to eq( story.id )
    end

    it "does not return information for a node that doesn't exist" do
      get :find_node_by_desc, params: {story_name: story.name, storytree_name: storytree.name,
                                       tree_index: 4, sync_token: 'lol-a-sync-token'}, format: :json
      expect( response ).to_not be_success
      resp = JSON.parse( response.body )
      expect( resp['errors'] ).to eq( "Node does not exist." )

      get :find_node_by_desc, params: {story_name: "Flarn", storytree_name: storytree.name,
                                       tree_index: 2, sync_token: 'lol-a-sync-token'}, format: :json
      expect( response ).to_not be_success
      resp = JSON.parse( response.body )
      expect( resp['errors'] ).to eq( "Node does not exist." )

      get :find_node_by_desc, params: {story_name: story.name, storytree_name: "Cran",
                                       tree_index: 2, sync_token: 'lol-a-sync-token'}, format: :json
      expect( response ).to_not be_success
      resp = JSON.parse( response.body )
      expect( resp['errors'] ).to eq( "Node does not exist." )
    end

    it "does not return information if your sync token is incorrect" do
      get :find_node_by_desc, params: {story_name: story.name, storytree_name: storytree.name,
                                       tree_index: 2, sync_token: 'LOLOLOLO-a-sync-token'}, format: :json
      expect( response ).to_not be_success
      resp = JSON.parse( response.body )
      expect( resp['errors'] ).to eq( "Invalid sync token." )
    end
  end

end
