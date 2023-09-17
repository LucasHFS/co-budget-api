# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_expense!, only: %i[update destroy pay unpay]

  def index
    @expenses = current_user.budgets.find(params[:budgetId]).expenses if params[:budgetId]
    @expenses = @expenses.from_month(selected_date) if params[:selectedMonthDate]
    @expenses = @expenses.order(:due_at)
  end

  def create
    @expense = Expense.new(expense_attributes)

    if @expense.save
      render :show, status: :created
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @expense.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_attributes)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @expense.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @expense.destroy
      render json: {}, status: :no_content
    else
      render json: {
        error: {
          message: 'Erro de exclusão',
          details: ['não foi possivel excluir o produto']
        }
      }, status: :unprocessable_entity
    end
  end

  def pay
    if @expense.paid!
      render json: {}
    else
      render_update_status_error
    end
  end

  def unpay
    success = @expense.late? ? @expense.overdue! : @expense.created!

    if success
      render json: {}
    else
      render_update_status_error
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :price, :due_at, :status, :kind, :installment_number, :budget_id)
  end

  def expense_attributes
    expense_params.except(:price).merge(price_in_cents: expense_params[:price].to_f * 100)
  end

  def find_expense!
    @expense = Expense.find(params[:id])
  end

  def render_update_status_error
    render json: {
      error: {
        message: 'Erro ao alterar',
        details: ['não foi possivel alterar']
      }
    }, status: :unprocessable_entity
  end

  def selected_date
    Date.parse(params[:selectedMonthDate])
  rescue ArgumentError
    Date.current
  end
end
