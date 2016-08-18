class NewsletterMailer < BaseMandrillMailer
  def welcome(newsletter_signup)
    subject = "Welcome."
    merge_vars = {
      "EMAIL" => newsletter_signup.email
    }
    body = mandrill_template("welcome", merge_vars)

    send_mail(newsletter_signup.email, subject, body)
  end
end
