module ChartConfig
  #include MyCommon

  #MYQUOTAS = MyCommon.quota_hash

  def my_factory
    @factory = current_user.factories.find(iddecode(params[:factory_id]))
  end
  #雷达图 核心参数: search_type用于筛选出合法的指标code(化验、污泥、电耗、中水), pos_type用于区分标题,根据不同的位置获取不同的数据(进水、出水、其他), qcodes指标代码('1,2,3')

  #获取某一天的分类指标数据化验(cod、bod、tn)、污泥(inmud、outmud)等
  def some_day_quota(have_date, day_pdt_rpt, search_type, pos_type, chart_type, _qcodes)
    @factory = my_factory

    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes.nil? ? my_real_codes : _qcodes & my_real_codes #查询哪些指标 

    #图表配置项
    series = []
    series << {type: chart_type(chart_type)}
    dimensions = []
    real_codes.each do |code|
      dimensions << MYQUOTAS[code][:name]
    end

    chart_config = {}

    #图表数据
    day_pdt_rpts = @day_pdt_rpt ? [@day_pdt_rpt] : []
    datasets = get_datasets(have_date, day_pdt_rpts, real_codes, pos_type) 
    chart_config = my_chart_config(pos_type, series, dimensions, datasets)

    chart_config
  end

  #获取指定时期的多个指标
  #分别显示
  def period_multiple_quota(have_date, day_pdt_rpts, search_type, pos_type, chart_type, _qcodes)
   
    #避免传递非当前分类中的数据
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes.nil? ? my_real_codes : _qcodes & my_real_codes #查询哪些指标 

    #图表配置项
    series = []
    dimensions = ['date']
    real_codes.each do |code|
      series << {type: chart_type(chart_type)}
      dimensions << MYQUOTAS[code][:name]
    end

    chart_config = {} 

    #图表数据
    datasets = get_datasets(have_date, day_pdt_rpts, real_codes, pos_type)
    chart_config = my_chart_config(pos_type, series, dimensions, datasets)

    chart_config
  end

  #获取特定时期多个指标削减量
  def period_quota_emq(have_date, day_pdt_rpts, search_type, chart_type, _qcodes)
    #避免传递非当前分类中的数据
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes.nil? ? my_real_codes : _qcodes & my_real_codes #查询哪些指标 

    #图表配置项
    series = []
    dimensions = ['date']
    real_codes.each do |code|
      series << {type: chart_type(chart_type)}
      dimensions << MYQUOTAS[code][:name]
    end

    chart_config = {} 

    #图表数据
    datasets = get_emq_datasets(have_date, day_pdt_rpts, real_codes)
    chart_config = my_chart_config('', series, dimensions, datasets)

    chart_config
  end

  #获取特定时期多个指标削减率
  def period_quota_emr(have_date, day_pdt_rpts, search_type, chart_type, _qcodes)
    #避免传递非当前分类中的数据
    my_real_codes = my_real_codes(search_type)
    real_codes = _qcodes.nil? ? my_real_codes : _qcodes & my_real_codes #查询哪些指标 

    #图表配置项
    series = []
    dimensions = ['date']
    real_codes.each do |code|
      series << {type: chart_type(chart_type)}
      dimensions << MYQUOTAS[code][:name]
    end

    chart_config = {} 

    #图表数据
    datasets = get_emr_datasets(have_date, day_pdt_rpts, real_codes)
    chart_config = my_chart_config('', series, dimensions, datasets)

    chart_config
  end

  #带日期数据
  #[
  # { :date => '2021-02-01', 'cod' => 2, 'bod' => 5 },
  # { :date => '2021-02-02', 'cod' => 2, 'bod' => 5 },
  #]
  def get_emq_datasets(have_date, day_pdt_rpts, real_codes)
    datasets = []
    day_pdt_rpts.each do |rpt|
      if have_date
        dataset_item = {'date': rpt.pdt_date}
      else
        dataset_item = {}
      end

      real_codes.each do |code|
        quota_emq(dataset_item, code, rpt)
      end

      datasets << dataset_item
    end
    datasets
  end

  #带日期数据
  #[
  # { :date => '2021-02-01', 'cod' => 2, 'bod' => 5 },
  # { :date => '2021-02-02', 'cod' => 2, 'bod' => 5 },
  #]
  def get_emr_datasets(have_date, day_pdt_rpts, real_codes)
    datasets = []
    day_pdt_rpts.each do |rpt|
      if have_date
        dataset_item = {'date': rpt.pdt_date}
      else
        dataset_item = {}
      end

      real_codes.each do |code|
        quota_emr(dataset_item, code, rpt)
      end

      datasets << dataset_item
    end
    datasets
  end

  #带日期数据
  #[
  # { :date => '2021-02-01', 'cod' => 2, 'bod' => 5 },
  # { :date => '2021-02-02', 'cod' => 2, 'bod' => 5 },
  #]
  def get_datasets(have_date, day_pdt_rpts, real_codes, pos)
    datasets = []
    day_pdt_rpts.each do |rpt|
      if have_date
        dataset_item = {'date': rpt.pdt_date}
      else
        dataset_item = {}
      end

      real_codes.each do |code|
        if pos == Setting.quota.pos_inf
          inf_quota(dataset_item, code, rpt)
        elsif pos == Setting.quota.pos_eff
          eff_quota(dataset_item, code, rpt)
        elsif pos == Setting.quota.pos_other
          other_quota(dataset_item, code, rpt)
        end
      end

      datasets << dataset_item
    end
    datasets
  end


  def chart_type(chart)
    charts = {
      Setting.charts.line    =>    Setting.charts.line_t,
      Setting.charts.bar     =>    Setting.charts.bar_t,
      Setting.charts.gauge   =>    Setting.charts.gauge_t,
      Setting.charts.table   =>    Setting.charts.table_t,
      Setting.charts.radar   =>    Setting.charts.radar_t,
      Setting.charts.scatter_3d   =>    Setting.charts.scatter_3d_t
    }
    charts[chart]
  end

  def my_chart_config(pos_type, series, dimensions, datasets) 
    chart_config = Hash.new 
    chart_config['title'] = get_title(pos_type)
    chart_config['series'] = series
    chart_config['dimensions'] = dimensions
    chart_config['datasets'] = datasets
    chart_config
  end
end
