class DashboardsController < ApplicationController
  def dashboard
    @address = current_user.addresses.first
    @orders = current_user.orders.reverse
  end
end
