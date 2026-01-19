module Api
  module V1
    class BaseController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :validation_failed

      private

      def record_not_found(error)
        render json: {
          success: false,
          error: {
            code: "NOT_FOUND",
            message: error.message
          }
        }, status: :not_found
      end

      def validation_failed(error)
        render json: {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            messages: error.record.errors.full_messages
          }
        }, status: :unprocessable_entity
      end
    end
  end
end
