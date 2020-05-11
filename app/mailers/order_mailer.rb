class OrderMailer < ApplicationMailer
  def confirmation
    @user = params[:user] # Instance variable => available in view
    mail(to: @user.email, subject: 'Confirmación de su pedido en Blueforestpanama.com')
    # This will render a view in `app/views/user_mailer`!
  end
end
