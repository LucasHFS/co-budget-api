# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items

  belongs_to :client, class_name: 'User', foreign_key: 'user_id', inverse_of: :orders
  belongs_to :sale_event

  has_one :delivery, dependent: :destroy

  before_save do
    self.price_in_cents = calculate_order_price
  end

  scope :sent, -> { where(state: :sent) }

  validates :state, presence: true

  state_machine initial: :pending do
    state :pending
    state :prepared
    state :sent
    state :completed
    state :canceled

    event :register do
      transition any => :pending
    end

    event :prepare do
      transition any => :prepared
    end

    event :send_order do
      transition any => :sent
    end

    event :complete do
      transition any => :completed
    end

    event :cancel do
      transition any => :canceled
    end
  end

  def price
    price_in_cents / 100.0
  end

  private

  def calculate_order_price
    line_items.reduce(0) { |sum, line_item| sum + (line_item.unit_price_in_cents * line_item.quantity) }
  end
end
