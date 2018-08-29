class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :logs, inverse_of: :user

  has_many :downloads,                           inverse_of: :user, class_name: 'Store::Download'
  has_many :digital_purchases, through: :orders, inverse_of: :user, class_name: 'Store::DigitalPurchase'
  has_many :physical_purchases, through: :orders, inverse_of: :user, class_name: 'Store::PhysicalPurchase'
  has_many :orders,                              inverse_of: :user, class_name: 'Store::Order'
  has_many :staged_purchases,                    inverse_of: :user, class_name: 'Store::StagedPurchase'
  has_many :received_gifts,         inverse_of: :recipient, class_name: 'Store::FreeGift', foreign_key: "recipient_id"
  has_many :given_gifts,            inverse_of: :giver,     class_name: 'Store::FreeGift', foreign_key: "giver_id"
  has_one :lifetime_membership,    inverse_of: :user, class_name: 'Store::LifetimeMembership'

  belongs_to :invited_for_product, class_name: 'Store::Product', foreign_key: "invited_for_product_id", optional: true

  has_one :player,    class_name: "Woods::Player",  dependent: :destroy
  has_one :assistant, class_name: "Crm::Assistant", dependent: :destroy

  validates_presence_of :username, :first_name, :last_name, :email, :encrypted_password
  validates_email_format_of :email

  # purchased and received-as-gift products
  def products
    products = []
    self.orders.each do |order|
      order.digital_purchases.where(type_id: Store::DigitalPurchase::TYPE_DIGITAL_SINGLE).each do |digital_purchase|
        products << digital_purchase.product
      end
    end
    self.received_gifts.each do |free_gift|
      products << free_gift.product
    end
    products.uniq
  end

  def unsent_products
    self.given_gifts.where(recipient_id: nil).collect{ |x| x.product }
  end

  def has_product?(product_id)
    return true if self.has_lifetime_membership?
    self.products.collect(&:id).include?(product_id)
  end

  def has_downloaded_product?( product )
    product_release_ids = product.releases.collect{ |x| x.id}
    releases_downloaded = self.downloads.collect{ |x| x.release_id }
    ( product_release_ids - releases_downloaded ).size < product_release_ids.size
  end

  def can_follow_up_about_product?( product )
    (!self.nudges || !self.nudges[ product.slug ]) && self.send_me_emails && self.has_downloaded_product?( product )
  end

  def has_lifetime_membership?
    !!self.lifetime_membership
  end

  def full_name
    if first_name && last_name
      first_name + " " + last_name
    else
      "Invalid name!"
    end
  end

  def fullname
    self.full_name
  end

  def has_crm_access?
    crm_access
  end

  # blocking accounts

  def account_active?
    blocked_at.nil?
  end

  def active_for_authentication?
    super && account_active?
  end

  def inactive_message
    account_active? ? super : :locked
  end

end
