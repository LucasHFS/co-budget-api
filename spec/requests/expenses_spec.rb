# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenses' do
  describe 'GET /index' do
    subject(:request) { get "/api/expenses?budgetId=#{budget.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:budget) { create(:budget, users: [user]) }

    before do
      create_list(:expense, 5, budget:)
      create_list(:expense, 5)
    end

    context 'when not logged in' do
      let(:headers) do
        { 'Accept' => 'application/json' }
      end

      it 'returns unauthorized' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'is successful' do
        request
        expect(response).to have_http_status(:success)
      end

      it 'lists all expenses' do
        request
        expect(json_body[:expenses].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/expenses', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:budget) { create(:budget) }

    let(:params) do
      {
        expense: {
          name: 'expense a',
          price: 100,
          due_at: Time.zone.today + 5,
          budget_id: budget.id
        }
      }
    end

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    context 'when successful' do
      context 'and creating a fixed expenses' do
        let(:params) do
          {
            expense: {
              name: 'expense a',
              price: 100,
              due_at: Time.zone.today + 5,
              budget_id: budget.id,
              kind: 'fixed'
            }
          }
        end

        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the right amount of expenses' do
          request

          expect(Expense.count).to eq Expense::FIXED_EXPENSES_QUANTITY
        end

        it 'creates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'fixed'
          )
        end
      end

      context 'and creating expenses with installments' do
        let(:params) do
          {
            expense: {
              name: 'expense a',
              price: 100,
              due_at: Time.zone.today + 5,
              budget_id: budget.id,
              kind: 'installment',
              installment_number: 3
            }
          }
        end

        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the right amount of expenses' do
          request

          expect(Expense.count).to eq 3
        end

        it 'creates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'installment'
          )
        end
      end

      context 'and creating single expense' do
        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the right amount of expenses' do
          request

          expect(Expense.count).to eq 1
        end

        it 'creates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'once'
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            expense: {
              name: 'expense a',
              due_at: Time.zone.today + 5
            }
          }
        end

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              error: {
                message: 'Erro de validação',
                details: ['Budget é obrigatório(a)']
              }
            }.with_indifferent_access
          )
        end
      end
    end
  end

  xdescribe 'PUT /update' do
    subject(:request) { put "/api/expenses/#{expense.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end
    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:user) { create(:user) }
    let(:expense) { create(:expense) }
    let(:budget) { create(:budget) }

    let(:params) do
      {
        expense: {
          name: 'expense b',
          price: 100,
          due_at: Time.zone.today + 5,
          budget_id: budget.id
        }
      }
    end

    let(:headers) { { 'Authorization' => "Bearer #{token}" } }
    let(:token) { user.generate_jwt }

    context 'when successful' do
      context 'and updating a fixed expenses' do
        let(:params) do
          {
            expense: {
              name: 'expense b',
              price: 50,
              due_at: Time.zone.today + 5,
              budget_id: budget.id,
              kind: 'fixed'
            }
          }
        end

        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        xit 'updates the right amount of expenses' do
          request

          expect(Expense.count).to eq Expense::FIXED_EXPENSES_QUANTITY
        end

        it 'updates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense b',
            price_in_cents: 50_00,
            budget_id: budget.id,
            kind: 'fixed'
          )
        end
      end

      context 'and updating expenses with installments' do
        let(:params) do
          {
            expense: {
              name: 'expense b',
              price: 50,
              due_at: Time.zone.today + 5,
              budget_id: budget.id,
              kind: 'installment',
              installment_number: 3
            }
          }
        end

        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        xit 'updates the right amount of expenses' do
          request

          expect(Expense.count).to eq 3
        end

        it 'updates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense b',
            price_in_cents: 50_00,
            budget_id: budget.id,
            kind: 'installment'
          )
        end
      end

      context 'and updating single expense' do
        let(:params) do
          {
            expense: {
              name: 'expense b',
              price: 50,
              due_at: Time.zone.today + 5,
              budget_id: budget.id,
              kind: 'installment',
              installment_number: 3
            }
          }
        end

        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        xit 'updates the right amount of expenses' do
          request

          expect(Expense.count).to eq 3
        end

        it 'updates the expense with the right data' do
          request

          expect(Expense.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'expense b',
            price_in_cents: 50_00,
            budget_id: budget.id,
            kind: 'once'
          )
        end
      end
    end

    xcontext 'when validation fails' do
      let(:params) do
        {
          expense: {
            name: nil
          }
        }
      end

      it 'is returns :unprocessable_entity status' do
        request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        request

        expect(JSON.parse(response.body).with_indifferent_access).to match(
          {
            error: {
              message: 'Erro de validação',
              details: ['Name não pode ficar em branco']
            }
          }.with_indifferent_access
        )
      end
    end
  end

  xdescribe 'DELETE /delete' do
    subject(:request) { delete "/api/expenses/#{expense_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let!(:expense) { create(:expense, name: 'expense to delete') }
    let(:expense_id) { expense.id }

    context 'when not logged in' do
      let(:headers) do
        { 'Accept' => 'application/json' }
      end

      it 'returns unauthorized' do
        request

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when logged in' do
      let(:token) { user.generate_jwt }
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      context 'when successful' do
        it 'is returns :no_content status' do
          request
          expect(response).to have_http_status(:no_content)
        end

        it 'creates the expense on the db' do
          request

          expect(Expense.find_by(name: 'expense to delete')).to be_nil
        end
      end

      xcontext 'when validation fails' do
        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              error: {
                message: 'Erro de exclusão',
                type: 'BadRequest'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when not found' do
        subject(:request) { delete '/api/expenses/non-existing', params: {}, headers: }

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:not_found)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              error: {
                message: 'Recurso não encontrado',
                type: 'NotFoundError'
              }
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'PUT /pay' do
    subject(:request) { put "/api/expenses/#{expense.id}/pay", params: {}, headers: }

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:expense) { create(:expense) }

    it 'is returns :ok status' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'updates the expense status to paid' do
      request
      expect(expense.reload.status).to eq('paid')
    end
  end

  describe 'PUT /unpay' do
    subject(:request) { put "/api/expenses/#{expense.id}/unpay", params: {}, headers: }

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    context 'when expense is late' do
      let(:expense) { create(:expense, :late) }

      it 'is returns :ok status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'updates the expense status to overdue' do
        request
        expect(expense.reload.status).to eq('overdue')
      end
    end

    context 'when expense is not late' do
      let(:expense) { create(:expense) }

      it 'is returns :ok status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'updates the expense status to created' do
        request
        expect(expense.reload.status).to eq('created')
      end
    end
  end
end
