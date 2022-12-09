function sday_pdt_modal() {
  var myChart = echarts.init(document.getElementById('chart-ctn'));
  $("#day-pdt-rpt-table").on('click', 'button', function(e) {
    myChart.showLoading();
    $('#newModal').modal();
    var that = e.target
    var data_fct = that.dataset['fct'];
    var data_rpt = that.dataset['rpt'];
    var url = "/sfactories/" + data_fct + "/sday_pdt_rpts/" + data_rpt + "/produce_report";
    $.get(url).done(function (data) {
      myChart.hideLoading();
      var header = data.header.name;
      $("#day-pdt-rpt-header").html(header);

      var emq = data.energy;
      var emr = data.cms;
      var fct_id = data.fct_id;
      var day_rpt_id = data.day_rpt_id;
      
      var xls_download = "/sfactories/" + fct_id + "/sday_pdt_rpts/" + day_rpt_id + "/xls_day_download";
      $("#xls-download").attr("href", xls_download);

      var emq_table = '<tr><th>出厂水平均压力(Mpa)</th><th>用电量(千瓦时)</th><th>千吨水耗电量(千瓦时/dam3)</th><th>余氯(mg/l)</th><th>浊度(NTU)</th><th>硬度(mg/l)</th><th>PH</th></tr>';
      emq_table += '<tr>'; 
      $.each(emq, function(k, v) {
        emq_table += "<td>" + v + "</td>"; 
      })
      emq_table += '</tr>'; 
      $("#day-emq-ctn").html(emq_table);

      var title = '水量';
      var series = [{type: 'bar', label: {show: true}}];
      var dimensions = ['source', '水量'];
      var new_Option = newOption(title, series, dimensions, data.datasets)
      myChart.setOption(new_Option);
    });
  });

}
