# frozen_string_literal: true

class BudgetUser < ApplicationRecord
  belongs_to :budget
  belongs_to :user
end
