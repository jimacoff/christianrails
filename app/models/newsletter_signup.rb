class NewsletterSignup < ApplicationRecord
  validates_presence_of :email
end
