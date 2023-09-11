# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products' do
  describe 'GET /index' do
    subject(:request) { get '/api/products', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let!(:all_products) do
      create_list(:product, 30)
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

      it 'lists all products' do
        request
        expect(json_body[:products].length).to eq(Product.count)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/products', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        product: {
          name: 'product a',
          price: 17.5
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

        it 'creates the product on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              product: {
                id: Integer,
                name: 'product a',
                price: 17.5
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            product: {
              name: nil,
              price: 17.5
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
              },
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'PUT /update' do
    subject(:request) { put "/api/products/#{product.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:product) { create(:product) }

    let(:params) do
      {
        product: {
          name: 'product b',
          price: 20.5
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

        it 'creates the product on the db' do
          request

          created_product = Product.last.attributes.transform_keys(&:to_sym)

          expect(created_product).to include(
            {
              name: 'product b',
              price_in_cents: 20_50
            }
          )
        end
      end

      context 'when validation fails' do
        let(:params) do
          {
            product: {
              name: nil,
              price: 17.5
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
              },
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'DELETE /delete' do
    subject(:request) { delete "/api/products/#{product.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:product) { create(:product, name: 'product to delete') }

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

        it 'creates the product on the db' do
          request

          expect(Product.find_by(name: 'product to delete')).to be_nil
        end
      end

      context 'when validation fails' do
        before do
          LineItem.create(quantity: 1, product:,order: create(:order))
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
                message: 'Erro de exclusão',
                details: ['não foi possivel excluir o produto']
              },
            }.with_indifferent_access
          )
        end
      end

      context 'when not found' do
        subject(:request) { delete "/api/products/non-existing", params: {}, headers: }

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:not_found)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              error: {
                message: 'Não encontrado'
              },
            }.with_indifferent_access
          )
        end
      end
    end
  end
end
