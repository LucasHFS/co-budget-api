# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
  describe 'GET /index' do
    subject(:request) { get "/api/transactions?budgetId=#{budget.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:budget) { create(:budget, users: [user]) }

    before do
      create_list(:transaction, 5, budget:)
      create_list(:transaction, 5)
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

      it "lists all user's transactions" do
        request
        expect(json_body[:transactions].length).to eq(5)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/transactions', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:budget) { create(:budget) }

    let(:params) do
      {
        transaction: {
          name: 'transaction a',
          price: 100,
          due_at: Time.zone.today + 5,
          budget_id: budget.id
        }
      }
    end

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    context 'when successful' do
      context 'and creating a fixed transactions' do
        let(:params) do
          {
            transaction: {
              name: 'transaction a',
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

        it 'creates the right amount of transactions' do
          request

          expect(Transaction.count).to eq Transaction::FIXED_TRANSACTIONS_QUANTITY
        end

        it 'creates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'fixed'
          )
        end
      end

      context 'and creating transactions with installments' do
        let(:params) do
          {
            transaction: {
              name: 'transaction a',
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

        it 'creates the right amount of transactions' do
          request

          expect(Transaction.count).to eq 3
        end

        it 'creates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'installment'
          )
        end
      end

      context 'and creating single transaction' do
        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the right amount of transactions' do
          request

          expect(Transaction.count).to eq 1
        end

        it 'creates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction a',
            price_in_cents: 100_00,
            budget_id: budget.id,
            kind: 'once'
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            transaction: {
              name: 'transaction a',
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
    subject(:request) { put "/api/transactions/#{transaction.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end
    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:user) { create(:user) }
    let(:transaction) { create(:transaction) }
    let(:budget) { create(:budget) }

    let(:params) do
      {
        transaction: {
          name: 'transaction b',
          price: 100,
          due_at: Time.zone.today + 5,
          budget_id: budget.id
        }
      }
    end

    let(:headers) { { 'Authorization' => "Bearer #{token}" } }
    let(:token) { user.generate_jwt }

    context 'when successful' do
      context 'and updating a fixed transactions' do
        let(:params) do
          {
            transaction: {
              name: 'transaction b',
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

        xit 'updates the right amount of transactions' do
          request

          expect(Transaction.count).to eq Transaction::FIXED_TRANSACTIONS_QUANTITY
        end

        it 'updates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction b',
            price_in_cents: 50_00,
            budget_id: budget.id,
            kind: 'fixed'
          )
        end
      end

      context 'and updating transactions with installments' do
        let(:params) do
          {
            transaction: {
              name: 'transaction b',
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

        xit 'updates the right amount of transactions' do
          request

          expect(Transaction.count).to eq 3
        end

        it 'updates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction b',
            price_in_cents: 50_00,
            budget_id: budget.id,
            kind: 'installment'
          )
        end
      end

      context 'and updating single transaction' do
        let(:params) do
          {
            transaction: {
              name: 'transaction b',
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

        xit 'updates the right amount of transactions' do
          request

          expect(Transaction.count).to eq 3
        end

        it 'updates the transaction with the right data' do
          request

          expect(Transaction.last.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction b',
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
          transaction: {
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
    subject(:request) { delete "/api/transactions/#{transaction_id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let!(:transaction) { create(:transaction, name: 'transaction to delete') }
    let(:transaction_id) { transaction.id }

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

        it 'creates the transaction on the db' do
          request

          expect(Transaction.find_by(name: 'transaction to delete')).to be_nil
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
        subject(:request) { delete '/api/transactions/non-existing', params: {}, headers: }

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
    subject(:request) { put "/api/transactions/#{transaction.id}/pay", params: {}, headers: }

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:transaction) { create(:transaction) }

    it 'is returns :ok status' do
      request
      expect(response).to have_http_status(:ok)
    end

    it 'updates the transaction status to paid' do
      request
      expect(transaction.reload.status).to eq('paid')
    end
  end

  describe 'PUT /unpay' do
    subject(:request) { put "/api/transactions/#{transaction.id}/unpay", params: {}, headers: }

    let(:token) { user.generate_jwt }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    context 'when transaction is late' do
      let(:transaction) { create(:transaction, :late) }

      it 'is returns :ok status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'updates the transaction status to overdue' do
        request
        expect(transaction.reload.status).to eq('overdue')
      end
    end

    context 'when transaction is not late' do
      let(:transaction) { create(:transaction) }

      it 'is returns :ok status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'updates the transaction status to created' do
        request
        expect(transaction.reload.status).to eq('created')
      end
    end
  end
end
