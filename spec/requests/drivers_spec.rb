# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Drivers' do
  describe 'GET /index' do
    subject(:request) { get '/api/drivers', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let!(:all_drivers) do
      create_list(:user, 30, role: 'driver')
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

      it 'lists all drivers' do
        request
        expect(json_body[:drivers].length).to eq(User.drivers.count)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/drivers', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        driver: {
          name: 'driver a',
          phone: '62993328319'
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

      it 'is returns :created status' do
        request
        expect(response).to have_http_status(:created)
      end

      it 'creates the driver on the db' do
        request

        expect(JSON.parse(response.body).with_indifferent_access).to match(
          {
            driver: {
              id: Integer,
              name: 'driver a',
              phone: '62993328319'
            }
          }.with_indifferent_access
        )
      end
    end
  end

  describe 'PUT /update' do
    subject(:request) { put "/api/drivers/#{driver.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:driver) { create(:user, :driver) }

    let(:params) do
      {
        driver: {
          name: 'driver b',
          phone: '62993328319'
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

      it 'is returns :ok status' do
        request
        expect(response).to have_http_status(:ok)
      end

      it 'creates the driver on the db' do
        request

        json_body = JSON.parse(response.body, symbolize_names: true)

        expect(json_body).to match(
          driver: {
            id: Integer,
            name: 'driver b',
            phone: '62993328319'
          }
        )
      end
    end
  end

  describe 'DELETE /delete' do
    subject(:request) { delete "/api/drivers/#{driver.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:driver) { create(:user, :driver, name: 'driver to delete') }

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

      it 'is returns :no_content status' do
        request
        expect(response).to have_http_status(:no_content)
      end

      it 'creates the driver on the db' do
        request

        expect(User.find_by(name: 'driver to delete')).to be_nil
      end
    end
  end
end
