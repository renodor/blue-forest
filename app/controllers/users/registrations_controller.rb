class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    # if from_dashboard params is not present, the user is updating its contact info while ordering
    # in that case we need to render order breadcrumb and its relevant CSS classes
    unless params[:from_dashboard]
      # DRY
      @breadcrumb_contact_class = 'active'
      @breadcrumb_review_class = @breadcrumb_confirm_class = 'pending hide-under-576'
    end
    super
  end

  # PUT /resource
  def update
    # if from_dashboard params is not present, the user is updating its contact info while ordering
    # in that case we don't want him to enter his password or allowing him to modify his password
    # so we use a custom 'custom_user_params' strong params methods and a custom 'update' method
    # (otherwise we juste use the 'super' kw to trigger the normal devise update method)
    if !params[:from_dashboard]
      if current_user.update(custom_user_params)
        redirect_to new_user_order_path(current_user)
      else
        render :edit
      end
    else
      super
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def custom_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  # By default devise only permit email, password and password confirmation fields
  # This "sanitizer" method allows to permit custom fields (firt_name, last_namet etc..)
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name phone])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name phone])
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(_resource)
    dashboards_path
  end
end
