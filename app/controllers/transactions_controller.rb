# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transaction!, only: %i[update destroy pay unpay]

  def index
    @transactions = current_user.budgets.find(params[:budgetId]).transactions || Transaction.all
    @transactions = @transactions.from_month(selected_date) if params[:selectedMonthDate].present?
    @transactions = @transactions.order(:status, :due_at, :name)
  end

  def create
    transactions = case transaction_attributes[:kind]
               when 'installment'
                 create_installment_transactions
               when 'fixed'
                 create_fixed_transactions
               else
                 [Transaction.new(transaction_attributes)]
               end

    res = Transaction.import(transactions)

    if res.failed_instances.present?
      render json: {
        error: {
          message: 'Erro de validação',
          details: res.failed_instances.map(&:errors).map(&:full_messages).flatten
        }
      }, status: :unprocessable_entity
    else
      render json: {}, status: :created
    end
  end

  def update
    transactions = []
    case transaction_params[:target_transactions]
    when 'one'
      @transaction.assign_attributes(transaction_attributes)
    when 'this_and_next'
      transactions = @transaction.collection.transactions.where('due_at >= ?', @transaction.due_at).each do |transaction|
        transaction.assign_attributes(transaction_attributes)
        transaction.updated_at = Time.current
      end
    when 'all'
      transactions = @transaction.collection.transactions.each do |transaction|
        transaction.assign_attributes(transaction_attributes)
        transaction.updated_at = Time.current
      end
    end

    success = false

    if transactions.any?
      res = Transaction.import(transactions, on_duplicate_key_update: %i[name price_in_cents status])
      success = res.failed_instances.blank?
    else
      success = @transaction.save
    end

    if success
      render json: {}
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: res.failed_instances.map(&:errors).map(&:full_messages).flatten
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    transactions = Transaction.none
    case params[:targetTransactions]
    when 'one'
      transactions = Transaction.where(id: @transaction.id)
    when 'this_and_next'
      transactions = @transaction.collection.transactions.where('due_at >= ?', @transaction.due_at)
    when 'all'
      transactions = @transaction.collection.transactions
    end
    transactions.destroy_all
    render json: {}, status: :no_content
  end

  def pay
    if @transaction.paid!
      render json: {}
    else
      render_update_status_error
    end
  end

  def unpay
    success = @transaction.late? ? @transaction.overdue! : @transaction.created!

    if success
      render json: {}
    else
      render_update_status_error
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:name, :price, :due_at, :status, :kind, :transaction_type, :installment_number, :budget_id, :target_transactions)
  end

  def transaction_attributes
    transaction_params.slice(:name, :due_at, :status, :kind, :transaction_type, :installment_number, :budget_id).merge(price_in_cents: transaction_params[:price].to_f * 100)
  end

  def find_transaction!
    @transaction = Transaction.find(params[:id])
  end

  def render_update_status_error
    render json: {
      error: {
        message: 'Erro ao alterar',
        details: ['não foi possivel alterar']
      }
    }, status: :unprocessable_entity
  end

  def create_installment_transactions
    collection = Collection.create(kind: :installment)
    Array.new(transaction_attributes[:installment_number].to_i) do |index|
      due_at_date = Date.parse(transaction_attributes[:due_at])
      Transaction.new(transaction_attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
    end
  end

  def create_fixed_transactions
    collection = Collection.create(kind: :fixed)

    Array.new(Transaction::FIXED_TRANSACTIONS_QUANTITY) do |index|
      due_at_date = Date.parse(transaction_attributes[:due_at])
      Transaction.new(transaction_attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
    end
  end

  def selected_date
    Date.parse(params[:selectedMonthDate])
  rescue ArgumentError
    Date.current
  end
end
