class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Pundit::Authorization

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "Not authorized" }, status: :forbidden
  end
end
