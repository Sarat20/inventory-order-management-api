class Rack::Attack
  
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  throttle("logins/ip", limit: 5, period: 60.seconds) do |req|
    if req.path == "/api/v1/auth/login" && req.post?
      req.ip
    end
  end
end
