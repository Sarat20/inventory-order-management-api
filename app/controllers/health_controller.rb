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

  # Rescues only ActiveRecord-specific errors to avoid hiding unrelated bugs
  def check_db
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue ActiveRecord::ActiveRecordError => e
    Rails.logger.error "HealthCheck DB error: #{e.class} - #{e.message}"
    { status: "error" }
  end

  def redis_client
    @redis_client ||= Redis.new
  end

  # Rescues only Redis-specific errors to ensure real bugs still surface
  def check_redis
    redis_client.ping == "PONG"
    { status: "ok" }
  rescue Redis::BaseError => e
    Rails.logger.error "HealthCheck Redis error: #{e.class} - #{e.message}"
    { status: "error" }
  end
end
