# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders' do
  let(:user) { create(:user) }
  let(:token) { user.generate_jwt }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /index' do
    subject(:request) { get '/api/orders', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true).with_indifferent_access
    end

    let(:sale_event) { create(:sale_event) }

    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, :sent, sale_event:) }

    let!(:order7) { create(:order) }

    let(:params) do
      {
        saleEventId: sale_event.id
      }
    end

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    context 'without filters' do
      let(:params) { { saleEventId: sale_event.id } }

      it 'lists all orders' do
        request

        expect(json_body).to match({
          orders: [
            {
              client: {
                address: String,
                district: String,
                gpsLink: String,
                id: Integer,
                name: String,
                phone: String,
                referencePoint: String
              },
              id: Integer,
              isDelivery: true,
              notes: String,
              price: Float,
              products: [
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                },
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                }
              ],
              status: 'Registrado'
            },
            {
              client: {
                address: String,
                district: String,
                gpsLink: String,
                id: Integer,
                name: String,
                phone: String,
                referencePoint: String
              },
              id: Integer,
              isDelivery: true,
              notes: String,
              price: Float,
              products: [
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                },
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                }
              ],
              status: 'Enviado'
            }
          ]
        }.with_indifferent_access)
      end
    end

    context 'with filters' do
      let(:params) { { saleEventId: sale_event.id, sent: true } }

      it 'lists all sent orders' do
        request

        expect(json_body).to match({
          orders: [
            {
              client: {
                address: String,
                district: String,
                gpsLink: String,
                id: Integer,
                name: String,
                phone: String,
                referencePoint: String
              },
              id: Integer,
              isDelivery: true,
              notes: String,
              price: Float,
              products: [
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                },
                {
                  id: Integer,
                  name: String,
                  price: Float,
                  quantity: Integer
                }
              ],
              status: 'Enviado'
            }
          ]
        }.with_indifferent_access)
      end
    end
  end

  describe 'GET /by_state' do
    subject(:request) { get '/api/orders/by_state', params: { saleEventId: sale_event.id }, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true).with_indifferent_access
    end

    let(:sale_event) { create(:sale_event) }

    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }
    let!(:order3) { create(:order, :prepared, sale_event:) }
    let!(:order4) { create(:order, :sent, sale_event:) }
    let!(:order5) { create(:order, :completed, sale_event:) }
    let!(:order6) { create(:order, :canceled, sale_event:) }

    let!(:order7) { create(:order) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'lists all orders' do
      request
      expect(json_body).to match({
        orders_by_state: {
          Registrado: {
            orders: [
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Registrado'
              },
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Registrado'
              }
            ]
          },
          Preparado: {
            orders: [
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Preparado'
              }
            ]
          },
          Enviado: {
            orders: [
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Enviado'
              }
            ]
          },
          Cancelado: {
            orders: [
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Cancelado'
              }
            ]
          },
          Finalizado: {
            orders: [
              {
                client: {
                  address: String,
                  district: String,
                  gpsLink: String,
                  id: Integer,
                  name: String,
                  phone: String,
                  referencePoint: String
                },
                id: Integer,
                isDelivery: true,
                notes: String,
                price: Float,
                products: [
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  },
                  {
                    id: Integer,
                    name: String,
                    price: Float,
                    quantity: Integer
                  }
                ],
                status: 'Finalizado'
              }
            ]
          }
        }
      }.with_indifferent_access)
    end
  end

  describe 'POST /create' do
    subject(:request) { post '/api/orders', params:, headers: }

    let(:json_body) do
      JSON.parse(response.body, symbolize_names: true)
    end

    let!(:client) { create(:user, :client) }
    let(:product1) { create(:product, price_in_cents: 10_00) }
    let(:product2) { create(:product, price_in_cents: 15_00) }
    let(:sale_event) { create(:sale_event) }

    context 'when successful' do
      context 'when client is already created' do
        let(:params) do
          {
            order: {
              client: {
                address: 'Rua Bela Vista Quadra 1A Lote 15',
                phone: '62991431044',
                referencePoint: 'Muro Laranja, Portao Marrom',
                gpsLink: 'https://maps.google/lasdflk12',
                district: 'Setor Sao Joao',
                id: client.id
              },
              products: [
                { id: product1.id, quantity: 2 },
                { id: product2.id, quantity: 1 }
              ],
              saleEventId: sale_event.id,
              isDelivery: true,
              notes: 'Troco para R$50,00'
            }
          }
        end

        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the order on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              order: {
                client: {
                  name: client.name,
                  address: 'Rua Bela Vista Quadra 1A Lote 15',
                  phone: '62991431044',
                  referencePoint: 'Muro Laranja, Portao Marrom',
                  gpsLink: 'https://maps.google/lasdflk12',
                  district: 'Setor Sao Joao',
                  id: client.id
                },
                id: Integer,
                isDelivery: true,
                notes: 'Troco para R$50,00',
                price: 35.0,
                products: [
                  {
                    id: Integer,
                    name: product1.name,
                    price: product1.price.to_f,
                    quantity: 2
                  },
                  {
                    id: Integer,
                    name: product2.name,
                    price: product2.price.to_f,
                    quantity: 1
                  }
                ],
                status: 'Registrado'
              }
            }.with_indifferent_access
          )
        end
      end

      context 'when client is created at order creation' do
        let(:params) do
          {
            order: {
              client: {
                address: 'Rua Bela Vista Quadra 1A Lote 15',
                phone: '62991431044',
                referencePoint: 'Muro Laranja, Portao Marrom',
                gpsLink: 'https://maps.google/lasdflk12',
                district: 'Setor Sao Joao',
                name: 'Cliente 1'
              },
              products: [
                { id: product1.id, quantity: 2 },
                { id: product2.id, quantity: 1 }
              ],
              saleEventId: sale_event.id,
              isDelivery: true,
              notes: 'Troco para R$50,00'
            }
          }
        end

        it 'is returns :created status' do
          request
          expect(response).to have_http_status(:created)
        end

        it 'creates the order on the db' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              order: {
                client: {
                  name: 'Cliente 1',
                  address: 'Rua Bela Vista Quadra 1A Lote 15',
                  phone: '62991431044',
                  referencePoint: 'Muro Laranja, Portao Marrom',
                  gpsLink: 'https://maps.google/lasdflk12',
                  district: 'Setor Sao Joao',
                  id: Integer
                },
                id: Integer,
                isDelivery: true,
                notes: 'Troco para R$50,00',
                price: 35.0,
                products: [
                  {
                    id: Integer,
                    name: product1.name,
                    price: product1.price.to_f,
                    quantity: 2
                  },
                  {
                    id: Integer,
                    name: product2.name,
                    price: product2.price.to_f,
                    quantity: 1
                  }
                ],
                status: 'Registrado'
              }
            }.with_indifferent_access
          )
        end
      end
    end

    context 'when not successful' do
      context 'when client is not created' do
        let(:params) do
          {}
        end

        it 'is returns :unprocessable_entity status' do
          request
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not create the order on the db' do
          expect { request }.not_to change(Order, :count)
        end

        it 'returns the error message' do
          request

          expect(JSON.parse(response.body).with_indifferent_access).to match(
            {
              error: { details: ['param is missing or the value is empty: order'], message: 'Missing parameters', type: 'BadRequest' }
            }.with_indifferent_access
          )
        end
      end
    end
  end

  describe 'PUT /update' do
  end

  describe 'PUT /register' do
    subject(:request) { put '/api/orders/register', params: { ids: [order1.id, order2.id] }, headers: }

    let(:sale_event) { create(:sale_event) }
    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'registers the order' do
      request

      expect(order1.reload.pending?).to be true
      expect(order2.reload.pending?).to be true
    end
  end

  describe 'PUT /prepare' do
    subject(:request) { put '/api/orders/prepare', params: { ids: [order1.id, order2.id] }, headers: }

    let(:sale_event) { create(:sale_event) }
    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'prepares the order' do
      request

      expect(order1.reload.prepared?).to be true
      expect(order2.reload.prepared?).to be true
    end
  end

  describe 'PUT /send' do
    subject(:request) { put '/api/orders/send', params: { ids: [order1.id, order2.id], driverId: driver.id }, headers: }

    let(:driver) { create(:user, :driver) }
    let(:sale_event) { create(:sale_event) }
    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'sends the order' do
      request

      expect(order1.reload.sent?).to be true
      expect(order2.reload.sent?).to be true
    end
  end

  describe 'PUT /complete' do
    subject(:request) { put '/api/orders/complete', params: { ids: [order1.id, order2.id] }, headers: }

    let(:sale_event) { create(:sale_event) }
    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'completes the order' do
      request

      expect(order1.reload.completed?).to be true
      expect(order2.reload.completed?).to be true
    end
  end

  describe 'PUT /cancel' do
    subject(:request) { put '/api/orders/cancel', params: { ids: [order1.id, order2.id] }, headers: }

    let(:sale_event) { create(:sale_event) }
    let!(:order1) { create(:order, sale_event:) }
    let!(:order2) { create(:order, sale_event:) }

    it 'is successful' do
      request
      expect(response).to have_http_status(:success)
    end

    it 'cancels the order' do
      request

      expect(order1.reload.canceled?).to be true
      expect(order2.reload.canceled?).to be true
    end
  end
end
