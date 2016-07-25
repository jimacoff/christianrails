class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :downloads, inverse_of: :user
  has_many :purchases, through: :orders, inverse_of: :user
  has_many :orders, inverse_of: :user
  has_many :staged_purchases, inverse_of: :user

  has_one :player, class_name: "Woods::Player", dependent: :destroy
  has_one :assistant, class_name: "Crm::Assistant", dependent: :destroy

  validates_presence_of :username, :first_name, :last_name, :email, :encrypted_password

  def products
    products = []
    self.orders.each do |order|
      order.purchases.each do |purchase|
        products << purchase.product
      end
    end
    products
  end

  def has_product?(product_id)
    self.products.collect(&:id).include?(product_id)
  end

  def full_name
    first_name + " " + last_name
  end

end
