module Api
  module V1
    class OrdersController < BaseController

      def index
        orders = Order.includes(:customer, :order_items, :products)
        render json: { success: true, data: orders }
      end

      def show
        order = Order.includes(:order_items, :products).find(params[:id])
        render json: { success: true, data: order }
      end

      def create
        order = Order.create!(order_params)
        render json: { success: true, data: order }, status: :created
      end

      def confirm
        order = Order.find(params[:id])
        order.confirm!
        render json: { success: true, data: order }
      end

      def ship
        order = Order.find(params[:id])
        order.ship!
        render json: { success: true, data: order }
      end

      def cancel
        order = Order.find(params[:id])
        order.cancel!
        render json: { success: true, data: order }
      end

      private

      def order_params
        params.require(:order).permit(
          :customer_id,
          order_items_attributes: [:product_id, :quantity]
        )
      end
    end
  end
end
