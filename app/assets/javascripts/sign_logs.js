$(".sign_logs").ready(function() {
  if ($(".sign_logs.index").length > 0) {
    loadSelectData('/factories/' + gon.fct + '/sign_logs/query_device')
    
    $(".area-time-search").on('click', function(e) {
      get_sign_logs();
    })

    $("#item-table").on('click', 'button.log-show-btn', function(e) {
      $('#logModal').modal();
      var that = e.target
      var data_id = that.dataset['rpt'];
      var data_fct = $('#fct').val();
      get_task_info(data_fct, data_id);
      get_task_record(data_fct, data_id);
      get_task_rate(data_fct, data_id);
    });
  }
});

function get_sign_logs() {
  var $table = $('#item-table');
  var start = $("#start").val();
  var end = $("#end").val();
  var fct = $("#fct").val();
  var data = [];
  
  var url = '/factories/' + gon.fct + "/sign_logs/query_list";
  var request_params = {start: start, end: end, fct: fct}

  $.get(url, request_params).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;
      var number = "<button class = 'btn btn-link log-show-btn' type = 'button' data-rpt ='" + id + "'>" + item.number + "</button>";

      data.push({
        'id' : index + 1,
        'ctg' : item.ctg,
        'number' : number,
        'title' : item.title,
        'pdt_time' : item.pdt_time,
        'content' : item.content,
        'address' : item.address,
        'state' : item.state,
        'order_time' : item.order_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'img' : item.img
      });
    });
    $table.bootstrapTable('load', data);
  })
}

