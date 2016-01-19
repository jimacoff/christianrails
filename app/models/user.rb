class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :downloads, inverse_of: :user
  has_many :purchases, inverse_of: :user
  has_many :orders, through: :purchases, inverse_of: :user
  has_many :products, through: :purchases
  has_many :staged_purchases, inverse_of: :user

  validates_presence_of :username, :full_name, :country, :email, :encrypted_password

  def has_product?(product_id)
    self.products.collect(&:id).include?(product_id)
  end

end
