class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @order.fake_user_id ? @user = @order.fake_user : @user = @order.user
    mail(to: @user.email, subject: 'Confirmación de su pedido en Blueforestpanama.com')
  end
end
