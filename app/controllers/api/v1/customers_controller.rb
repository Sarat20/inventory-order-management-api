module Api
  module V1
    class CustomersController < BaseController

      def index
        render json: { success: true, data: Customer.all }
      end

      def create
        customer = Customer.create!(customer_params)
        render json: { success: true, data: customer }, status: :created
      end
     
      def show
        data=Customer.find(params[:id])
        render json: { success: true, data: data }
      end
      
      def update
        customer = Customer.find(params[:id])
        customer.update!(customer_params)
        render json: { success: true, data: customer }
      end

      def destroy
        Customer.find(params[:id]).destroy
        render json: { success: true }
      end

      private

      def customer_params
        params.require(:customer).permit(:name, :email)
      end
    end
  end
end
