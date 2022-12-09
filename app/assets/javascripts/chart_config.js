function scatterOption(title, dimensions, datasets) {
  var symbolSize = 2.5;
  option = {
      grid3D: {},
      xAxis3D: {
          type: 'category'
      },
      yAxis3D: {},
      zAxis3D: {},
      dataset: {
          dimensions: dimensions, 
          source: datasets
      },
      series: [
          {
              type: 'scatter3D',
              symbolSize: symbolSize,
              encode: {
                  x: dimensions[0], 
                  y: dimensions[1],
                  z: dimensions[2],
                  tooltip: [0, 1, 2]
              }
          }
      ]
  }
  return option
}

function gaugeOption(name, value, min, max, color) {
  option = {
    tooltip: {
        formatter: '{b} : {c}'
    },
    series: [{
        name: name,
        type: 'gauge',
        min: min,
        max: max,
        itemStyle: {
          color: color 
        },
        axisLine: {
          lineStyle: {
             width: 5 
          }
        },
        progress: {
            show: true,
            width: 5 
        },
        splitLine: {
          length: 6,
          lineStyle: {
            width: 2,
            color: '#999'
          }
        },
        axisLabel: {
          distance: 10,
          color: '#999',
          fontSize: 10 
        },
        detail: {
            valueAnimation: true,
            formatter: '{value}',
            offsetCenter: [0, '60%']
        },
        data: [{
            value: value,
            name: name 
        }]
    }]
  };
  return option
}

function radarOption(my_title, my_series, my_dimensions, my_datasets, my_indicator) {
  option = {
    title: {
      text: my_title 
    },
    legend: {
      //data: [ '2015', '2016', '2017']
    },
    tooltip: {
      show: true
    },
    radar: {
      shape: 'circle',
      indicator: my_indicator
      //axisLabel:{ show:true, color:'#232', showMaxLabel: true},
    },
    label: {
      show: true
    },
    series: my_series,
    dataset: {
      dimensions: my_dimensions,
      source: my_datasets
    }
  }
  return option;
}

function newOption(my_title, my_series, my_dimensions, my_source) {
  var new_Option = {
    title: {
      text: my_title, 
      subtext: '',
      left: 'center',
      align: 'right'
    },
    legend: { 
      data: my_dimensions,
      left: 10
    },
    label: { show: true },
    tooltip: { trigger: 'axis' },
    xAxis: {type: 'category'},
    yAxis: {},
    toolbox: {
      show: true,
      feature: {
         dataView: {readOnly: false},
         magicType: {type: ['line', 'bar']},
         restore: {show: true},
         saveAsImage: {}
      }
    },
    dataZoom: [
      {            
        type: 'slider',
        show: true,
        xAxisIndex: [0],
        startValue: '0'
      },
      {            
        type: 'slider',
        show: true,
        yAxisIndex: [0],
        startValue: '0'
      }
    ],
    series: my_series,
    dataset: {
      dimensions: my_dimensions,
      source: my_source  
    }
  }
  return new_Option;
}


function rainOption(data) {
  option = {
      title: {
          text: data.title_text,
          subtext: data.title_subtext,
          left: 'center',
          align: 'right'
      },
      grid: {
          bottom: 80
      },
      toolbox: {
          feature: {
              dataZoom: {
                  yAxisIndex: 'none'
              },
              magicType: {type: ['line', 'bar']},
              restore: {show: true},
              saveAsImage: {}
          }
      },
      tooltip: {
          trigger: 'axis',
          axisPointer: {
              type: 'cross',
              animation: false,
              label: {
                  backgroundColor: '#505765'
              }
          }
      },
      legend: {
          data: data.legend,
          left: 10
      },
      dataZoom: [
          {
              show: true,
              realtime: true,
              start: 0,
          },
          {
              type: 'inside',
              realtime: true,
              start: 0
          }
      ],
      xAxis: [
          {
              type: 'category',
              boundaryGap: false,
              axisLine: {onZero: false},
              data: data.time.map(function (str) {
                  return str.replace(' ', '\n');
              })
          }
      ],
      yAxis: [
          {
              name: data.legend[0],
              type: 'value',
              max: data.y1_max,
          },
          {
              name: data.legend[1],
              nameLocation: 'start',
              max: data.y2_max,
              type: 'value',
              inverse: true
          }
      ],
      series: [
          {
              name: data.legend[0],
              type: 'line',
              areaStyle: {},
              lineStyle: {
                  width: 1
              },
              emphasis: {
                  focus: 'series'
              },
              markArea: {
                  silent: true,
                  itemStyle: {
                      opacity: 0.3
                  },
                  data: [[{
                      xAxis: data.start_time 
                  }, {
                      xAxis: data.end_time 
                  }]]
              },
              data: data.s1_data 
          },
          {
              name: data.legend[1],
              type: 'line',
              yAxisIndex: 1,
              areaStyle: {},
              lineStyle: {
                  width: 1
              },
              emphasis: {
                  focus: 'series'
              },
              markArea: {
                  silent: true,
                  itemStyle: {
                      opacity: 0.3
                  },
                  data: [
                      [{
                          xAxis: data.start_time 
                      }, {
                          xAxis: data.end_time 
                      }]
                  ]
              },
              data: data.s2_data 
          }
      ]
  };
  return option
}

function multYaxisOption(my_title, my_colors, my_legend, my_xaxis, my_yAxis, my_series) {
  var colors = my_colors;
  
  option = {
      color: colors,
      toolbox: {
        show: true,
        feature: {
           dataView: {readOnly: false},
           magicType: {type: ['line', 'bar']},
           restore: {show: true},
           saveAsImage: {}
        }
      },
      dataZoom: [
        {            
          type: 'slider',
          show: true,
          xAxisIndex: [0],
          startValue: '0'
        },
        {            
          type: 'slider',
          show: true,
          yAxisIndex: [0],
          startValue: '0'
        }
      ],
      tooltip: {
          trigger: 'axis',
          axisPointer: {
              type: 'cross'
          }
      },
      legend: {
          data: my_legend 
      },
      xAxis: [
          {
              type: 'category',
              axisTick: {
                  alignWithLabel: true
              },
              data: my_xaxis 
          }
      ],
      yAxis: my_yAxis,
      series: my_series
  }
  return option;
}

//取特定时期的数据
function periodChartConfig(url, that_chart, factory_id, start, end, qcodes){
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var pos_type = that_chart.dataset['pos'];

  var chart = echarts.init(that_chart);
  chart.showLoading();
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type, pos_type: pos_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}

function emqChartConfig(url, that_chart, factory_id, start, end, qcodes) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}

function emrChartConfig(url, that_chart, factory_id, start, end, qcodes) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}

function powerChartConfig(url, that_chart, factory_id, start, end, qcodes) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var mul_Option =  multYaxisOption(data.title, data.colors, data.legend, data.xaxis, data.yaxis, data.series)
    chart.setOption(mul_Option, true);
  });
  return chart;
}

function bomChartConfig(url, that_chart, factory_id, start, end, qcodes) {
  var chart = echarts.init(that_chart);
  chart.showLoading();
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type, chart_type: chart_type}
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = newOption(data.title, data.series, data.dimensions, data.datasets)
    chart.setOption(new_Option, true);
  });
  return chart;
}
//search_type 当前页面的checkbox
function chartTable(ctnid, factory_id, start, end, qcodes, search_type){
  var obj = {factory_id: factory_id, start: start, end: end, qcodes: qcodes, search_type: search_type}
  var url = "/day_pdt_rpts/static_pool";

  $.get(url, obj).done(function (data) {
    dataSummary(data.static_pool, ctnid)
  });
}

function dataSummary(static_pool, ctnid) {
  var pool_title = "";
  var pool_sum = "";
  var pool_avg = "";
  $.each(static_pool, function(k, v) {
    pool_title += "<td>" + v['title'] + "</td>";
    pool_sum += "<td>" + v['sum'] + "</td>";
    pool_avg += "<td>" + v['avg'] + "</td>";
  })

  var rpt_table = "<table class='table table-bordered'>" +
    "<tr>" +
      "<td></td>" + 
      pool_title +
    "</tr>" + 
    "<tr>" +
      "<td>总和" + "</td>" + 
      pool_sum +
    "</tr>" + 
    "<tr>" +
      "<td>平均值" + "</td>" + 
      pool_avg +
    "</tr>" + 
    "</table>";
  $(ctnid).html(rpt_table);
}
