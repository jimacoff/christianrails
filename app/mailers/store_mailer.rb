class StoreMailer < ActionMailer::Base
  default(
    from: "Christian DeWolf <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    content_type: "text/html"
  )

  def ebook_receipt(order)
    @order = order
    subject = "Your receipt from ChristianDeWolf.com"

    mail(subject: subject, to: @order.user.email)
  end

  def you_got_a_gift(product, sender, recipient)
    @product   = product
    @sender    = sender
    @recipient = recipient

    subject = "#{@sender.fullname} sent you a book!"

    mail(subject: subject, to: @recipient.email)
  end

  def gift_nudge(product, user)
    @product = product
    @user    = user

    subject = "You still have gifts to send!"

    mail(subject: subject, to: @user.email)
  end

  def follow_up_about_product(user, product, first_name_basis)
    @user    = user
    @product = product
    @first_name_basis = first_name_basis

    subject = "What do you think of #{ @product.title }?"

    mail(subject: subject, to: @user.email)
  end

end
