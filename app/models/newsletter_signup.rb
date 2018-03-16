class NewsletterSignup < ApplicationRecord
  validates_presence_of :email
  validates_email_format_of :email
end
