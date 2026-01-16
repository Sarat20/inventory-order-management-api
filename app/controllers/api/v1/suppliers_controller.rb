module Api
  module V1
    class SuppliersController < BaseController

      def index
        render json: { success: true, data: Supplier.all }
      end

      def create
        supplier = Supplier.create!(supplier_params)
        render json: { success: true, data: supplier }, status: :created
      end

      def update
        supplier = Supplier.find(params[:id])
        supplier.update!(supplier_params)
        render json: { success: true, data: supplier }
      end

      def destroy
        Supplier.find(params[:id]).destroy
        render json: { success: true }
      end

      private

      def supplier_params
        params.require(:supplier).permit(:name, :email)
      end
    end
  end
end
