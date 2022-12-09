require 'json'
class TemplatesController < ApplicationController
  layout "application_control"
  #load_and_authorize_resource

   
  def index
    @templates = Template.all
  end
   

   
  def show
    @template = Template.find(params[:id])
  end
   

   
  def new
    @template = Template.new
    
    @template.natures.build
    
    @template.relates.build

    @template.nests.build
    
  end
   

   
  def create
    @template = Template.new(template_params)
    #@template.user = current_user
    if @template.save
      redirect_to @template
    else
      render :new
    end
  end
   

   
  def edit
    @template = Template.find(params[:id])
  end
   

   
  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      redirect_to template_path(@template) 
    else
      render :edit
    end
  end

  def produce
    @template = Template.find(params[:id])
    @natures = @template.natures

    cond = "rails g item " + @template.name + " "

    unless @natures.blank?
      nature_str = ""
      label = "-l "
      tag = "-t "
      required = "-u "
      @natures.each do |nature|
        nature_str += nature.name + ":" + nature.data_type + " "
        label += nature.title + " "
        tag += nature.tag + " "
        required += nature.required.to_s + " "
      end
      cond += nature_str + label + tag + required + " "
    end

    cond += "-n " + @template.cn_name + " " + 

           "-i " + @template.image.to_s + " " +
           @template.attachment.to_s + " " +
           @template.index.to_s + " " +
           @template.new.to_s + " " +
           @template.edit.to_s + " " +
           @template.show.to_s + " " +
           @template.form.to_s + " " +
           @template.js.to_s + " " +
           @template.scss.to_s + " " +
           @template.upload.to_s + " " +
           @template.download.to_s + " " +
           @template.current_user.to_s + " " +
           @template.admin.to_s + " "
    
    unless @template.one_image.blank?
      cond += "-b " + @template.one_image.to_s + " "
    end
    unless @template.one_attachment.blank?
      cond += "-k " + @template.one_attachment.to_s + " "
    end


    unless @template.nests.blank?
      cond += "-z "
      property = Hash.new 
      @template.nests.each do |nest|
        attr_arr = []
        tag_arr = []
        required_arr = []
        cache = Hash.new
        nest.properties.each do |p|
          attr_arr << p.name
          tag_arr << p.tag
          required_arr << p.required
        end
        cache['attr'.to_sym] = attr_arr
        cache['tag'.to_sym] = tag_arr
        cache['required'.to_sym] = required_arr
        property[nest.name.to_sym] = cache 
      end
      prpty = property.to_json.gsub(/"/, '\"')
      cond += prpty + " "
    end

    @relates = @template.relates
    unless @relates.blank?
      cond += "-y "
      @relates.each do |relate|
        cond += relate.relate_type + ":" + relate.obj + " "
      end
    end
    puts cond
    exec cond
    redirect_to template_path(@template) 
  end
   

   
  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to :action => :index
  end
   

  private
    def template_params
      params.require(:template).permit( :name, :cn_name, :nest, :image, :one_image, :one_attachment, :attachment, :index, :new, :edit, :show, :form, :js, :scss, :upload, :download, :admin, :current_user, nests_attributes: nest_params, natures_attributes: nature_params, relates_attributes: relate_params)
    end
  
    def nature_params
      [:id, :name, :title, :tag, :data_type, :required, :_destroy]
    end
  
    def relate_params
      [:id, :relate_type, :obj, :_destroy]
    end
  
    def nest_params
      [:id, :name, :_destroy, properties_attributes: property_params]
    end
  
    def property_params
      [:id, :name, :tag, :required, :_destroy]
    end
end

