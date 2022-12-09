$(".wx_sign_logs").ready(function() {
  if ($(".wx_sign_logs.index").length > 0) {
    var table = "#day-pdt-rpt-table";
    var url = '/wx_sign_logs/query_list';

    loadSelectData('/wx_sign_logs/query_device')
    fct_date_event(table, url)
    
  }
});

