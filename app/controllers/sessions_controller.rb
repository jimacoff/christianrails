class SessionsController < Devise::SessionsController

  skip_before_action :verify_is_admin
  after_action :clear_woods_player_session, only: [:destroy]

  private

    def clear_woods_player_session
      if session[:woods_player_id]
        session[:woods_player_id] = nil
        pp "## Logging out -- clearing the woods_player out of the session."
      end
    end

end
