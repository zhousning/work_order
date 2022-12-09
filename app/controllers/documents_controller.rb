class DocumentsController < ApplicationController
  layout "application_control"
  before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @examine = Examine.find(params[:examine_id])
    @documents = @examine.documents.order("created_at desc")
  end
   
   
  def show
    @examine = Examine.find(params[:examine_id])
    documents = @examine.documents
    @document_id = params[:id].to_i
    if @document_id >= 0 and @document_id <= documents.size-1
      @document = documents[@document_id]
      gon.examineId = @examine.id
      gon.documentId = @document_id
      gon.documentStatus = @document.status
    else
      redirect_to examine_documents_path(@examine)
    end
  end
   
  def download
    @examine = Examine.find(params[:examine_id])
    documents = @examine.documents
    @document = documents.find(params[:id])
    if @document
      send_file File.join(Rails.root, "public", "examines", @examine.id.to_s, @document.html_link), :filename => @examine.name + "资料", :type => "application/force-download", :x_sendfile=>true
    else
      redirect_to examine_documents_path(@examine)
    end
  end

  def check
    @examine = Examine.find(params[:examine_id])
    @document_id = params[:id].to_i
    @document = @examine.documents[@document_id]
    respond_to do |format|
      format.json{ render :json => 
        {
          :id=>@document_id,
          :title=>@document.title,
          :status=>@document.status
        }.to_json}
    end
  end

  private
    def document_params
      params.require(:document).permit( :title)
    end
  
  
end

