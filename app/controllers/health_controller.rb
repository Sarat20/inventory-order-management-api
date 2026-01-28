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

  # NOTE: The bare rescue clause will catch all StandardError subclasses.
  # Consider whether being more specific about which exceptions indicate a failed health check
  # would be more appropriate.
  def check_db
    ActiveRecord::Base.connection.execute("SELECT 1")
    { status: "ok" }
  rescue
    { status: "error" }
  end

  # NOTE: Each health check creates a new Redis.new connection, bypassing any connection pooling.
  # If you have Redis configured elsewhere with a connection pool, consider reusing that.
  # Also, the bare rescue clause could be made more specific.
  def check_redis
    Redis.new.ping == "PONG"
    { status: "ok" }
  rescue
    { status: "error" }
  end
end
