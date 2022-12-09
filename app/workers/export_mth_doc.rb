require "sablon"

#不用异步
class ExportMthDoc

  def process(mth_pdt_rpt_id)
    @mth_pdt_rpt = MthPdtRpt.find(mth_pdt_rpt_id)

    export_process(@mth_pdt_rpt)
  end

  def export_process(mth_pdt_rpt)
    target_folder = Rails.root.join("public", "mth_pdt_rpts").to_s
    target_docx = target_folder + '/' + mth_pdt_rpt.name + '.docx'

    docx = Caracal::Document.new(target_docx)
    style_config(docx)

    _start = mth_pdt_rpt.start_date
    _end = mth_pdt_rpt.end_date
    factory = mth_pdt_rpt.factory
    @day_pdt_rpts = factory.day_pdt_rpts.where(["pdt_date between ? and ? ", _start, _end]).order("pdt_date ASC")

    inf_header = ['', 'COD(mg/l)', 'BOD(mg/l)', 'NH3-N(mg/l)', 'TN(mg/l)',  'TP(mg/l)', 'SS(mg/l)'] 
    inf_table = [] << inf_header
    @day_pdt_rpts.each do |rpt|
      inf_table << [rpt.pdt_date, rpt.inf_qlty_cod,  rpt.inf_qlty_bod, rpt.inf_qlty_nhn, rpt.inf_qlty_tn, rpt.inf_qlty_tp, rpt.inf_qlty_ss]
    end
    docx.p '进水水质' do
      style 'table_caption'
    end
    docx.table inf_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
    end

    docx.page
    eff_header = ['', 'COD(mg/l)', 'BOD(mg/l)', 'NH3-N(mg/l)', 'TN(mg/l)',  'TP(mg/l)', 'SS(mg/l)', '粪大肠菌群数(个/l)'] 
    eff_table = [] << eff_header
    @day_pdt_rpts.each do |rpt|
      eff_table << [rpt.pdt_date, rpt.eff_qlty_cod,  rpt.eff_qlty_bod, rpt.eff_qlty_nhn, rpt.eff_qlty_tn, rpt.eff_qlty_tp, rpt.eff_qlty_ss, rpt.eff_qlty_fecal]
    end
    docx.p '出水水质' do
      style 'table_caption'
    end
    docx.table eff_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
    end

    docx.page
    mud_header = ['', Setting.day_pdt_rpts.inflow, Setting.day_pdt_rpts.outflow, Setting.day_pdt_rpts.inmud, Setting.day_pdt_rpts.outmud] 
    mud_table = [] << mud_header
    @day_pdt_rpts.each do |rpt|
      mud_table << [rpt.pdt_date, rpt.inflow,  rpt.outflow, rpt.inmud, rpt.outmud] 
    end
    docx.p '污泥处理' do
      style 'table_caption'
    end
    docx.table mud_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
    end

    docx.page
    power_header = ['', Setting.day_pdt_rpts.power] 
    power_table = [] << power_header
    @day_pdt_rpts.each do |rpt|
      power_table << [rpt.pdt_date, rpt.power] 
    end
    docx.p '电耗' do
      style 'table_caption'
    end
    docx.table power_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
    end

    docx.page
    md_header = ['', Setting.day_pdt_rpts.mdflow, Setting.day_pdt_rpts.mdrcy, Setting.day_pdt_rpts.mdsell] 
    md_table = [] << md_header
    @day_pdt_rpts.each do |rpt|
      md_table << [rpt.pdt_date, rpt.mdflow,  rpt.mdrcy, rpt.mdsell] 
    end
    docx.p '中水处理' do
      style 'table_caption'
    end
    docx.table md_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
    end

    month_report(mth_pdt_rpt, docx)
    
    #row1 = ['Header 1', 'Header 2', 'Header 3']
    #row2 = ['Cell 1', 'Cell 2', 'Cell 3']
    #row3 = ['Cell 4', 'Cell 5', 'Cell 6']
    #row4 = ['Footer 1', 'Footer 2', 'Footer 3']
    #c1 = Caracal::Core::Models::TableCellModel.new margins: { top: 0, bottom: 100, left: 0, right: 200 } do
    #  table [row1, row2, row3, row4], border_size: 4 do
    #    cell_style rows[0],  bold: true, background: '3366cc', color: 'ffffff'
    #    cell_style rows[-1], bold: true,   background: 'dddddd'
    #    cell_style cells[3], italic: true, color: 'cc0000'
    #    cell_style cells,    size: 18, margins: { top: 100, bottom: 0, left: 100, right: 100 }
    #  end
    #end
    #c2 = Caracal::Core::Models::TableCellModel.new margins: { top: 0, bottom: 100, left: 0, right: 200 } do
    #  p 'This layout uses nested tables (the outer table has no border) to provide a caption to the table data.'
    #end
    #
    #docx.table [[c1,c2]] do
    #  cell_style cols[0], width: 6000
    #end

    docx.save

    target_docx
  end

  def month_report(mth_pdt_rpt, docx)
    docx.page
    docx.h2 mth_pdt_rpt.name

    cod = mth_pdt_rpt.month_cod
    bod = mth_pdt_rpt.month_bod
    tp = mth_pdt_rpt.month_tp
    tn = mth_pdt_rpt.month_tn
    ss = mth_pdt_rpt.month_ss
    nhn = mth_pdt_rpt.month_nhn
    power = mth_pdt_rpt.month_power
    mud = mth_pdt_rpt.month_mud
    md = mth_pdt_rpt.month_md
    fecal = mth_pdt_rpt.month_fecal
    device = mth_pdt_rpt.month_device
    stuff = mth_pdt_rpt.month_stuff

    cms_header = ['', '平均进水浓度', '平均出水浓度', '平均消减量', '本月消减量', '本月止累计消减量', '本月出水达标天数', '本月止累计出水达标天数', '同比削减量', '环比削减量'] 
    cod_arr = [Setting.month_cods.label, cod.avg_inf, cod.avg_eff, cod.avg_emq, cod.emq, cod.end_emq, cod.up_std, cod.end_std, cod.yoy, cod.mom] 
    bod_arr = [Setting.month_bods.label, bod.avg_inf, bod.avg_eff, bod.avg_emq, bod.emq, bod.end_emq, bod.up_std, bod.end_std, bod.yoy, bod.mom] 
    tn_arr =  [Setting.month_tns.label, tn.avg_inf, tn.avg_eff, tn.avg_emq, tn.emq, tn.end_emq, tn.up_std, tn.end_std, tn.yoy, tn.mom] 
    tp_arr =  [Setting.month_tps.label, tp.avg_inf, tp.avg_eff, tp.avg_emq, tp.emq, tp.end_emq, tp.up_std, tp.end_std, tp.yoy, tp.mom] 
    nhn_arr = [Setting.month_nhns.label, nhn.avg_inf, nhn.avg_eff, nhn.avg_emq, nhn.emq, nhn.end_emq, nhn.up_std, nhn.end_std, nhn.yoy, nhn.mom] 
    ss_arr =  [Setting.month_sses.label, ss.avg_inf, ss.avg_eff, ss.avg_emq, ss.emq, ss.end_emq, ss.up_std, ss.end_std, ss.yoy, ss.mom] 

    cms_table = [cms_header, cod_arr, bod_arr, tn_arr, tp_arr, nhn_arr, ss_arr]

    docx.p '进出水水质' do
      style 'table_caption'
    end
    docx.table cms_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
      #cell_style cols[0], width: 6000
    end

    power_header = [Setting.month_powers.power , Setting.month_powers.end_power , Setting.month_powers.bom , Setting.month_powers.bom_power , Setting.month_powers.yoy_power , Setting.month_powers.mom_power , Setting.month_powers.yoy_bom , Setting.month_powers.mom_bom] 
    power_arr = [power.power , power.end_power , power.bom , power.bom_power , power.yoy_power , power.mom_power , power.yoy_bom , power.mom_bom] 
    power_table = [power_header, power_arr]
    docx.p '电耗' do
      style 'table_caption'
    end
    docx.table power_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
      #cell_style cols[0], width: 6000
    end

    mud_header = [Setting.month_muds.inmud, Setting.month_muds.end_inmud, Setting.month_muds.outmud, Setting.month_muds.end_outmud, Setting.month_muds.mst_up, Setting.month_muds.yoy, Setting.month_muds.mom ]
    mud_arr = [mud.inmud, mud.end_inmud, mud.outmud, mud.end_outmud, mud.mst_up, mud.yoy, mud.mom]
    mud_table = [mud_header, mud_arr]
    docx.p '污泥处理' do
      style 'table_caption'
    end
    docx.table mud_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
      #cell_style cols[0], width: 6000
    end

    md_header = [Setting.month_mds.mdrcy, Setting.month_mds.end_mdrcy,Setting.month_mds.mdsell,  Setting.month_mds.end_mdsell, Setting.month_mds.yoy_mdrcy, Setting.month_mds.mom_mdrcy,Setting.month_mds.yoy_mdsell, Setting.month_mds.mom_mdsell]  
    md_arr = [md.mdrcy, md.end_mdrcy,md.mdsell,  md.end_mdsell, md.yoy_mdrcy, md.mom_mdrcy,md.yoy_mdsell, md.mom_mdsell]  
    md_table = [md_header, md_arr]
    docx.p '中水处理' do
      style 'table_caption'
    end
    docx.table md_table, border_size: 4 do
      cell_style rows[0], background: '3366cc', color: 'ffffff', bold: true
      #cell_style cols[0], width: 6000
    end
  end

  def style_config(docx)
    docx.style do
      id "h2"
      name "h2"
      font "黑体"
      size 40
      bold true
      italic false
    end
    docx.style do
      id "h3"
      name "h3"
      font "黑体"
      size 36
      bold true
      italic false
    end
    docx.style do
      id "h4"
      name "h4"
      font "黑体"
      size 32
      bold true
      italic false
      indent_left 340
    end
    docx.style do
      id "p"
      name "p"
      font "宋体"
      size 30
      bold false 
      italic false
      indent_left 360
    end
    docx.style do
      id "table_caption"
      name "table_caption"
      align :center
      font "宋体"
      size 30
      bold false 
      italic false
    end
  end
end
