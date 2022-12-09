$(".factories.index").ready(function() {
  if ($(".factories.bigscreen").length > 0) {
    var charts = []
    $(".chart-statistic-ctn").each(function(index, e) {
      var chart = radarChartSet(e);
      charts.push(chart);
    });

    $(".chart-gauge-ctn").each(function(index, that_chart) {
      var qcode = that_chart.dataset['code'];
      var factory_id = that_chart.dataset['fct'];
      var chart = echarts.init(that_chart);
      chart.showLoading();

      var obj = {factory_id: factory_id, qcode: qcode }
      var url = "/day_pdt_rpts/new_quota_chart";
      $.get(url, obj).done(function (data) {
        chart.hideLoading();
        
        var new_Option = gaugeOption(data.name, data.value, data.min, data.max, data.color)
        chart.setOption(new_Option, true);
        chart.resize(); //没有初始宽高 resize初始化父容器的宽高
      });
      charts.push(chart);
    });
    
    baiduMap('map-container')

    var that_chart = document.getElementById("bigscreen-cms");
    var factory_id = that_chart.dataset['fct'];
    var start = GetDateStr(-30);
    var end = GetDateStr(-1);
    console.log(start);
    console.log(end);
    var qcodes = "0,3,4"
    var url = "/day_pdt_rpts/sglfct_stc_cau";
    chart = periodChartConfig(url, that_chart, factory_id, start, end, qcodes)
    charts.push(chart);

    chartResize(charts);
  }

});

function baiduMap(id) {
  var map = new BMapGL.Map(id); // 创建Map实例
  var point = new BMapGL.Point(gon.lnt, gon.lat);
  map.centerAndZoom(point, 15); // 初始化地图,设置中心点坐标和地图级别
  var marker1 = new BMapGL.Marker(point);
  map.addOverlay(marker1);
  var opts = {
    position: point,
    offset: new BMapGL.Size(30, -30)
  };
  // 创建文本标注对象
  var label = new BMapGL.Label(gon.title + "<br/>" + gon.lnt + ", " + gon.lat, opts);
  label.setStyle({
    color: 'black',
    padding: '10px',
    fontSize: '16px',
    fontFamily: '微软雅黑'
  });
  map.addOverlay(label);
  map.enableScrollWheelZoom(true); // 开启鼠标滚轮缩放
}

function GetDateStr(AddDayCount) { 
  var dd = new Date();
  dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期
  var y = dd.getFullYear(); 
  var m = (dd.getMonth()+1)<10?"0"+(dd.getMonth()+1):(dd.getMonth()+1);//获取当前月份的日期，不足10补0
  var d = dd.getDate()<10?"0"+dd.getDate():dd.getDate();//获取当前几号，不足10补0
  return y+"-"+m+"-"+d; 
}

function chartResize(charts) {
  //浏览器窗口大小变化时，重置报表大小
  $(window).resize(function() {
    for (var i =0; i <charts.length; i++ ) {
      charts[i].resize();
    }
  });
}

function radarChartSet(that_chart) {
  var chart_type = that_chart.dataset['chart'];
  var search_type = that_chart.dataset['type'];
  var pos_type = that_chart.dataset['pos'];
  var factory_id = that_chart.dataset['fct'];

  var chart = chartRadar(that_chart, factory_id, search_type, pos_type, chart_type)
  return chart;
}

function chartRadar(that_chart, factory_id, search_type, pos_type, chart_type){
  var chart = echarts.init(that_chart);

  chart.showLoading();
  var obj = {factory_id: factory_id, search_type: search_type, pos_type: pos_type, chart_type: chart_type }
  var url = "/day_pdt_rpts/radar_chart";
  $.get(url, obj).done(function (data) {
    chart.hideLoading();
    
    var new_Option = radarOption(data.title, data.series, data.dimensions, data.datasets, data.indicator)
    chart.setOption(new_Option, true);
    chart.resize();
  });
  return chart;
}

