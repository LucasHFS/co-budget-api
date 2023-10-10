# frozen_string_literal: true

class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_expense!, only: %i[update destroy pay unpay]

  def index
    @expenses = current_user.budgets.find(params[:budgetId]).expenses || Expense.none
    @expenses = @expenses.from_month(selected_date) if params[:selectedMonthDate]
    @expenses = @expenses.order(:status, :due_at, :name)
  end

  def create
    expenses = case expense_attributes[:kind]
               when 'installment'
                 create_installment_expenses
               when 'fixed'
                 create_fixed_expenses
               else
                 [Expense.new(expense_attributes)]
               end

    res = Expense.import(expenses)

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
    expenses = []
    case expense_params[:target_expenses]
    when 'one'
      @expense.assign_attributes(expense_attributes)
    when 'this_and_next'
      expenses = @expense.collection.expenses.where('due_at >= ?', @expense.due_at).each do |expense|
        expense.assign_attributes(expense_attributes)
        expense.updated_at = Time.current
      end
    when 'all'
      expenses = @expense.collection.expenses.each do |expense|
        expense.assign_attributes(expense_attributes)
        expense.updated_at = Time.current
      end
    end

    success = false

    if expenses.any?
      res = Expense.import(expenses, on_duplicate_key_update: %i[name price_in_cents status])
      success = res.failed_instances.blank?
    else
      success = @expense.save
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
    expenses = Expense.none
    case params[:targetExpenses]
    when 'one'
      expenses = Expense.where(id: @expense.id)
    when 'this_and_next'
      expenses = @expense.collection.expenses.where('due_at >= ?', @expense.due_at)
    when 'all'
      expenses = @expense.collection.expenses
    end
    expenses.destroy_all
    render json: {}, status: :no_content
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
    params.require(:expense).permit(:name, :price, :due_at, :status, :kind, :installment_number, :budget_id, :target_expenses)
  end

  def expense_attributes
    expense_params.slice(:name, :due_at, :status, :kind, :installment_number, :budget_id).merge(price_in_cents: expense_params[:price].to_f * 100)
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

  def create_installment_expenses
    collection = Collection.create(kind: :installment)
    Array.new(expense_attributes[:installment_number].to_i) do |index|
      due_at_date = Date.parse(expense_attributes[:due_at])
      Expense.new(expense_attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
    end
  end

  def create_fixed_expenses
    collection = Collection.create(kind: :fixed)

    Array.new(Expense::FIXED_EXPENSES_QUANTITY) do |index|
      due_at_date = Date.parse(expense_attributes[:due_at])
      Expense.new(expense_attributes.merge(collection_id: collection.id, due_at: due_at_date + index.months))
    end
  end

  def selected_date
    Date.parse(params[:selectedMonthDate])
  rescue ArgumentError
    Date.current
  end
end
