class ChristianMailer < ActionMailer::Base
  default(
    from: "Christian DeWolf <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    content_type: "text/html"
  )

  def ebook_receipt(order)
    @order = order
    subject = "Your receipt from ChristianDeWolf.com"

    mail(subject: subject)
  end

end
