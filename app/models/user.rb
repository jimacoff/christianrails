class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :logs, inverse_of: :user

  has_many :downloads,                           inverse_of: :user, class_name: 'Store::Download'
  has_many :digital_purchases, through: :orders, inverse_of: :user, class_name: 'Store::DigitalPurchase'
  has_many :orders,                              inverse_of: :user, class_name: 'Store::Order'
  has_many :staged_purchases,                    inverse_of: :user, class_name: 'Store::StagedPurchase'
  has_many :free_gifts,                          inverse_of: :user, class_name: 'Store::FreeGift'

  has_one :player,    class_name: "Woods::Player",  dependent: :destroy
  has_one :assistant, class_name: "Crm::Assistant", dependent: :destroy

  validates_presence_of :username, :first_name, :last_name, :email, :encrypted_password

  # purchased and gifted products
  def products
    products = []
    self.orders.each do |order|
      order.digital_purchases.each do |digital_purchase|
        products << digital_purchase.product
      end
    end
    self.free_gifts.each do |free_gift|
      products << free_gift.product
    end
    products.uniq
  end

  def has_product?(product_id)
    self.products.collect(&:id).include?(product_id)
  end

  def full_name
    first_name + " " + last_name
  end

  def fullname
    self.full_name
  end

  def has_crm_access?
    crm_access
  end

end
