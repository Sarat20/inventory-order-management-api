module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: %i[show confirm ship cancel]

      def index
        authorize Order
        orders = Order.includes(:customer, :order_items, :products)
        render json: { success: true, data: orders }
      end

      def show
        authorize @order
        render json: { success: true, data: @order }
      end

      def create
        order = Order.new(order_params)
        authorize order
        order.save!

        render json: { success: true, data: order }, status: :created
      end

      def confirm
        authorize @order, :confirm?
        @order.confirm!
        render json: { success: true, data: @order }
      end

      def ship
        authorize @order, :ship?
        @order.ship!
        render json: { success: true, data: @order }
      end

      def cancel
        authorize @order, :cancel?
        @order.cancel!
        render json: { success: true, data: @order }
      end

      private

      def set_order
        @order = Order.find(params[:id])
      end

      def order_params
        params.require(:order).permit(
          :customer_id,
          order_items_attributes: %i[product_id quantity]
        )
      end
    end
  end
end
