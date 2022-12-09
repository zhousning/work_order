ActiveAdmin.register Device  do

  permit_params  :idno, :name, :mdno, :unit, :out_date, :mount_date, :supplier, :mfcture, :pos, :pos_no, :life, :qrcode, :state, :desc

  menu label: Setting.devices.label
  config.per_page = 20
  config.sort_order = "id_asc"

  
  filter :idno, :label => Setting.devices.idno
  filter :name, :label => Setting.devices.name
  filter :mdno, :label => Setting.devices.mdno
  filter :unit, :label => Setting.devices.unit
  filter :out_date, :label => Setting.devices.out_date
  filter :mount_date, :label => Setting.devices.mount_date
  filter :supplier, :label => Setting.devices.supplier
  filter :mfcture, :label => Setting.devices.mfcture
  filter :pos, :label => Setting.devices.pos
  filter :pos_no, :label => Setting.devices.pos_no
  filter :life, :label => Setting.devices.life
  filter :qrcode, :label => Setting.devices.qrcode
  filter :state, :label => Setting.devices.state
  filter :desc, :label => Setting.devices.desc
  filter :created_at

  index :title=>Setting.devices.label + "管理" do
    selectable_column
    id_column
    
    column Setting.devices.idno, :idno
    column Setting.devices.name, :name
    column Setting.devices.mdno, :mdno
    column Setting.devices.unit, :unit
    column Setting.devices.out_date, :out_date
    column Setting.devices.mount_date, :mount_date
    column Setting.devices.supplier, :supplier
    column Setting.devices.mfcture, :mfcture
    column Setting.devices.pos, :pos
    column Setting.devices.pos_no, :pos_no
    column Setting.devices.life, :life
    column Setting.devices.qrcode, :qrcode
    column Setting.devices.state, :state
    column Setting.devices.desc, :desc

    column "创建时间", :created_at, :sortable=>:created_at do |f|
      f.created_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    column "更新时间", :updated_at do |f|
      f.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    end
    actions
  end

  form do |f|
    f.inputs "添加" + Setting.devices.label do
      
      f.input :idno, :label => Setting.devices.idno 
      f.input :name, :label => Setting.devices.name 
      f.input :mdno, :label => Setting.devices.mdno 
      f.input :unit, :label => Setting.devices.unit 
      f.input :out_date, :label => Setting.devices.out_date 
      f.input :mount_date, :label => Setting.devices.mount_date 
      f.input :supplier, :label => Setting.devices.supplier 
      f.input :mfcture, :label => Setting.devices.mfcture 
      f.input :pos, :label => Setting.devices.pos 
      f.input :pos_no, :label => Setting.devices.pos_no 
      f.input :life, :label => Setting.devices.life 
      f.input :qrcode, :label => Setting.devices.qrcode 
      f.input :state, :label => Setting.devices.state 
      f.input :desc, :label => Setting.devices.desc 
    end
    f.actions
  end

  show :title=>Setting.devices.label + "信息" do
    attributes_table do
      row "ID" do
        device.id
      end
      
      row Setting.devices.idno do
        device.idno
      end
      row Setting.devices.name do
        device.name
      end
      row Setting.devices.mdno do
        device.mdno
      end
      row Setting.devices.unit do
        device.unit
      end
      row Setting.devices.out_date do
        device.out_date
      end
      row Setting.devices.mount_date do
        device.mount_date
      end
      row Setting.devices.supplier do
        device.supplier
      end
      row Setting.devices.mfcture do
        device.mfcture
      end
      row Setting.devices.pos do
        device.pos
      end
      row Setting.devices.pos_no do
        device.pos_no
      end
      row Setting.devices.life do
        device.life
      end
      row Setting.devices.qrcode do
        device.qrcode
      end
      row Setting.devices.state do
        device.state
      end
      row Setting.devices.desc do
        device.desc
      end

      row "创建时间" do
        device.created_at.strftime('%Y-%m-%d %H:%M:%S')
      end
      row "更新时间" do
        device.updated_at.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end

end
