namespace 'db' do
  desc "create folders"
  task(:create_folders => :environment) do
    mth_pdt_rpt_folder = Rails.root.join("public", "mth_pdt_rpts").to_s
    excel_folder = Rails.root.join("public", "excel").to_s

    FileUtils.makedirs(mth_pdt_rpt_folder) unless File.directory?(mth_pdt_rpt_folder)
    FileUtils.makedirs(excel_folder) unless File.directory?(excel_folder)
  end
end

