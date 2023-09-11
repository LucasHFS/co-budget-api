# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients' do
  describe 'GET /index' do
    subject(:request) { get '/api/clients', params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let!(:all_clients) do
      create_list(:user, 30, role: 'client')
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

      it 'lists all clients' do
        request
        expect(json_body[:clients].length).to eq(User.clients.count)
      end
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/clients', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }

    let(:params) do
      {
        client: {
          name: 'client a',
          address: 'address a',
          gpsLink: 'gps_link_a',
          phone: '62993328319',
          referencePoint: 'reference point a',
          district: 'district a'
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

      it 'creates the client on the db' do
        request

        expect(JSON.parse(response.body).with_indifferent_access).to match(
          {
            client: {
              id: Integer,
              name: 'client a',
              address: 'address a',
              phone: '62993328319',
              gpsLink: 'gps_link_a',
              referencePoint: 'reference point a',
              district: 'district a'
            }
          }.with_indifferent_access
        )
      end
    end
  end

  describe 'PUT /update' do
    subject(:request) { put "/api/clients/#{client.id}", params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:client) { create(:user, :client) }

    let(:params) do
      {
        client: {
          name: 'client b',
          address: 'address a',
          phone: '62993328319',
          gpsLink: 'gps_link_a',
          referencePoint: 'reference point a',
          district: 'district a'
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

      it 'creates the client on the db' do
        request

        json_body = JSON.parse(response.body, symbolize_names: true)

        expect(json_body).to match(
          client: {
            id: Integer,
            name: 'client b',
            address: 'address a',
            phone: '62993328319',
            gpsLink: 'gps_link_a',
            referencePoint: 'reference point a',
            district: 'district a'
          }
        )
      end
    end
  end

  describe 'DELETE /delete' do
    subject(:request) { delete "/api/clients/#{client.id}", params: {}, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:user) { create(:user) }
    let(:client) { create(:user, :client, name: 'client to delete') }

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

      it 'creates the client on the db' do
        request

        expect(User.find_by(name: 'client to delete')).to be_nil
      end
    end
  end
end
