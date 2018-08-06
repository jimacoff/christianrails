class AdminMailer < ActionMailer::Base

  # send to me by default
  default(
    from: "ChristianDeWolf.com AutoMailer <me@christiandewolf.com>",
    reply_to: "me@christiandewolf.com",
    to: "christian@wolfbutler.com",
    content_type: "text/html"
  )

  def newsletter_signup(signup)
    @newsletter_signup = signup
    subject = "New newsletter signup"

    mail(subject: subject)
  end

  def account_signup(user)
    @user = user
    subject = "New account created"

    mail(subject: subject)
  end

  def watch_property_alert(watch_property)
    @watch_property = watch_property
    subject = "#{ @watch_property.name } might be down!"

    mail(subject: subject)
  end

  def download_initiated(user, product, release)
    @user = user
    @product = product
    @release = release
    subject = "Someone downloaded #{ product.title }!"

    mail(subject: subject)
  end

  def site_stats_report(stats, logs)
    @stats = stats
    @logs = logs
    subject = "ChristianDeWolf.com Site Report"

    mail(subject: subject)
  end

end
