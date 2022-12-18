$(".work_orders").ready(function() {
  if ($(".work_orders.index").length > 0) {
    get_work_orders('work_orders');
    worker_order_bind_event();
  }
});

function worker_order_bind_event() {
  $("#item-table").on('click', 'button.send-msg-btn', function(e) {
    var that = e.target
    $(that).attr('disabled', true)
    var data_id = that.dataset['id'];
    var url = "/grp_workers/" + data_id + "/send_msg";
    $.get(url).done(function (data) {
      $(that).attr('disabled', false)
      alert(data.message);
    })
  })
  $("#item-table").on('click', 'button.log-show-btn', function(e) {
    $('#logModal').modal();
    var that = e.target
    var data_id = that.dataset['rpt'];
    var data_fct = $('#fct').val();
    var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/query_info";
    $.get(url).done(function (data) {
      var emq = data.obj;
      var emq_table = '';
      $.each(emq, function(k, v) {
        emq_table += '<p>' + k + ': ' + v + '</p>'; 
      })
      $("#log-day-emq-ctn").html(emq_table);
    });
  });

  $("#item-table").on('click', 'button.worker-show-btn', function(e) {
    $('#assignModal').modal();
    var that = e.target
    var data_id = that.dataset['rpt'];
    $('#order-val').val(data_id);

    get_wxworkers(data_id);
  });
  $("#item-table").on('click', 'button.worker-complete-btn', function(e) {
    var that = e.target
    var data_id = that.dataset['rpt'];
    var data_fct = $('#fct').val();

    var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/finish";
    $.get(url).done(function (data) {
      if (data.state == 'success') {
        get_work_orders('work_orders');
      } else {
        alert('任务处理失败');
      }
    });
  });
  $("#day-emq-ctn").on('click', 'button.assign-btn', function(e) {
    var that = e.target
    var data_worker = that.dataset['id'];
    var data_order = $("#order-val").val(); 

    var url = "/work_orders/" + data_order + "/assign?worker=" + data_worker;
    $.get(url).done(function (data) {
      if (data.state == 'success') {
        get_wxworkers(data_order);
      } else {
        alert('分配任务失败');
      }
    });
  });
  $("#item-table").on('click', 'button.worker-delete-btn', function(e) {
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/grp_workers/" + data_id + "/destroy_worker";
    $.get(url).done(function (data) {
      if (data.state == '0') {
        get_grp_workers('grp_workers', 'link')
      } else {
        alert('正在删除中');
      }
    });
  });
}

function get_wxworkers(workorderid) {
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/wxusers/" + "query_list?taskid=" + workorderid;

  $.get(url).done(function (data) {
    var emq = data.info;
    var emq_table = '<tr><th>用户名</th><th>电话</th><th>状态</th><th>操作</th></tr>';
    for (var i=0; i<emq.length; i++) {
      emq_table += '<tr>'; 
      emq_table += "<td>" + emq[i]['name'] + "</td>"; 
      emq_table += "<td>" + emq[i]['phone'] + "</td>"; 
      emq_table += "<td>" + emq[i]['state'] + "</td>"; 
      emq_table += "<td>" + emq[i]['search'] + "</td>"; 
      emq_table += '</tr>'; 
    }
    $("#day-emq-ctn").html(emq_table);
  });
}


function get_work_orders(method) {
  var $table = $('#item-table');
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;

      var number = "<button class = 'btn btn-link log-show-btn' type = 'button' data-rpt ='" + id + "'>" + item.number + "</button>";
      var button = "<button class = 'btn btn-link  mr-3 worker-show-btn' type = 'button' data-rpt ='" + id + "'>分配工单</button>" + "<a class=' btn btn-link  mr-3' href='/factories/" + data_fct + '/' + method + "/" + id + "/edit'>编辑</a>" + "<button data-confirm='确认已办结?'  class = 'btn btn-link  mr-3 worker-complete-btn' type = 'button' data-rpt ='" + id + "'>办结</button>"  + "<a data-confirm='确定删除吗?' class='btn btn-link worker-delete-btn' rel='nofollow' data-method='delete' href='/factories/" + data_fct + '/' + method + "/" + id + "'>删除</a>";
      data.push({
        'id' : index + 1,
        'number' : number,
        'title' : item.title,
        'pdt_time' : item.pdt_time,
        'content' : item.content,
        'address' : item.address,
        'urgent' : item.urgent,
        'state' : item.state,
        'order_time' : item.order_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'img' : item.img,
        'button' : button 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

//var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.fct_id +"'>查看</button>"; 
//var factory = item.factory;
//var search = "<a class='button button-royal button-small mr-3' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/factories/" + factory + "/" + method + "/" + id + "'>删除</a>"
