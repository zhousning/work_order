require 'yaml'
require 'logger'
require 'find'
require 'creek'
require 'spreadsheet' 

namespace 'db' do
  desc "update_lishionline"
  task(:update_lishionline => :environment) do
    exec_update_lishionline
  end
end

def exec_update_lishionline
  
  log_dir = "lib/tasks/data/inoutcms/logs/" 
  inf_dir = "lib/tasks/data/inoutcms/onlineavg/inf/" 
  eff_dir = "lib/tasks/data/inoutcms/onlineavg/eff/" 
  @log = Logger.new(log_dir + 'updateerror.log')
  @prclog = Logger.new(log_dir + 'prc.log')
  @nonelog = Logger.new(log_dir + 'noneerror.log')

  Find.find(inf_dir).each do |xls|
    unless File::directory?(xls)
      puts '进水' + xls
      parse_inf_avg_excel(xls)
    end
  end

  Find.find(eff_dir).each do |xls|
    unless File::directory?(xls)
      puts '出水' + xls
      parse_eff_avg_excel(xls)
    end
  end
end

def parse_inf_avg_excel(xls)
  file_name = File.basename(xls, '.xlsx')

  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  factory_hash = my_factory_hash
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 

  results[file_name][5..-5].each_with_index do |row, index|
    index = index + 6 
    index = index.to_s
    date = row['A' + index]
    @prclog.info 'inf ' + date + ' ' + file_name
    @day_pdt_rpt = factory.day_pdt_rpts.where(:pdt_date => date).first
    if @day_pdt_rpt
      option = {
        :inf_qlty_cod    =>   row['B' + index].blank? ? 0 : row['B' + index], 
        :inf_qlty_nhn    =>   row['D' + index].blank? ? 0 : row['D' + index],
        :inf_qlty_tp     =>   row['G' + index].blank? ? 0 : row['G' + index],
        :inf_qlty_tn     =>   row['I' + index].blank? ? 0 : row['I' + index],
      }
      unless @day_pdt_rpt.update_attributes(option)
        @log.error 'inf update error: ' + @day_pdt_rpt.name 
      end
    else
      @nonelog.error 'inf none error: ' + file_name + date 
    end
  end
end

def parse_eff_avg_excel(xls)
  file_name = File.basename(xls, '.xlsx')

  tool = ExcelTool.new
  results = tool.parseExcel(xls)

  factory_hash = my_factory_hash
  fct_name = factory_hash[file_name]
  factory = Factory.where(:name => fct_name).first 

  results[file_name][5..-5].each_with_index do |row, index|
    index = index + 6 
    index = index.to_s
    date = row['A' + index]
    @prclog.info 'eff ' + date + ' ' + file_name
    @day_pdt_rpt = factory.day_pdt_rpts.where(:pdt_date => date).first
    if @day_pdt_rpt
      option = {
        :eff_qlty_cod    =>   row['B' + index].blank? ? 0 : row['B' + index], 
        :eff_qlty_nhn    =>   row['D' + index].blank? ? 0 : row['D' + index],
        :eff_qlty_tp     =>   row['G' + index].blank? ? 0 : row['G' + index],
        :eff_qlty_tn     =>   row['I' + index].blank? ? 0 : row['I' + index],
      }
      unless @day_pdt_rpt.update_attributes(option)
        @log.error 'eff update error: ' + @day_pdt_rpt.name 
      end
    else
      @nonelog.error 'eff none error: ' + file_name + date 
    end
  end
end
