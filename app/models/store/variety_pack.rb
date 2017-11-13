class Store::VarietyPack < ApplicationRecord
  has_and_belongs_to_many :products, inverse_of: :variety_packs

  validates_presence_of :name

  monetize :price_cents
end
