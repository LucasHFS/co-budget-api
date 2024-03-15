# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions' do
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
end
