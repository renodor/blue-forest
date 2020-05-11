# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    order = Order.last # Instance variable => available in view
    # This will render a view in `app/views/user_mailer`!
    OrderMailer.with(order: Order.last).confirmation(order)
  end
end
