# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
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
