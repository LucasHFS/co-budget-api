# frozen_string_literal: true

module Transactions
  class List
    attr_reader :params, :current_user

    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def call
      @transactions = current_user.budgets.find(params[:budgetId]).transactions || Transaction.all
      @transactions = @transactions.from_month(selected_date) if params[:selectedMonthDate].present?
      @transactions = @transactions.order(:status, :due_at, :name)
      Result.success(@transactions)
    end
  end
end
