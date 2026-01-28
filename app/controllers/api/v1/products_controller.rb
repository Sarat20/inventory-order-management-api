module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]

      def index
        authorize Product

        # NOTE: If cache key parameters come from user input, consider whether there's any risk
        # of cache key explosion (e.g., unbounded min_price/max_price combinations).
        cache_key = "products/index/#{params[:min_price]}-#{params[:max_price]}-#{params[:category_id]}-#{params[:in_stock]}-#{params[:page]}"

        result = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
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

          paginated = products.order(:id).page(params[:page]).per(2)

          {
            ids: paginated.pluck(:id),
            meta: {
              page: paginated.current_page,
              total_pages: paginated.total_pages,
              total_count: paginated.total_count
            }
          }
        end

        # NOTE: The result[:ids] array won't preserve ordering from the cache.
        # If ordering matters, you may need to reorder after the where(id: ...) fetch.
        products = Product.includes(:category, :supplier).where(id: result[:ids])

        render json: {
          success: true,
          data: ProductSerializer.new(products).serializable_hash,
          meta: result[:meta]
        }
      end

      def show
        authorize @product

        # NOTE: Caching the ActiveRecord object directly works, but the entire serialized object
        # goes into cache. If the Product model grows in complexity, this could become expensive.
        # Consider caching the serialized hash instead.
        product = Rails.cache.fetch("product/#{@product.id}", expires_in: 1.hour) do
          @product
        end

        render json: {
          success: true,
          data: ProductSerializer.new(product).serializable_hash
        }
      end

      def create
        product = Product.new(product_params)
        authorize product
        product.save!

        render json: {
          success: true,
          data: ProductSerializer.new(product).serializable_hash
        }, status: :created
      end

      def update
        authorize @product
        @product.update!(product_params)

        render json: {
          success: true,
          data: ProductSerializer.new(@product).serializable_hash
        }
      end

      def destroy
        authorize @product
        @product.destroy

        render json: { success: true }
      end

      private

      def set_product
        @product = Product.includes(:category, :supplier).find(params[:id])
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
