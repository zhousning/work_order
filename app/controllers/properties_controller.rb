class PropertiesController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   

   
  def show
    @property = Property.find(params[:id])
  end
   

   

   

   

   

   

  

  

  private
    def property_params
      params.require(:property).permit( :name, :tag)
    end
  
  
  
end

