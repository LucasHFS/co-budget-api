# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_budget!, only: %i[update destroy]

  def index
    @budgets = current_user.budgets.order(:name)
  end

  def create
    @budget = Budget.new(budget_params)
    @budget.users << current_user

    if @budget.save
      render :show, status: :created
    else
      render_error_message('Erro de validação', @budget.errors.full_messages)
    end
  end

  def update
    if @budget.update(budget_params)
      render :show
    else
      render_error_message('Erro de validação', @budget.errors.full_messages)
    end
  end

  def destroy
    if @budget.destroy
      render json: {}, status: :no_content
    else
      render_error_message('Erro de exclusão', 'não foi possivel excluir o orçamento')
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:name)
  end

  def find_budget!
    @budget = current_user.budgets.find(params[:id])
  end

  def render_error_message(message, details)
    render json: {
      error: {
        message:,
        details:
      }
    }, status: :unprocessable_entity
  end
end
