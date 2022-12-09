class NestsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   

   
  def show
    @nest = Nest.find(params[:id])
  end
   

   

   

   

   

   

  

  

  private
    def nest_params
      params.require(:nest).permit( :name, properties_attributes: property_params)
    end
  
  
  
    def property_params
      [:id, :_destroy]
    end
  
end

