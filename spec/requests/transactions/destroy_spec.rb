# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
  describe 'DELETE /delete' do
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
end
