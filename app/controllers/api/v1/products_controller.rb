module Api
  module V1
    class ProductsController < BaseController
      before_action :set_product, only: %i[show update destroy]

      def index
        authorize Product

        # NOTE:
        # If cache key parameters come from user input, consider whether there's any risk
        # of cache key explosion (e.g., unbounded min_price/max_price combinations).

        normalized_min_price =
          if params[:min_price].present?
            (params[:min_price].to_i / 100) * 100
          else
            "any"
          end

        normalized_max_price =
          if params[:max_price].present?
            (params[:max_price].to_i / 100) * 100
          else
            "any"
          end

        cache_key = [
          "products/index:v1",
          normalized_min_price,
          normalized_max_price,
          params[:category_id].presence || "any",
          params[:in_stock].presence || "any",
          params[:page].presence || 1
        ].join(":")

        result = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
          products = Product.all

          products = products.price_greater_than(params[:min_price].to_f) if params[:min_price].present?
          products = products.price_less_than(params[:max_price].to_f)    if params[:max_price].present?
          products = products.by_category(params[:category_id])            if params[:category_id].present?
          products = products.in_stock                                     if params[:in_stock].present?

          paginated = products.order(:id).page(params[:page]).per(2)

          # NOTE:
          # We only cache IDs and metadata, not full AR objects.
          # This keeps the cache light and avoids stale association data.
          {
            ids: paginated.pluck(:id),
            meta: {
              page: paginated.current_page,
              total_pages: paginated.total_pages,
              total_count: paginated.total_count
            }
          }
        end

        products = Product
          .includes(:category, :supplier)
          .where(id: result[:ids])
          .order(:id)

        render json: {
          success: true,
          data: ProductSerializer.new(products).serializable_hash,
          meta: result[:meta]
        }
      end

      def show
        authorize @product

        # NOTE:
        # Caching the ActiveRecord object directly works, but the entire object graph gets cached.
        # This can become expensive if Product grows in complexity.

        product_json = Rails.cache.fetch("product/#{@product.id}", expires_in: 1.hour) do
          ProductSerializer.new(@product).serializable_hash
        end

        render json: {
          success: true,
          data: product_json
        }
      end

      def create
        product = Product.new(product_params)
        authorize product
        product.save!

        # NOTE:
        # Instead of trying to guess which index cache keys to delete,
        # we rely on versioned keys ("products/index:v1") in Product model.
        #
        # Still deleting broadly here for safety.
        Rails.cache.delete_matched("products/index*")

        render json: {
          success: true,
          data: ProductSerializer.new(product).serializable_hash
        }, status: :created
      end

      def update
        authorize @product
        @product.update!(product_params)

        Rails.cache.delete("product/#{@product.id}")
        Rails.cache.delete_matched("products/index*")

        render json: {
          success: true,
          data: ProductSerializer.new(@product).serializable_hash
        }
      end

      def destroy
        authorize @product
        @product.destroy

        Rails.cache.delete("product/#{@product.id}")
        Rails.cache.delete_matched("products/index*")

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
