class DashboardsController < ApplicationController
  def dashboard
    @address = current_user.addresses.first
  end
end
