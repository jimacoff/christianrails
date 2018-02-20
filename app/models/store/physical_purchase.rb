class Store::PhysicalPurchase < ApplicationRecord
  belongs_to :product,      inverse_of: :physical_purchases, optional: true
  belongs_to :variety_pack, inverse_of: :physical_purchases, optional: true
  belongs_to :order,   inverse_of: :physical_purchases
  belongs_to :user,    inverse_of: :physical_purchases

  validates_presence_of :order, :price_cents, :type_id

  monetize :price_cents

  # correspond to staged_purchase type_id
  TYPE_PHYSICAL_SINGLE      = 2
  TYPE_PHYSICAL_VARIETYPACK = 3
  TYPE_PHYSICAL_MULTIPACK   = 4

  TAX_RATE = 0.05
  MULTIPACK_SIZE = 5

  def single?
    type_id == TYPE_PHYSICAL_SINGLE
  end

  def multipack?
    type_id == TYPE_PHYSICAL_MULTIPACK
  end

  def varietypack?
    type_id == TYPE_PHYSICAL_VARIETYPACK
  end

end
