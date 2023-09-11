# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders' do
  # describe 'GET /deliveries' do
  #   subject(:request) do
  #     get '/api/deliveries',
  #         params:, headers:
  #   end

  #   let(:json_body) do
  #     JSON.parse(response.body, symbolize_names: true).with_indifferent_access
  #   end

  #   let(:user) { create(:user) }
  #   let(:token) { user.generate_jwt }
  #   let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  #   let(:sale_event) { create(:sale_event) }
  #   let!(:delivery) { create(:delivery, sale_event:) }

  #   let(:params) { { saleEventId: sale_event.id } }

  #   it 'is successful' do
  #     request
  #     expect(response).to have_http_status(:success)
  #   end

  #   it 'lists all deliveries' do
  #     request

  #     expect(json_body).to match({
  #       deliveries_by_state: {
  #         'Registrado' => {
  #           'deliveries' => [
  #             {
  #               'deliveredAt' => nil,
  #               'deliveryAddress' => nil,
  #               'id' => delivery.id,
  #               'instructions' => nil,
  #               'order' => {
  #                 'client' => {
  #                   'address' => '141 Rua Breno, Tenente Ananias, GO 79670-110',
  #                   'district' => 'Autumn Gardens',
  #                   'gpsLink' => 'http://morissette.org/werner',
  #                   'id' => 165,
  #                   'name' => 'Yasmin Coutinho',
  #                   'phone' => '(91) 99236-6264',
  #                   'referencePoint' => 'reference point'
  #                 },
  #                 'id' => Integer,
  #                 'isDelivery' => true,
  #                 'notes' => 'order notes',
  #                 'price' => 0.0,
  #                 'products' => [
  #                   { 'id' => Integer, 'name' => 'Gorgeous Granite Plate', 'price' => 15.91, 'quantity' => 2 },
  #                   { 'id' => Integer, 'name' => 'Enormous Rubber Pants', 'price' => 1.2, 'quantity' => 1 }
  #                 ],
  #                 'status' => 'Registrado'
  #               },
  #               'status' => 'Registrado'
  #             }
  #           ]
  #         }
  #       }
  #     }.with_indifferent_access)
  #   end
  # end
end
