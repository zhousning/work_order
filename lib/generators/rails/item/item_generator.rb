require 'json'
class Rails::ItemGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  
  #model或attrs 也可通过@model或@columns访问
  argument :model, :type => :string, :default => "model"
  argument :columns, :type => :array, :default => []

  class_option :name, :aliases => '-n',  :type => :string, :default => ""

  class_option :label, :aliases => '-l', :type => :array, :default => []
  class_option :tag, :aliases => '-t', :type => :array, :default => []
  class_option :required, :aliases => '-u', :type => :array, :default => []
  

  class_option :one_image, :aliases => '-b', :type => :array, :default => []
  class_option :one_attachment, :aliases => '-k', :type => :array, :default => [] 

  class_option :nests, :aliases => '-z', :type => :string, :default => "" 
  class_option :properties, :aliases => '-m', :type => :array, :default => []
  class_option :relates, :aliases => '-y', :type => :array, :default => []

  class_option :flags, :aliases => '-i', :type => :array, :default => []

  #0 class_option :image, :aliases => '-i', :type => :boolean, :default => true 
  #1 class_option :attachment, :aliases => '-d', :type => :boolean, :default => false 

  #2 class_option :index, :aliases => '-x', :type => :boolean, :default => true 
  #3 class_option :new, :aliases => '-w', :type => :boolean, :default => true 
  #4 class_option :edit, :aliases => '-e', :type => :boolean, :default => true 
  #5 class_option :show, :aliases => '-h', :type => :boolean, :default => true 
  #6 class_option :form, :aliases => '-r', :type => :boolean, :default => true 

  #7 class_option :js, :aliases => '-j', :type => :boolean, :default => true 
  #8 class_option :scss, :aliases => '-c', :type => :boolean, :default => true 

  #9 class_option :upload, :aliases => '-s', :type => :boolean, :default => true 
  #10 class_option :download, :aliases => '-f', :type => :boolean, :default => true 

  #11 class_option :current_user, :aliases => '-cu', :type => :boolean, :default => true 

  #12 class_option :admin, :aliases => '-a', :type => :boolean, :default => true 

  def generate_model
    #attributes = columns.join(" ")
    #generate "model", "#{model} #{attributes} --force"
    #generate "migration", "create_#{model.pluralize} #{attributes}"
    @mu = model.underscore
    @mc = model.camelcase
    @mpc = model.pluralize.camelcase
    @mpu = model.pluralize.underscore
    @enclosure = flag_boolean(options[:flags][0])
    @one_enclosure = options[:one_image]
    @attachment = flag_boolean(options[:flags][1])
    @one_attachment = options[:one_attachment]
    @current_user = flag_boolean(options[:flags][11])

    @attrs = []
    columns.each do |column|
      @attrs << column.slice(/[^:]+/)
    end

    name = Time.now.strftime('%Y%m%d%H%M%S') + "_create_" + @mpu
    @relates   = options[:relates]
    @columns   = columns
    template 'migration.template', "db/migrate/#{name}.rb", @mpc, @mpu, @relates, @columns, @one_enclosure, @one_attachment, @current_user
    template 'model.template', "app/models/#{@mu}.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @one_enclosure, @attachment, @one_attachment, @relates, @current_user
  end

  def add_to_enclosure
    @enclosure = flag_boolean(options[:flags][0])
    if @enclosure
      model_enclosure = "app/models/enclosure.rb"
      migrate_enclosure = "db/migrate/20190123085658_create_enclosures.rb"
      model_str = "  belongs_to :#{@mu}\nend"
      migrate_str = "  t.references :#{@mu}\n    end"

      model_file = File.read(model_enclosure)
      migrate_file = File.read(migrate_enclosure)

      model_replace = model_file.sub(/end/, model_str)
      migrate_replace = migrate_file.sub(/end/, migrate_str)

      File.open(model_enclosure, "w") {|file| file.puts model_replace}
      File.open(migrate_enclosure, "w") {|file| file.puts migrate_replace}
    end
  end

  def add_to_attachment
    @attachment = flag_boolean(options[:flags][1])
    if @attachment
      model_attachment = "app/models/attachment.rb"
      migrate_attachment = "db/migrate/20190123085659_create_attachments.rb"
      model_str = "  belongs_to :#{@mu}\nend"
      migrate_str = "  t.references :#{@mu}\n    end"

      model_file = File.read(model_attachment)
      migrate_file = File.read(migrate_attachment)

      model_replace = model_file.sub(/end/, model_str)
      migrate_replace = migrate_file.sub(/end/, migrate_str)

      File.open(model_attachment, "w") {|file| file.puts model_replace}
      File.open(migrate_attachment, "w") {|file| file.puts migrate_replace}
    end
  end

  def generate_setting
    model_name = model.pluralize.underscore
    hash = Hash.new
    hash["label"] = options[:name]
    columns.each_with_index do |column, index|
      key = column.slice(/([^:]+)/)
      hash[key] = options[:label][index]
    end
    Setting.save(model_name, hash)
  end

  def generate_route
    @mpu = model.pluralize.underscore
    @attachment = flag_boolean(options[:flags][1])
    @one_attachment = options[:one_attachment]
    @upload = flag_boolean(options[:flags][9])
    @download = flag_boolean(options[:flags][10])

    flower = "resources :flower"
    route_attachment = "config/routes.rb"
    route_str = "resources :" + @mpu + " do\n"
    

    if @attachment
      route_str += "    get :download_attachment, :on => :member\n"
    end

    if @one_attachment
      route_str += "    get :download_append, :on => :member\n"
    end

    if @upload
      route_str += "    post :parse_excel, :on => :collection\n"
    end

    if @download
      route_str += "    get :xls_download, :on => :collection\n"
    end

    route_str += "    get :query_all, :on => :collection\n"

    route_str += "  end\n" + "  " + flower

    route_file = File.read(route_attachment)
    route_replace = route_file.sub(flower, route_str)

    File.open(route_attachment, "w") {|file| file.puts route_replace}
  end

  def generate_controller_view
    @mu = model.underscore
    @mc = model.camelcase
    @mpc = model.pluralize.camelcase
    @mpu = model.pluralize.underscore
    @enclosure = flag_boolean(options[:flags][0])
    @one_enclosure = options[:one_image]
    @attachment = flag_boolean(options[:flags][1])
    @one_attachment = options[:one_attachment]
    @index = flag_boolean(options[:flags][2])
    @new  = flag_boolean(options[:flags][3])
    @edit = flag_boolean(options[:flags][4])
    @show = flag_boolean(options[:flags][5])
    @form = flag_boolean(options[:flags][6])
    @js   = flag_boolean(options[:flags][7])
    @scss = flag_boolean(options[:flags][8])
    @upload   = flag_boolean(options[:flags][9])
    @download = flag_boolean(options[:flags][10])
    @current_user = flag_boolean(options[:flags][11])
    @admin = flag_boolean(options[:flags][12])
    @nests = options[:nests]

    unless @nests.blank?
      @fields = JSON.parse(@nests)
    else
      @fields = []
    end

    @attrs = []
    columns.each do |column|
      @attrs << column.slice(/[^:]+/)
    end

    template 'controller.template', "app/controllers/#{controller_name}_controller.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment, @index, @new, @edit, @show, @fields, @upload, @download, @current_user

    if @index
      template 'index.template', "app/views/#{controller_name}/index.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment, @upload, @download
    end

    if @form
      template '_form.template', "app/views/#{controller_name}/_form.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment, @fields
    end

    if @new
      template 'new.template', "app/views/#{controller_name}/new.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment
    end

    if @edit
      template 'edit.template', "app/views/#{controller_name}/edit.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment
    end

    if @show
      template 'show.template', "app/views/#{controller_name}/show.html.haml", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment, @fields
    end

    if @js
      template 'js.template', "app/assets/javascripts/#{controller_name}.js", @attrs, @mu, @mc, @mpc, @mpu
    end

    if @scss
      template 'scss.template', "app/assets/stylesheets/#{controller_name}.scss"
    end

    if @admin
      template 'admin.template', "app/admin/#{@mu}.rb", @attrs, @mu, @mc, @mpc, @mpu, @enclosure, @attachment, @one_enclosure, @one_attachment
    end

    if @enclosure
      template '_enclosure.template', "app/views/#{controller_name}/_enclosure_fields.html.haml"
    end

    if @attachment
      template '_attachment.template', "app/views/#{controller_name}/_attachment_fields.html.haml"
    end

    @fields.each do |field, value|
      @nest = field
      @field_attr = value['attr']
      @field_tag = value['tag']
      @field_required = value['required']
      template '_fields.template', "app/views/#{controller_name}/_#{field}_fields.html.haml", @nest, @field_attr, @field_tag, @field_required
    end

  end

  private
    def file_name
      model.underscore
    end

    def controller_name
      model.pluralize.underscore
    end

    def flag_boolean(flag)
      flag == "true" ? true : false
    end

  #model_singularize = model.singularize.underscore
  #class_option :model_singularize, :type => :string, :default => model_singularize
  #class_option :model_pluralize, :type => :string, :default => model_pluralize
  #generate "controller", "#{controller_name}"
end
