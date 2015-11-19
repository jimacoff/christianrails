class Purchase < ActiveRecord::Base
  belongs_to :product, inverse_of: :purchases
  belongs_to :user, inverse_of: :purchases

  validates_presence_of :product, :user


  
end
