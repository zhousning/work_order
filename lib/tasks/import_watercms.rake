require 'yaml'
require 'logger'
require 'find'
require 'creek'

namespace 'db' do
  desc "import water cms"
  task(:import_watercms => :environment) do
    exec_import
  end
end

def exec_import
  
  base_dir = "lib/tasks/data/inoutcms/" 

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      parse_excel(xls)
    end
  end
end

def parse_excel(xls)
  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  year, month = File.basename(xls, '.xlsx').split('.')

  results.each_pair do |sheet, rows|
    day = sheet.gsub(/Sheet/, '')

    rows[6..22].each_with_index do |row, index|
      index = index + 7
      index = index.to_s
      factory_hash = my_factory_hash
      day = day.to_i
      date = Date.new(year.to_i, month.to_i, day)
      factory_name = factory_hash[row['A' + index]]
      factory = Factory.where(:name => factory_name).first 
      if factory.nil?
        next
      end
      name = date.to_s + factory.name + "生产运营报表"

      option = {
        :factory        =>   factory,
        :name           =>   name,   
        :pdt_date       =>   date, 
        :inflow         =>   row['B' + index].blank? ? 0 : row['B' + index],
        :inf_qlty_cod   =>   row['C' + index].blank? ? 0 : row['C' + index], 
        :sed_qlty_cod   =>   row['D' + index].blank? ? 0 : row['D' + index],
        :eff_qlty_cod   =>   row['E' + index].blank? ? 0 : row['E' + index],
        :inf_qlty_bod   =>   row['F' + index].blank? ? 0 : row['F' + index],
        :sed_qlty_bod   =>   row['J' + index].blank? ? 0 : row['J' + index],
        :eff_qlty_bod   =>   row['H' + index].blank? ? 0 : row['H' + index],
        :inf_qlty_nhn   =>   row['I' + index].blank? ? 0 : row['I' + index],
        :sed_qlty_nhn   =>   row['J' + index].blank? ? 0 : row['J' + index],
        :eff_qlty_nhn   =>   row['K' + index].blank? ? 0 : row['K' + index],
        :inf_qlty_tn    =>   row['L' + index].blank? ? 0 : row['L' + index],
        :sed_qlty_tn    =>   row['M' + index].blank? ? 0 : row['M' + index],
        :eff_qlty_tn    =>   row['N' + index].blank? ? 0 : row['N' + index],
        :inf_qlty_tp    =>   row['O' + index].blank? ? 0 : row['O' + index],
        :sed_qlty_tp    =>   row['P' + index].blank? ? 0 : row['P' + index],
        :eff_qlty_tp    =>   row['Q' + index].blank? ? 0 : row['Q' + index],
        :inf_qlty_ss    =>   row['R' + index].blank? ? 0 : row['R' + index],
        :sed_qlty_ss    =>   row['S' + index].blank? ? 0 : row['S' + index],
        :eff_qlty_ss    =>   row['T' + index].blank? ? 0 : row['T' + index]
      }
      DayPdtRpt.create!(option)
      ##puts "index: " + index.to_s + "  " + a_str.to_s + " " +  b_str.to_s + " " +   c_str.to_s + " " +   d_str.to_s + " " +   e_str.to_s + " " +   f_str.to_s + " " +   g_str.to_s
      #else
      #end
    end
  end

end

def my_factory_hash
  {
    '任城污水' => "任城污水处理厂",    
    '达斯玛特' => "达斯玛特污水处理厂",
    '嘉祥一污' => "嘉祥污水处理厂",    
    '汶上佛都' => "汶上佛都污水处理厂",
    '汶上清泉' => "汶上清泉污水处理厂",
    '汶上清源' => "汶上清源污水处理厂",
    '曲阜一污' => "曲阜第一污水处理厂",
    '曲阜三污' => "曲阜第三污水处理厂",
    '兖州污水' => "兖州污水处理厂",    
    '兖州三污' => "兖州第三污水处理厂",
    '兖州大禹' => "兖州大禹污水处理厂",
    '邹城一污' => "邹城第一污水处理厂",
    '邹城二污' => "邹城第二污水处理厂",
    '邹城三污' => "邹城第三污水处理厂",
    '北湖污水' => "北湖污水处理厂"
  }
end
