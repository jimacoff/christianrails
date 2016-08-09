class AdminMailer < ActionMailer::Base
  default(
    from: "ChristianDeWolf.com AutoMailer <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com"
  )

  def newsletter_signup(contact)
    @contact = contact
    subject = "New newsletter signup"

    mail(to: "christian@wolfbutler.com", subject: subject, content_type: "text/html")
  end

end
