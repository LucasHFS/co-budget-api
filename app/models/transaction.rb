# frozen_string_literal: true

class Transaction < ApplicationRecord
  FIXED_TRANSACTIONS_QUANTITY = 24

  enum :status, overdue: 1, created: 2, paid: 3
  enum :kind, once: 1, fixed: 2, installment: 3
  enum :transaction_type, expense: 1, income: 2

  belongs_to :budget
  belongs_to :collection, optional: true

  after_create :update_status!

  validates :name, presence: true
  validates :price_in_cents, presence: true
  validates :due_at, presence: true

  scope :from_month, ->(date) { where(due_at: date.all_month) }

  def price
    price_in_cents / 100.0
  end

  def late?
    Time.zone.now >= due_at
  end

  def self.update_statuses
    Transaction.find_each(&:update_status!)
  end

  def update_status!
    return if paid?

    self.status = late? ? :overdue : :created
    save
  end
end
