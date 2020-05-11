# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    @user = User.first # Instance variable => available in view
    mail(to: @user.email, subject: 'Confirmación de su pedido en Blueforestpanama.com')
    # This will render a view in `app/views/user_mailer`!
    UserMailer.with(user: user).confirmation
  end
end
