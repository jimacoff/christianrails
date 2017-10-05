class InvitationsController < Devise::InvitationsController

  include StoreHelper

  after_action :give_free_gifts_after_invite, only: [:update]

  private

  def after_accept_path_for(resource)
    root_path
  end


  def give_free_gifts_after_invite
    if @user
      Store::Product.where( free_on_signup: true ).each do |free_product|
        give_product_to_user!( free_product, @user, "On sign-up" )
      end
    end
  end

  # this is called when creating invitation. should return an instance of resource class
  def invite_resource
    ## skip sending emails on invite
    # super do |u|
    #   u.skip_invitation = true
    # end
  end

  # this is called when accepting invitation. should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)

    # do things here

    resource
  end
end
