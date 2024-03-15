# frozen_string_literal: true

module Transactions
  class Destroy
    attr_reader :target_transactions, :transaction

    def initialize(transaction:, target_transactions: 'one')
      @target_transactions = target_transactions
      @transaction = transaction
    end

    def call
      transactions = Transaction.none
      case target_transactions
      when 'one'
        transactions = Transaction.where(id: @transaction.id)
      when 'this_and_next'
        transactions = @transaction.collection.transactions.where('due_at >= ?', @transaction.due_at)
      when 'all'
        transactions = @transaction.collection.transactions
      end
      transactions.destroy_all!
    end
  end
end
