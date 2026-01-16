module Api
  module V1
    class ProductsController < BaseController

      def index
        products = Product.all

       
        if params[:min_price].present?
          products = products.price_greater_than(params[:min_price].to_f)
        end

        if params[:max_price].present?
          products = products.price_less_than(params[:max_price].to_f)
        end

        if params[:category_id].present?
          products = products.by_category(params[:category_id])
        end

        if params[:in_stock].present?
          products = products.in_stock
        end
        
        render json: {
          success: true,
          data: products,
          meta: { total: products.count }
        }
      end

      def show
        product = Product.find(params[:id])
        render json: { success: true, data: product }
      end

      def create
        product = Product.create!(product_params)
        render json: { success: true, data: product }, status: :created
      end
      
      def update
        product = Product.find(params[:id])
        product.update!(product_params)
        render json: { success: true, data: product }
      end

      def destroy
        product = Product.find(params[:id])
        product.destroy
        render json: { success: true }
      end

      private

      def product_params
        params.require(:product).permit(
          :name,
          :price,
          :quantity,
          :category_id,
          :supplier_id
        )
      end
    end
  end
end
