class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def privacy_policy
  end

  def terms_and_conditions
  end
end
