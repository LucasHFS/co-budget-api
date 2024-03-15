# frozen_string_literal: true

module Transactions
  class Destroy
    attr_reader :target_transactions, :transaction

    def initialize(transaction:, target_transactions: 'one')
      @target_transactions = target_transactions
      @transaction = transaction
    end

    def call
      target_transactions ||= 'one'
      transactions = case target_transactions
                     when 'one'
                       Transaction.where(id: transaction.id)
                     when 'this_and_next'
                       transaction.collection.transactions.where('due_at >= ?', transaction.due_at)
                     when 'all'
                       transaction.collection.transactions
                     else
                       Transaction.none
                     end
      deleted_transactions = transactions.destroy_all
      if deleted_transactions&.any?
        Result.success
      else
        Result.failure(errors: 'Erro ao deletar')
      end
    end
  end
end
