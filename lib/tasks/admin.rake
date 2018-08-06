namespace :admin do

  desc "Checks watch properties"
  task check_properties: :environment do
    include LogHelper
    puts "Checking watch properties..."

    WatchProperty.all.each do |watch_property|
      if !watch_property.last_checked || watch_property.last_checked + 23.hours < DateTime.now
        response = HTTParty.get( watch_property.url )
        if response.body.include?( watch_property.expected_response ) && response.code == 200
          watch_property.last_checked = DateTime.now
          watch_property.save
          record_scheduled_event(Log::BACKEND, "#{watch_property.name} is currently available.")
        else
          AdminMailer.watch_property_alert( watch_property ).deliver_now
          record_warning(Log::BACKEND, "#{watch_property.name} did not respond as expected.")
        end
      else
        record_suspicious_event(Log::BACKEND, "WatchProperty check invoked sooner than expected.")
      end
    end
    puts "All watch properties checked."
  end

  desc "Sends out stats email to admin"
  task site_stats_report: :environment do
    include ApplicationHelper
    puts "Attempting to send Site Stats Report..."

    AdminMailer.site_stats_report( get_site_stats ).deliver_now
    puts "Done."
  end

end
