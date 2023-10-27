# frozen_string_literal: true

class BudgetTransaction < ApplicationRecord
  belongs_to :budget
  belongs_to :transaction
end
