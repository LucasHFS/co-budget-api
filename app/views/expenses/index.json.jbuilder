# frozen_string_literal: true

json.expenses do |json|
  json.array! @expenses, partial: 'expense', as: :expense
end
