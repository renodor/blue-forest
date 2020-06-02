class DoctorMailer < ApplicationMailer
  def contact(message)
    @message = message
    mail(to: 'ops@blueforestpanama.com', subject: 'New Doctor Apointment on Blueforestpanama.com')
  end
end
