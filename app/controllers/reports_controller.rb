class ReportsController < ApplicationController

  def xls_day_download
    _start = params[:start].gsub(/\s/, '')
    _end = params[:end].gsub(/\s/, '')
    fct = params[:fct].gsub(/\s/, '')
    excel_tool = SpreadSheetTool.new

    target_excel = excel_tool.exportDayPdtRptToExcel(obj)
    send_file target_excel, :filename => "工单报表.xls", :type => "application/force-download", :x_sendfile=>true
  end

end
