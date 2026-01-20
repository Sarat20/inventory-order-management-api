class Rack::Attack
  throttle("logins/ip", limit: 5, period: 60.seconds) do |req|
    req.ip if req.path == "/api/v1/auth/login" && req.post?
  end
end
