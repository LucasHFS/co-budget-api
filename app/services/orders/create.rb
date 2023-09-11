module Orders
  class Create
    def initialize(order_params)
      @order_params = order_params
    end

    def call
      order = Order.new(order_attributes)

      if order.save
        Response.new(record: order)
      else
        Response.new(error: { message: 'Erro de validação', details: order.errors.full_messages })
      end
    rescue StandardError => e
      Response.new(error: { message: e.message })
    end

    private

    attr_reader :order_params

    def order_attributes
      attributes = { client:, line_items:, is_delivery: order_params[:isDelivery], notes: order_params[:notes] }

      if order_params[:saleEventId]
        sale_event = SaleEvent.find(order_params[:saleEventId])
        attributes[:sale_event] = sale_event
      end

      attributes
    end

    def line_items
      order_params[:products].map do |product|
        raise 'Quantidade do produto nao pode ser menor que' if product[:quantity] && product[:quantity].to_i < 1

        LineItem.new(product_id: product[:id], quantity: product[:quantity])
      end
    end

    def client
      if order_params[:client][:id]
        user = User.find(order_params[:client][:id])
        update_user_data(user)
      else
        User.create!(client_attributes)
      end
    end

    def update_user_data(user)
      user.address = order_params[:client][:address]
      user.gps_link = order_params[:client][:gpsLink]
      user.phone = order_params[:client][:phone]
      user.reference_point = order_params[:client][:referencePoint]
      user.district = order_params[:client][:district]
      user.save!
      user
    end

    def client_attributes
      {
        name: order_params[:client][:name],
        address: order_params[:client][:address],
        phone: order_params[:client][:phone],
        gps_link: order_params[:client][:gpsLink],
        reference_point: order_params[:client][:referencePoint],
        district: order_params[:client][:district],
        role: 'client'
      }
    end
  end
end
