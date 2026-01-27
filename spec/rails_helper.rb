# frozen_string_literal: true

require "spec_helper"
require "faker"

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# Abort if running in production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# ✅ Load support files ONCE
Rails.root.glob("spec/support/**/*.rb").sort.each { |f| require f }

# Maintain test schema
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # ✅ FactoryBot
  config.include FactoryBot::Syntax::Methods

  # ✅ IMPORTANT for Apartment + request specs
  config.use_transactional_fixtures = true

  # ✅ Devise helpers (only needed for controller specs)
  config.include Devise::Test::ControllerHelpers, type: :controller

  # ✅ Clean backtraces
  config.filter_rails_from_backtrace!

  # Uncomment if you want auto spec type inference
  # config.infer_spec_type_from_file_location!
end