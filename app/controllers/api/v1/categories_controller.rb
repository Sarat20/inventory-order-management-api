module Api
  module V1
    class CategoriesController < BaseController

      def index
        render json: { success: true, data: Category.all }
      end

      def show
        render json: { success: true, data: Category.find(params[:id]) }
      end

      def create
        category = Category.create!(category_params)
        render json: { success: true, data: category }, status: :created
      end

      def update
        category = Category.find(params[:id])
        category.update!(category_params)
        render json: { success: true, data: category }
      end

      def destroy
        Category.find(params[:id]).destroy
        render json: { success: true }
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
