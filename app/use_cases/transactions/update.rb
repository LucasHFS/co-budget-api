# frozen_string_literal: true

module Transactions
  class Update
    attr_reader :attributes, :target_transactions, :transaction

    def initialize(target_transactions:, attributes:, transaction:)
      @attributes = attributes
      @target_transactions = target_transactions
      @transaction = transaction
    end

    def call
      transactions = []
      @target_transactions ||= 'one'
      case @target_transactions
      when 'one'
        transaction.assign_attributes(attributes)
      # when 'this_and_next'
      #   transactions = transaction.collection.transactions.where('due_at >= ?', transaction.due_at).each do |transaction|
      #     transaction.assign_attributes(attributes)
      #     transaction.updated_at = Time.current
      #   end
      when 'all'
        transactions = transaction.collection.transactions.each do |transaction|
          transaction.assign_attributes(attributes)
          transaction.updated_at = Time.current
        end
      end

      if transactions.any?
        res = Transaction.import(transactions, on_duplicate_key_update: %i[name price_in_cents status])
        success = res.failed_instances.blank?
      else
        success = transaction.save
      end

      if success
        Result.success
      elsif transactions.any?
        Result.failure(res.failed_instances.map(&:errors).map(&:full_messages).flatten)
      else
        Result.failure(transaction.errors.full_messages)
      end
    end
  end
end
