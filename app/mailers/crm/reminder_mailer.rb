class ReminderMailer < ActionMailer::Base
  default(
    from: "ghostCRM AutoMailer <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    content_type: "text/html"
  )

  def daily_summary(assistant)
    @assistant = assistant
    subject = generate_subject_line

    mail(to: @assistant.user.email, subject: subject)
  end

  private

    def generate_subject_line
      # TODO more with personalities
      subjs = [
                "Sort your day out."
              ]
      subjs[ Random.rand( subjs.size )]
    end

end
