require 'yaml'
require 'logger'
require 'find'
require 'creek'

namespace 'db' do
  desc "import emps"
  task(:import_emps => :environment) do
    exec_import_emps
  end
end

def exec_import_emps
  
  base_dir = "lib/tasks/data/emps/" 

  Find.find(base_dir).each do |xls|
    unless File::directory?(xls)
      parse_emps_excel(xls)
    end
  end
end

def parse_emps_excel(xls)
  tool = ExcelTool.new
  results = tool.parseExcel(xls)
  emp_type = File.basename(xls, '.xlsx')

  if emp_type == 'inf'
    results.each_pair do |sheet, rows|
      factory_name = my_factory_hash[sheet.strip]
      factory = Factory.where(:name => factory_name).first 
      if factory.nil? || rows[4..-1].nil?
        next
      else
        EmpInf.transaction do
          rows[4..-1].each_with_index do |item, index|
            index += 5 
            time = item['A' + index.to_s].strip
            next if time.blank?
            datetime = time #DateTime.strptime(time, "%Y-%m-%d %H")
            cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
            nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
            tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
            tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
            inflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
            ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
            temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

            #@emp_inf = factory.emp_infs.where(:pdt_time => datetime).first
            #EmpInf.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :tn => tn, :flow => inflow, :ph => ph, :temp => temp, :factory => factory) unless @emp_inf
            EmpInf.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :tn => tn, :flow => inflow, :ph => ph, :temp => temp, :factory => factory) 
          end
        end
      end
    end
  elsif emp_type == 'eff'
    results.each_pair do |sheet, rows|
      factory_name = my_factory_hash[sheet.strip]
      factory = Factory.where(:name => factory_name).first 
      if factory.nil? || rows[4..-1].nil?
        next
      else
        EmpEff.transaction do
          rows[4..-1].each_with_index do |item, index|
            index += 5 
            time = item['A' + index.to_s].strip
            next if time.blank?
            datetime = time #DateTime.strptime(time, "%Y-%m-%d %H")
            cod      = item['B' + index.to_s].nil? ? 0 : item['B' + index.to_s]
            nhn      = item['D' + index.to_s].nil? ? 0 : item['D' + index.to_s]
            tp       = item['F' + index.to_s].nil? ? 0 : item['F' + index.to_s]
            tn       = item['H' + index.to_s].nil? ? 0 : item['H' + index.to_s]
            efflow   = item['J' + index.to_s].nil? ? 0 : item['J' + index.to_s]
            ph       = item['K' + index.to_s].nil? ? 0 : item['K' + index.to_s]
            temp     = item['L' + index.to_s].nil? ? 0 : item['L' + index.to_s]

            #@emp_eff = factory.emp_effs.where(:pdt_time => datetime).first
            #EmpEff.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :tn => tn, :flow => efflow, :ph => ph, :temp => temp, :factory => factory) unless @emp_eff
            EmpEff.create!(:pdt_time => datetime, :cod => cod, :nhn => nhn, :tp => tp, :tn => tn, :flow => efflow, :ph => ph, :temp => temp, :factory => factory)
          end
        end
      end
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
