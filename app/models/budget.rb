class Budget < ApplicationRecord
  has_many :expenses

  has_many :budget_users
  has_many :users, through: :budget_users

  validates :name, presence: true

  def total_payable
    total_payable_in_cents / 100.0
  end

  def balance_to_pay
    balance_to_pay_in_cents / 100.0
  end

  def update_budget_prices!
    update_columns(
      total_payable_in_cents: expenses.sum(:price_in_cents),
      balance_to_pay_in_cents: expenses.where.not(status: :paid).sum(:price_in_cents)
    )
  end
end
