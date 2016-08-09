class AdminMailer < ActionMailer::Base
  default(
    from: "ChristianDeWolf.com AutoMailer <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    to: "christian@wolfbutler.com",
    content_type: "text/html"
  )

  def newsletter_signup(contact)
    @contact = contact
    subject = "New newsletter signup"

    mail(subject: subject)
  end

  def account_signup(user)
    @user = user
    subject = "New account created"

    mail(subject: subject)
  end

end
