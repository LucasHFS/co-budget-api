module Orders
  class Update
    def initialize(order, order_params)
      @order = order
      @order_params = order_params
    end

    def call
      order_params[:products].map do |product|
        # remove line_items
        if product[:remove]
          order.line_items.find_by_product_id(product[:id])&.destroy
        else
          line_item = order.line_items.find_by_product_id(product[:id])
          if line_item
            # update line items
            line_item.update!(quantity: product[:quantity]) unless line_item.quantity == product[:quantity]
          else
            # create line items
            order.line_items.create!(product_id: product[:id], quantity: product[:quantity])
          end
        end
      end

      # update client params
      user = User.find(order_params[:client][:id])

      user.update!(
        name: order_params[:client][:name],
        address: order_params[:client][:address],
        phone: order_params[:client][:phone],
        gps_link: order_params[:client][:gpsLink],
        reference_point: order_params[:client][:referencePoint],
        district: order_params[:client][:district]
      )

      order.update!(
        is_delivery: order_params[:isDelivery],
        notes: order_params[:notes]
      )

      Response.new(record: order)
    end

    private

    attr_reader :order_params, :order
  end
end
