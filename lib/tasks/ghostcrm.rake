namespace :ghostcrm do

  desc "Sends out Assistant emails to GhostCRM users"
  task send_daily_emails: :environment do
    include LogHelper
    puts "Sending daily GhostCRM emails..."

    Crm::Assistant.where(email_me_daily: true).each do |assistant|
      if assistant.ripe_for_email?
        send_daily_summary( assistant )
      end
    end

  end

  private

    def send_daily_summary(assistant)
      attempts = 3
      begin
        Crm::ReminderMailer.daily_summary( assistant ).deliver_now
        create_new_mailout_record( assistant, Crm::Mailout::TYPE_DAILY_SUMMARY )
      rescue SocketError
        record_warning(Log::CRM, "Socket Error sending email for #{assistant.name}.")
        sleep 3
        retry if (attempts -= 1) >= 0
      end
    end

    def create_new_mailout_record(assistant, type)
      Crm::Mailout.create(assistant_id: assistant.id, type_id: type, status_id: Crm::Mailout::STATUS_COMPLETE)
    end

end
