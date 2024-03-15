# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Budgets' do
  describe 'PUT /update' do
    subject(:request) { put "/api/budgets/#{budget.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:budget) { create(:budget, users: [user]) }

    let(:params) do
      {
        budget: {
          name: 'budget b'
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

        it 'creates the budget on the db' do
          request

          created_budget = Budget.last.attributes.transform_keys(&:to_sym)

          expect(created_budget).to include(
            {
              name: 'budget b'
            }
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
