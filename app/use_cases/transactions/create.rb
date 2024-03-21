# frozen_string_literal: true

module Transactions
  class Create
    attr_reader :attributes

    def initialize(attributes:)
      @attributes = attributes
    end

    def call
      transactions = build_transactions

      res = Transaction.import(transactions)
      return Result.failure(combine_errors(res.failed_instances)) if res.failed_instances.present?

      Result.success
    end

    private

    def build_transactions
      case attributes[:kind]
      when 'installment', 'fixed'
        create_transactions_for(attributes[:kind])
      else
        [Transaction.new(attributes)]
      end
    end

    def create_transactions_for(kind)
      ActiveRecord::Base.transaction do
        collection = Collection.create(kind:)
        transaction_quantity = calculate_quantity(kind)

        Array.new(transaction_quantity) do |index|
          build_transaction_for(collection, index)
        end
      end
    end

    def calculate_quantity(kind)
      kind == 'installment' ? attributes[:installment_number].to_i : Transaction::FIXED_TRANSACTIONS_QUANTITY
    end

    def build_transaction_for(collection, index)
      due_at_date = parse_due_at_date
      Transaction.new(attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
    end

    def parse_due_at_date
      Date.parse(attributes[:due_at])
    end

    def combine_errors(failed_instances)
      failed_instances.map { |instance| instance.errors.full_messages }.flatten
    end
  end
end
