class LowStockNotificationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  discard_on ActiveRecord::RecordNotFound

  def perform(product_id)
    product = Product.find(product_id)

    Rails.logger.info "LOW STOCK: #{product.name} (#{product.quantity})"
  end
end
