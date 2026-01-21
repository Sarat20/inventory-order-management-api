class HealthController < ActionController::API
  def show
    checks = {
      database: check_db,
      redis: check_redis
    }

    healthy = checks.values.all? { |c| c[:status] == "ok" }

    render json: {
      status: healthy ? "healthy" : "unhealthy",
      checks: checks
    }, status: healthy ? :ok : :service_unavailable
  end

  private

  def check_db
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue
    { status: "error" }
  end

  def check_redis
    Redis.new.ping == "PONG"
    { status: "ok" }
  rescue
    { status: "error" }
  end
end
