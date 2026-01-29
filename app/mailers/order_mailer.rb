class OrderMailer < ApplicationMailer
  default from: "no-reply@inventory-app.com"

  def order_confirmed(order)
    @order = order
    @customer = order.customer

    
    mail(
      to: @customer.email,
      subject: " Your Order ##{@order.id} has been confirmed"
    )
  end
end
