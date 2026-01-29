class ProductMailer < ApplicationMailer
  default from: "no-reply@inventory-app.com"

  def low_stock_alert(product)
    @product = product

    admin_emails = User.admin.pluck(:email)

    return if admin_emails.empty?

    mail(
      to: admin_emails,
      subject: "⚠️ Low Stock Alert: #{@product.name}"
    )
  end
end
