# frozen_string_literal: true

class BudgetsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_budget!, only: %i[update destroy]

  def index
    @budgets = Budget.all.order(:name)
  end

  def create
    @budget = Budget.new(budget_params)

    if @budget.save
      render :show, status: :created
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @budget.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def update
    if @budget.update(budget_params)
      render :show
    else
      render json: {
        error: {
          message: 'Erro de validação',
          details: @budget.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @budget.destroy
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

  private

  def budget_params
    params.require(:budget).permit(:name)
  end

  def find_budget!
    @budget = Budget.find(params[:id])
  end
end