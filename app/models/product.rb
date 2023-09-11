class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items

  validates :name, presence: true
  validates :price_in_cents, presence: true

  def price
    self.price_in_cents / 100.0
  end
end
