# frozen_string_literal: true

class TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_transaction!, only: %i[update destroy pay unpay]

  def index
    result = Transactions::List.new(current_user:, params:).call

    @transactions = result.success? ? result.data : []
  end

  def create
    result = Transactions::Create.new(attributes: transaction_attributes).call

    if result.failure?
      render_error('Erro de validação', result.errors)
    else
      render json: {}, status: :created
    end
  end

  def update
    result = Transactions::Update.new(
      target_transactions: transaction_attributes[:target_transactions],
      attributes: transaction_attributes,
      transaction: @transaction
    ).call

    if result.failure?
      render_error('Erro de validação', result.errors)
    else
      render json: {}, status: :ok
    end
  end

  def destroy
    result = Transactions::Destroy.new(
      target_transactions: params[:target_transactions],
      transaction: @transaction
    ).call

    if result.failure?
      render_error('Erro ao deletar', result.errors)
    else
      render json: {}, status: :no_content
    end
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
    params.require(:transaction).permit(
      :name,
      :price,
      :due_at,
      :status,
      :kind,
      :transaction_type,
      :installment_number,
      :budget_id,
      :target_transactions
    )
  end

  def transaction_attributes
    transaction_params.slice(
      :name,
      :due_at,
      :status,
      :kind,
      :transaction_type,
      :installment_number,
      :budget_id
    ).merge(price_in_cents: transaction_params[:price].to_f * 100)
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

  def render_error(title, errors)
    render json: {
      error: {
        message: title,
        details: errors
      }
    }, status: :unprocessable_entity
  end
end
