$(".fct_statics.index").ready(function() {
  if ($(".fct_statics.index").length > 0) {
    var table = "#day-pdt-rpt-table";
    var url = '/factories/' + gon.fct + '/fct_statics/query_by_area';

    loadSelectData('/factories/' + gon.fct + '/fct_statics/query_device')

    date_event("#log-pdt-rpt-table", '/factories/' + gon.fct + '/fct_statics/log_detail')
    date_report('/factories/' + gon.fct + '/fct_statics/xls_download') 

    $(".area-time-search").on('click', function(e) {
      var start = $("#start").val();
      var fct = $("#fct").val();
      
      request_params = {start: start, fct: fct}
      $.get(url, request_params).done(function (obj) {
        console.log(obj);
        var html = '<caption>签到人数</caption>'; 
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
        })
        $(table).html(html);
      })
    })
  }
});

