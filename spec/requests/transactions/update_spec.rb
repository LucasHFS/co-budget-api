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
    let!(:collection) { create(:collection, :with_transactions) }
    let(:transaction) { collection.transactions.first }
    let(:budget) { create(:budget) }

    context 'when successful' do
      context 'with all transactions' do
        let(:params) do
          {
            transaction: {
              name: 'transaction b',
              price: 55.7,
              target_transactions: 'all'
            }
          }
        end

        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        # it 'updates the right amount of transactions' do
        #   expect { request }.to change(Transaction, :count).by(3)
        # end

        it 'updates the transaction with the right data' do
          request

          expect(collection.transactions.pluck(:name, :price_in_cents).uniq.flatten).to eq(
            ['transaction b', 5570]
          )
        end
      end

      # context 'with this_and_next transactions' do
      #   let(:params) do
      #     {
      #       transaction: {
      #         name: 'transaction b',
      #         price: 55.7,
      #         target_transactions: 'this_and_next'
      #       }
      #     }
      #   end

      #   it 'is returns :ok status' do
      #     request
      #     expect(response).to have_http_status(:ok)
      #   end

      #   # it 'updates the right amount of transactions' do
      #   #   expect { request }.to change(Transaction, :count).by(3)
      #   # end

      #   it 'updates the transaction with the right data' do
      #     request

      #     expect(collection.transactions.pluck(:name, :price_in_cents).uniq).to eq(
      #       ["transaction b", 5570]
      #     )
      #   end
      # end

      context 'with single transaction' do
        let(:params) do
          {
            transaction: {
              name: 'transaction b',
              price: 55.7,
            }
          }
        end

        it 'is returns :ok status' do
          request
          expect(response).to have_http_status(:ok)
        end

        # it 'updates the right amount of transactions' do
        #   expect { request }.to change(Transaction, :count).by(1)
        # end

        it 'updates the transaction with the right data' do
          request

          expect(transaction.reload.attributes.transform_keys(&:to_sym)).to include(
            name: 'transaction b',
            price_in_cents: 55_70
          )
        end
      end
    end

    context 'when validation fails' do
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
