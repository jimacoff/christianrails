require File.expand_path('../../app/controllers/monologue/application_controller.rb', Monologue::Engine.called_from)
require File.expand_path('../../app/controllers/monologue/posts_controller.rb', Monologue::Engine.called_from)

module Monologue
  class ApplicationController
    before_filter :verify_is_admin

    def verify_is_admin
      current_user.nil? ? redirect_to(main_app.root_path) : (redirect_to(main_app.root_path) unless current_user.admin?)
    end
  end

  class PostsController
    skip_before_filter :verify_is_admin
  end
end
