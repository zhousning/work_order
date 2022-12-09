$(".grp_statics.index").ready(function() {
  if ($(".grp_statics.index").length > 0) {
    var table = "#day-pdt-rpt-table";
    var url = '/grp_statics/query_by_area';

    loadSelectData('/grp_statics/query_device')

    date_event("#log-pdt-rpt-table", '/grp_statics/log_detail')
    date_report('/grp_statics/xls_download') 

    $(".area-time-search").on('click', function(e) {
      var start = $("#start").val();
      var fct = $("#fct").val();
      
      request_params = {start: start, fct: fct}
      $.get(url, request_params).done(function (obj) {
        console.log(obj);
        var html = ''; 
        var total_sum = 0;
        $.each(obj, function(town, value) {
          var town_count = 0;
          var country_html = ''
          var sum = 0;
          var first_html = ''
          $.each(value, function(country, count) {
            town_count += count;
            sum += 1;
            if (sum == 1) {
              first_html = '<td>' + country + '(' + count + ')</td>';
            } else {
              country_html += '<tr><td>' + country + '(' + count + ')</td></tr>'; 
            }
          })
          html += '<tr><td rowspan=' + sum + '>' + town + '(' + town_count + ')</td>' + first_html + '</tr>' + country_html 
          total_sum += town_count
        })
        var result = '<caption>签到总人数：' + total_sum + '</caption>' + html; 
        $(table).html(result);
      })
    })
  }
});

