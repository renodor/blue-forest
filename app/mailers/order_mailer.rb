class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user = @order.fake_user || @order.user
    mail(to: @user.email, subject: 'Confirmación de su pedido en Blueforestpanama.com')
  end
end
