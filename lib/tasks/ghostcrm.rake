namespace :ghostcrm do

  desc "Sends out Assistant emails to GhostCRM users"
  task send_daily_emails: :environment do
    include CrmHelper
    puts "Sending daily GhostCRM emails..."

    send_out_daily_emails
  end

end
