class OrderConfirmationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  discard_on ActiveRecord::RecordNotFound

  # NOTE: This job currently only logs a message. If this is a placeholder for
  # actual email/notification logic, consider adding a TODO comment to track the intended functionality.
  def perform(order_id)
    order = Order.find(order_id)

    Rails.logger.info "Order confirmed: ##{order.id}"
  end
end
