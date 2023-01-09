$(".controls.index").ready(function() {
  if ($(".controls.index").length > 0) {
    loadSelectData('/factories/' + gon.fct + '/sign_logs/query_device')
    var start = $("#start").val();
    var end = $("#end").val();
    initControlChart(start, end, gon.fct);

    $(".area-time-search").on('click', function(e) {
      var start = $("#start").val();
      var end = $("#end").val();
      var fct = $("#fct").val();
      initControlChart(start, end, fct);
    })
  }
});

function initControlChart(start, end, fct) {
  var request_params = {start: start, end: end, fct: fct}
  $.get('/factories/' + gon.fct + '/statics/static_by_progress', request_params).done(function (data) {
    createPie('order-static-pie', '工单进度统计', '', data.data)
  });
  $.get('/factories/' + gon.fct + '/statics/static_count_perday', request_params).done(function (data) {
    createSingleLine('order-count-perday-line', '工单日统计数据', '', data.xaxis, data.data)
  });
  $.get('/factories/' + gon.fct + '/statics/static_by_category', request_params).done(function (data) {
    createCirclePie('order-static-circlepie', '工单分类统计', '', data.data)
  });
}

function createPie(chartId, text, subtext, data) { 
  var chartDom = document.getElementById(chartId);
  var myChart = echarts.init(chartDom);
  var option;
  
  option = {
    title: {
      text: text,
      subtext: subtext,
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        type: 'pie',
        radius: '50%',
        data: data, 
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  };
  
  option && myChart.setOption(option);
}

function createSingleLine(chartId, text, subtext, xaxis, data) { 
  var chartDom = document.getElementById(chartId);
  var myChart = echarts.init(chartDom);
  var option;
  
  option = {
    title: {
      text: text, 
      left: 'center',
      align: 'right'
    },
    label: { show: true },
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
    xAxis: {
      type: 'category',
      data: xaxis 
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        data: data,
        type: 'line',
        smooth: true
      }
    ]
  };
  
  option && myChart.setOption(option);
}

function createCirclePie(chartId, text, subtext, data) { 
  var chartDom = document.getElementById(chartId);
  var myChart = echarts.init(chartDom);
  var option;
  
  option = {
    title: {
      text: text,
      subtext: subtext,
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      top: '5%',
      left: 'center'
    },
    series: [
      {
        name: '',
        type: 'pie',
        radius: ['30%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 10,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: false,
          position: 'center'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 40,
            fontWeight: 'bold'
          }
        },
        labelLine: {
          show: false
        },
        data: data 
      }
    ]
  };
  
  option && myChart.setOption(option);
}
