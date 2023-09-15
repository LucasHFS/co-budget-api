# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Expenses' do
  describe 'GET /index' do
    subject(:request) { get '/api/expenses', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let!(:all_expenses) do
      create_list(:expense, 30)
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
        expect(json_body[:expenses].length).to eq(Expense.count)
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
        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the expense on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              expense: {
                id: Integer,
                name: 'expense a',
                price: 100.0,
                due_at: (Time.zone.today + 5).strftime('%Y-%m-%d'),
                budget_id: budget.id
              }
            }.with_indifferent_access
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

  describe 'PUT /update' do
    subject(:request) { put "/api/expenses/#{expense.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

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
        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        it 'creates the expense on the db' do
          request

          created_expense = Expense.last.attributes.transform_keys(&:to_sym)

          expect(created_expense).to include(
            {
              name: 'expense b'
            }
          )
        end
      end

      context 'when validation fails' do
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
  end

  describe 'DELETE /delete' do
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

  describe 'PUT /pay_out' do
    subject(:request) { put "/api/expenses/#{expense.id}/pay_out", params: {}, headers: }

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

  describe 'PUT /unpay_out' do
    subject(:request) { put "/api/expenses/#{expense.id}/unpay_out", params: {}, headers: }

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
