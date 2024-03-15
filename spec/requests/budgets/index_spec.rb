# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Budgets' do
  describe 'GET /index' do
    subject(:request) { get '/api/budgets', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    before do
      create_list(:budget, 5, users: [user])
      create_list(:budget, 3)
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

      it "lists all user's budgets" do
        request
        expect(json_body[:budgets].length).to eq(5)
      end
    end
  end
end
