namespace :store do

  desc "Sends out a nudge to users with sendable gifts that are over a week old"
  task unsent_gifts_nudge: :environment do
    include StoreHelper
    puts "Sending nudges about unsent gifts..."

    nudge_users_about_unsent_gifts
  end

end
