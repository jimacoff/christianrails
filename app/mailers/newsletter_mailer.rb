class NewsletterMailer < BaseMandrillMailer
  def welcome(contact_id)
    contact = Crm::Contact.find(contact_id)
    subject = "Welcome."
    merge_vars = {
      "EMAIL" => contact.email
    }
    body = mandrill_template("welcome", merge_vars)

    send_mail(contact.email, subject, body)
  end
end
