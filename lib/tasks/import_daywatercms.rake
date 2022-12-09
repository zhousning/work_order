require 'yaml'
require 'logger'
require 'find'
require 'creek'

namespace 'db' do
  desc "import daywater cms"
  task(:import_daywatercms => :environment) do
    exec_import_daywatercms
  end
end

def exec_import_daywatercms
  
  base_dir = "lib/tasks/data/inoutcms/2020日数据/" 

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      puts xls
      parse_watercms_excel(xls)
    end
  end
end

def parse_watercms_excel(xls)
  tool = ExcelTool.new
  results = tool.parseExcel(xls)
  factory_hash = my_factory_hash

  file_name = File.basename(xls, '.xlsx')
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 

  results['Sheet1'][3..-1].each_with_index do |row, index|
    index = index + 4 
    index = index.to_s
    year_month = row['A' + index]
    day  = row['B' + index].to_i - 1
    date_time = Time.utc(1899,12,30) + (year_month + day).days 
    date = date_time.to_date
    name = date.to_s + factory.name + "生产运营报表"

    option = {
      :factory        =>   factory,
      :name           =>   name,   
      :pdt_date       =>   date, 
      :inflow         =>   row['C' + index].blank? ? 0 : row['C' + index],
      :inf_qlty_cod   =>   row['D' + index].blank? ? 0 : row['D' + index], 
      :eff_qlty_cod   =>   row['E' + index].blank? ? 0 : row['E' + index],
      :inf_qlty_bod   =>   row['F' + index].blank? ? 0 : row['F' + index],
      :eff_qlty_bod   =>   row['G' + index].blank? ? 0 : row['G' + index],
      :inf_qlty_nhn   =>   row['J' + index].blank? ? 0 : row['J' + index],
      :eff_qlty_nhn   =>   row['K' + index].blank? ? 0 : row['K' + index],
      :inf_qlty_tn    =>   row['N' + index].blank? ? 0 : row['N' + index],
      :eff_qlty_tn    =>   row['O' + index].blank? ? 0 : row['O' + index],
      :inf_qlty_tp    =>   row['L' + index].blank? ? 0 : row['L' + index],
      :eff_qlty_tp    =>   row['M' + index].blank? ? 0 : row['M' + index],
      :inf_qlty_ss    =>   row['H' + index].blank? ? 0 : row['H' + index],
      :eff_qlty_ss    =>   row['I' + index].blank? ? 0 : row['I' + index],
      :eff_qlty_fecal =>   row['P' + index].blank? ? 0 : row['P' + index],
      :outmud         =>   row['Q' + index].blank? ? 0 : row['Q' + index],
      :mst            =>   row['R' + index].blank? ? 0 : row['R' + index]
    }
    DayPdtRpt.create!(option)
    ##puts "index: " + index.to_s + "  " + a_str.to_s + " " +  b_str.to_s + " " +   c_str.to_s + " " +   d_str.to_s + " " +   e_str.to_s + " " +   f_str.to_s + " " +   g_str.to_s
    #else
    #end
    #:sed_qlty_cod   =>   row['E' + index].blank? ? 0 : row['D' + index],
    #:sed_qlty_bod   =>   row['J' + index].blank? ? 0 : row['J' + index],
    #:sed_qlty_nhn   =>   row['J' + index].blank? ? 0 : row['J' + index],
    #:sed_qlty_tn    =>   row['M' + index].blank? ? 0 : row['M' + index],
    #:sed_qlty_tp    =>   row['P' + index].blank? ? 0 : row['P' + index],
    #:sed_qlty_ss    =>   row['S' + index].blank? ? 0 : row['S' + index],
  end

end
