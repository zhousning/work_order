$(".grp_sign_logs").ready(function() {
  if ($(".grp_sign_logs.index").length > 0) {
    var table = "#day-pdt-rpt-table";
    var url = '/grp_sign_logs/query_list';

    loadSelectData('/grp_sign_logs/query_device')
    fct_date_event(table, url)
    fct_date_report('/grp_static/xls_download')   
  }
});

