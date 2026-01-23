module Api
  module V1
    class CategoriesController < BaseController
      before_action :set_category, only: %i[show update destroy]

      def index
        authorize Category

        categories = Category.order(:id).page(params[:page]).per(10)

        render json: {
          success: true,
          data: CategorySerializer.new(categories).serializable_hash,
          meta: {
            page: categories.current_page,
            total_pages: categories.total_pages,
            total_count: categories.total_count
          }
        }
      end

      def show
        authorize @category

        render json: {
          success: true,
          data: CategorySerializer.new(@category).serializable_hash
        }
      end

      def create
        category = Category.new(category_params)
        authorize category
        category.save!

        render json: {
          success: true,
          data: CategorySerializer.new(category).serializable_hash
        }, status: :created
      end

      def update
        authorize @category
        @category.update!(category_params)

        render json: {
          success: true,
          data: CategorySerializer.new(@category).serializable_hash
        }
      end

      def destroy
        authorize @category
        @category.destroy

        render json: { success: true }
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
