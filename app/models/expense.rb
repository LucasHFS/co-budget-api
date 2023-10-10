# frozen_string_literal: true

class Expense < ApplicationRecord
  FIXED_EXPENSES_QUANTITY = 24

  enum :status, overdue: 1, created: 2, paid: 3
  enum :kind, once: 1, fixed: 2, installment: 3

  belongs_to :budget
  belongs_to :collection, optional: true

  before_validation :update_status

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

  private

  def update_status
    self.status = late? ? :overdue : :created if due_at_changed?
  end
end
