class DoctorsController < ApplicationController
  def doctor_contact_form
    if contact_params
      @message = contact_params
      DoctorMailer.contact(@message).deliver_now
      flash[:notice] = "Su mensaje se a enviado. Le contactaremos pronto"
      redirect_to root_path
    end
  end

  private

  def contact_params
    params.permit(:name, :surname, :email, :phone, :message)
  end
end
