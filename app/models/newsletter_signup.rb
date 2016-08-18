class NewsletterSignup < ActiveRecord::Base
  validates_presence_of :email
end
