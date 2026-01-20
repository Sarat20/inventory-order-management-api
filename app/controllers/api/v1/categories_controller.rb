module Api
  module V1
    class CategoriesController < BaseController
      before_action :set_category, only: %i[show update destroy]

      def index
        authorize Category
        render json: { success: true, data: Category.all }
      end

      def show
        authorize @category
        render json: { success: true, data: @category }
      end

      def create
        category = Category.new(category_params)
        authorize category
        category.save!

        render json: { success: true, data: category }, status: :created
      end

      def update
        authorize @category
        @category.update!(category_params)

        render json: { success: true, data: @category }
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
