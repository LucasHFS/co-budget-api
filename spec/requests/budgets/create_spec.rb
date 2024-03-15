# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Budgets' do
  describe 'POST /create' do
    subject(:request) { post '/api/budgets', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        budget: {
          name: 'budget a'
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

        it 'creates the budget on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              budget: {
                id: Integer,
                name: 'budget a'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            budget: {
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
end
