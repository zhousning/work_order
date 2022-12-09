class HomeController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!

  def index
  end

end
