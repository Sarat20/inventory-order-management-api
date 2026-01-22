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
        
        Audited.store[:comment] = "Order created by #{current_user.email}"
        order.save!
        render json: { success: true, data: order }, status: :created
      end

      def confirm
        authorize @order, :confirm?

        unless @order.may_confirm?
          return render json: { error: "Order cannot be confirmed in its current state" }, status: :unprocessable_entity
        end
         
        Audited.store[:comment] = "Order confirmed by #{current_user.email}"
      
        @order.confirm!
        render json: { success: true, data: @order }
      end

      def ship
        authorize @order, :ship?
        unless @order.may_ship?
          return render json: { error: "Order cannot be shipped in its current state" }, status: :unprocessable_entity
        end   
        
        Audited.store[:comment] = "Order shipped by #{current_user.email}"
        @order.ship!
        render json: { success: true, data: @order }
      end

      def cancel
        authorize @order, :cancel?
        
        unless @order.may_cancel?
          return render json: { error: "Order cannot be cancelled in its current state" }, status: :unprocessable_entity
        end
        Audited.store[:comment] = "Order cancelled by #{current_user.email}"
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
