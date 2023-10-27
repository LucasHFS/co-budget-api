# frozen_string_literal: true

json.transaction do |json|
  json.partial! 'transactions/transaction', transaction: @transaction
end
