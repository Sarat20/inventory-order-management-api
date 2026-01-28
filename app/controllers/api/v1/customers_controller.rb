module Api
  module V1
    class CustomersController < BaseController
      before_action :set_customer, only: %i[show update destroy]

      def index
        authorize Customer
        # NOTE: Customer.all without pagination could be a performance concern as the dataset grows.
        # Other controllers (like SuppliersController) paginate their index actions.
        # Consider whether consistency and scalability warrant pagination here as well.
        customers = Customer.all

        render json: {
          success: true,
          data: CustomerSerializer.new(customers).serializable_hash
        }
      end

      def show
        authorize @customer

        render json: {
          success: true,
          data: CustomerSerializer.new(@customer).serializable_hash
        }
      end

      def create
        customer = Customer.new(customer_params)
        authorize customer
        customer.save!

        render json: {
          success: true,
          data: CustomerSerializer.new(customer).serializable_hash
        }, status: :created
      end

      def update
        authorize @customer
        @customer.update!(customer_params)

        render json: {
          success: true,
          data: CustomerSerializer.new(@customer).serializable_hash
        }
      end

      def destroy
        authorize @customer
        @customer.destroy

        render json: { success: true }
      end

      private

      def set_customer
        @customer = Customer.find(params[:id])
      end

      def customer_params
        params.require(:customer).permit(:name, :email)
      end
    end
  end
end
