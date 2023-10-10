# frozen_string_literal: true

class Collection < ApplicationRecord
  has_many :expenses, dependent: :nullify

  enum :kind, once: 1, fixed: 2, installment: 3
end
