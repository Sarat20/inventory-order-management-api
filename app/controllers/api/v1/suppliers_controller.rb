module Api
  module V1
    class SuppliersController < BaseController
      before_action :set_supplier, only: %i[update destroy]

      def index
        authorize Supplier
        render json: { success: true, data: Supplier.all }
      end

      def create
        supplier = Supplier.new(supplier_params)
        authorize supplier
        supplier.save!

        render json: { success: true, data: supplier }, status: :created
      end

      def update
        authorize @supplier
        @supplier.update!(supplier_params)

        render json: { success: true, data: @supplier }
      end

      def destroy
        authorize @supplier
        @supplier.destroy
        render json: { success: true }
      end

      private

      def set_supplier
        @supplier = Supplier.find(params[:id])
      end

      def supplier_params
        params.require(:supplier).permit(:name, :email)
      end
    end
  end
end
