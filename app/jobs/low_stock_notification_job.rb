class LowStockNotificationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  discard_on ActiveRecord::RecordNotFound

  # NOTE: This job currently only logs a message. If this is a placeholder for
  # actual notification logic (e.g., email, Slack), consider adding a TODO to track the intended functionality.
  def perform(product_id)
    product = Product.find(product_id)

    Rails.logger.info "LOW STOCK: #{product.name} (#{product.quantity})"
  end
end
