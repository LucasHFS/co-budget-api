class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0 }

  before_validation do
    self.unit_price_in_cents = product.price_in_cents
  end

  def unit_price
    self.unit_price_in_cents / 100.0
  end
end
