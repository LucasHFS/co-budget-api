# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
  describe 'PUT /update' do
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
end
