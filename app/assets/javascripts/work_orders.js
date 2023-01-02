$(".work_orders").ready(function() {
  if ($(".work_orders.index").length > 0) {
    get_work_orders('work_orders');
    worker_order_bind_event();
  }
  if ($(".work_orders.complete").length > 0) {
    worker_order_complete_event();
  }
});

function worker_order_complete_event() {
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
    get_task_info(data_fct, data_id);
    get_task_record(data_fct, data_id);
    get_task_rate(data_fct, data_id);
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

    if (confirm('确认已办结吗?') == true) {
      var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/finish";
      $.get(url).done(function (data) {
        if (data.state == 'success') {
          get_work_orders('work_orders');
        } else {
          alert('任务处理失败');
        }
      });
    }
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
    var emq_table = '<tr><th>部门</th><th>用户名</th><th>电话</th><th>状态</th><th>操作</th></tr>';
    for (var i=0; i<emq.length; i++) {
      emq_table += '<tr>'; 
      emq_table += "<td>" + emq[i]['dept'] + "</td>"; 
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
      var button = "<button class = 'btn btn-link  mr-3 worker-show-btn' type = 'button' data-rpt ='" + id + "'>分配工单</button>" + "<a class=' btn btn-link  mr-3' href='/factories/" + data_fct + '/' + method + "/" + id + "/edit'>编辑</a>" + "<button class = 'btn btn-link  mr-3 worker-complete-btn' type = 'button' data-rpt ='" + id + "'>办结</button>"  + "<a data-confirm='确定删除吗?' class='btn btn-link worker-delete-btn' rel='nofollow' data-method='delete' href='/factories/" + data_fct + '/' + method + "/" + id + "'>删除</a>";
      data.push({
        'id' : index + 1,
        'ctg' : item.ctg,
        'number' : number,
        'reminder' : item.reminder,
        'content' : item.content,
        'address' : item.address,
        'state' : item.state,
        'pdt_time' : item.pdt_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'button' : button 
        //'title' : item.title,
        //'urgent' : item.urgent,
        //'order_time' : item.order_time,
        //'img' : item.img,
      });
    });
    $table.bootstrapTable('load', data);
  })
}

function get_task_rate(data_fct, data_id) {
  var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/query_rate";
  $.get(url).done(function (data) {
    var emq = data;
    var emq_table = '';
    for (var i=0; i< emq.length; i++) {
      var state = emq[i].state;
      var color = emq[i].color;
      var user = emq[i].user;
      var feedstr = "<span class='badge text-white " + color + " mr-3'>" + state + "</span>";
      emq_table += "<li><p>" + feedstr  + user + "</p></li>"
    }
    $("#task-rate").html(emq_table);
  });
}

function get_task_record(data_fct, data_id) {
  var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/query_record";
  $.get(url).done(function (data) {
    var emq = data;
    var emq_table = '';
    for (var i=0; i< emq.length; i++) {
      var feedback = emq[i].feedback;
      var imgs = emq[i].imgs;
      var img = "";
      var feedstr = "<span class='badge badge-success ml-3'>已解决</span>";
      if (!feedback) {
        feedstr = "<span class='badge badge-danger ml-3'>未解决</span>";
      }
      for (var j=0; j<imgs.length; j++) {
        img += "<div class='col-3'> <img src='" + imgs[j] + "' class='img-thumbnail'></div>";
      }
      emq_table += "<li class='media mb-2'><div class='media-body'><h5 class='mt-0 mb-1'>" + emq[i].user + ' ' + emq[i].time + feedstr + "</h5><p>" + emq[i].content + "</p><div class='row'>" + img + "</div></div></li>"
    }
    $("#task-record").html(emq_table);
  });
}

function get_task_info(data_fct, data_id) {
  var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/query_info";
  $.get(url).done(function (data) {
    var emq = data.obj;
    var imgs = data.imgs;
    var emq_table = '';
    $.each(emq, function(k, v) {
      emq_table += '<p>' + k + ': ' + v + '</p>'; 
    })
    for(var i=0; i<imgs.length; i++) {
      emq_table += "<img class='img-fluid' src='" + imgs[i] + "'/>"
    }
    $("#log-day-emq-ctn").html(emq_table);
    $("#log-day-pdt-rpt-header").html(data.number);
  });
}
