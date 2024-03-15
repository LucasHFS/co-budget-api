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
      case target_transactions
      when 'one'
        transaction.assign_attributes(transaction_attributes)
      when 'this_and_next'
        transactions = transaction.collection.transactions.where('due_at >= ?', transaction.due_at).each do |transaction|
          transaction.assign_attributes(transaction_attributes)
          transaction.updated_at = Time.current
        end
      when 'all'
        transactions = transaction.collection.transactions.each do |transaction|
          transaction.assign_attributes(transaction_attributes)
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
      else
        Result.failure(res.failed_instances.map(&:errors).map(&:full_messages).flatten)
      end
    end

    private

    def build_transactions
      case attributes[:kind]
      when 'installment'
        create_installment_transactions
      when 'fixed'
        create_fixed_transactions
      else
        [Transaction.new(attributes)]
      end
    end

    def create_installment_transactions
      collection = Collection.create(kind: :installment)
      Array.new(attributes[:installment_number].to_i) do |index|
        due_at_date = Date.parse(attributes[:due_at])
        Transaction.new(attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
      end
    end

    def create_fixed_transactions
      collection = Collection.create(kind: :fixed)

      Array.new(Transaction::FIXED_TRANSACTIONS_QUANTITY) do |index|
        due_at_date = Date.parse(attributes[:due_at])
        Transaction.new(attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
      end
    end
  end
end
