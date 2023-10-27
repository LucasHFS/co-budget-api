# frozen_string_literal: true

class Budget < ApplicationRecord
  has_many :transactions

  has_many :budget_users
  has_many :users, through: :budget_users

  validates :name, presence: true
end
