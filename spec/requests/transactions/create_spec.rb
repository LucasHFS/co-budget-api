# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
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
end
