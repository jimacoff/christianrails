class Crm::ReminderMailer < ActionMailer::Base
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
                "Sort your day out.",
                "Get your life together.",
                "Make today work for you.",
                "Take control of your day.",
                "Get it done.",
                "Nothing can stop you today.",
                "Obliterate your obligations.",
                "You know you're the best. Prove it.",
                "Success is imminent. Just do the work.",
                "Continue being unstoppable.",
                "You have immense power. Use it."
              ]
      subjs[ Random.rand( subjs.size )]
    end

end
