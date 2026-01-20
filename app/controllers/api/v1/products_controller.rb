module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]

      def index
        authorize Product

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
        authorize @product
        render json: { success: true, data: @product }
      end

      def create
        product = Product.new(product_params)
        authorize product
        product.save!

        render json: { success: true, data: product }, status: :created
      end

      def update
        authorize @product
        @product.update!(product_params)

        render json: { success: true, data: @product }
      end

      def destroy
        authorize @product
        @product.destroy

        render json: { success: true }
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

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
