# frozen_string_literal: true

json.transactions do |json|
  json.array! @transactions, partial: 'transaction', as: :transaction
end
