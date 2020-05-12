class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    @user = @order.fake_user || @order.user
    mail(to: @user.email, subject: 'Confirmación de su pedido en Blueforestpanama.com')
  end

  def new_order_notice(order)
    @order = order
    @user = @order.fake_user || @order.user
    # for now we consider that users have only 1 address
    @address = @user.addresses.first
    mail(to: 'ops@blueforestpanama.com', subject: 'New Order on Blueforestpanama.com')
  end
end
