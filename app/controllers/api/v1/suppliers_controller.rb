module Api
  module V1
    # NOTE: This controller is missing a show action, which is defined in the routes via
    # resources :suppliers. This will result in an AbstractController::ActionNotFound error
    # if someone hits GET /api/v1/suppliers/:id.
    class SuppliersController < BaseController
     
      before_action :set_supplier, only: %i[show update destroy]

      def index
        authorize Supplier

        suppliers = Supplier.order(:id).page(params[:page]).per(10)

        render json: {
          success: true,
          data: SupplierSerializer.new(suppliers).serializable_hash,   
          meta: {
            page: suppliers.current_page,
            total_pages: suppliers.total_pages,
            total_count: suppliers.total_count
          }
        }
      end

      
      def show
        authorize @supplier

        render json: {
          success: true,
          data: SupplierSerializer.new(@supplier).serializable_hash
        }
      end

      def create
        supplier = Supplier.new(supplier_params)
        authorize supplier
        supplier.save!

        render json: {
          success: true,
          data: SupplierSerializer.new(supplier).serializable_hash   
        }, status: :created
      end

      def update
        authorize @supplier
        @supplier.update!(supplier_params)

        render json: {
          success: true,
          data: SupplierSerializer.new(@supplier).serializable_hash   
        }
      end

      def destroy
        authorize @supplier

    
        if @supplier.destroy
          render json: { success: true }
        else
          render json: {
            success: false,
            error: {
              code: "DEPENDENT_RECORDS_EXIST",
              messages: @supplier.errors.full_messages
            }
          }, status: :unprocessable_entity
        end
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
