class Expense < ApplicationRecord
  enum :status, created: 1, paid: 2, overdue: 3
  enum :kind, once: 1, fixed: 2, installment: 3

  belongs_to :budget

  before_save :update_status
  after_destroy :update_budget_prices
  after_save :update_budget_prices

  validates :name, presence: true
  validates :price_in_cents, presence: true
  validates :due_at, presence: true

  def price
    price_in_cents / 100.0
  end

  def late?
    Time.zone.now >= due_at
  end

  private

  def update_budget_prices
    budget.update_budget_prices!
  end

  def update_status
    return if new_record?
    self.status = late? ? :overdue : :created if due_at_changed?
  end
end
