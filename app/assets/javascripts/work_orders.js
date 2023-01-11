$(".work_orders").ready(function() {
  if ($(".work_orders.index").length > 0) {
    get_work_orders();
    worker_order_bind_event();

    $("#start-btn").click(function() {
      get_work_orders()
    })
    $("#going-btn").click(function() {
      get_going_orders()
    })
    $("#goed-btn").click(function() {
      get_goed_orders()
    })
    $("#item-table").on('click', 'input[type=checkbox]', function(e) {
      e.stopPropagation();
      var that = e.currentTarget;
      var checked = that.checked;
      var data_fct = $('#fct').val();
      var data_id = $(that).attr('id');
      var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/order_reminder";
      $.get(url, {feedback: checked}).done(function (obj) {
        if (obj.state == 'error') {
          return false;
          alert('设置失败');
        }
      })
    })

    var selectedRow = {}
    $('#item-table').on('click-row.bs.table', function (e, row, $element) {
      selectedRow = row
      $('.order-index-active').removeClass('order-index-active')
      $($element).addClass('order-index-active')

      var data_id = row.id;
      var data_fct = $('#fct').val();
      get_task_info(data_fct, data_id);
      get_task_record(data_fct, data_id);
      get_task_rate(data_fct, data_id);
    })
    function rowStyle(row) {
      if (row.id === selectedRow.id) {
        return {
          classes: 'order-index-active'
        }
      }
      return {}
    }

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
  //$("#item-table").on('click', 'button.log-show-btn', function(e) {
  //  //$('#logModal').modal();
  //  var that = e.target
  //  var data_id = that.dataset['rpt'];
  //  var data_fct = $('#fct').val();
  //  get_task_info(data_fct, data_id);
  //  get_task_record(data_fct, data_id);
  //  get_task_rate(data_fct, data_id);
  //});

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
          get_work_orders();
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
    var data_id = that.dataset['rpt'];
    var data_fct = $('#fct').val();

    if (confirm('确认删除吗?') == true) {
      var url = "/factories/" + data_fct + "/work_orders/" + data_id + "/delete_order";
      $.get(url).done(function (data) {
        if (data.state == 'success') {
          get_work_orders();
        } else {
          alert('正在删除中');
        }
      });
    }
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


function get_work_orders() {
  var $table = $('#item-table');
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/work_orders/query_all";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;

      //var number = "<button class = 'btn btn-link log-show-btn' type = 'button' data-rpt ='" + id + "'>" + item.number + "</button>";
      var button = "<button class = 'btn btn-link   worker-show-btn' type = 'button' data-rpt ='" + id + "'>分配工单</button>" + "<a class=' btn btn-link  ' href='/factories/" + data_fct + '/work_orders/' + id + "/edit'>编辑</a>" + "<button class='btn btn-link worker-delete-btn' type='button' data-rpt='" + id + "'>删除</button>";
      var reminder = '';
      if (item.reminder) {
        reminder = "<span class='switch switch-sm'><input type='checkbox' id='" + id + "' class='switch' checked><label for='" + id + "'></label> </span>"
      } else {
        reminder = "<span class='switch switch-sm'><input type='checkbox' id='" + id + "' class='switch'><label for='" + id + "'></label> </span>"
      }

      var feedstr = "<span class='badge text-white " + item.color + " mr-3'>" + item.state + "</span>";
      data.push({
        'id' : id,
        'number' : item.number,
        'ctg' : item.ctg,
        'reminder' : reminder,
        'content' : item.content,
        'address' : item.address,
        'state' : feedstr,
        'pdt_time' : item.pdt_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'button' : button 
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
    for (var i=0; i<emq.length; i++) {
      emq_table += '<p>' + emq[i] + '</p>'; 
    }
    for(var i=0; i<imgs.length; i++) {
      emq_table += "<img class='img-fluid' src='" + imgs[i] + "'/>"
    }
    $("#log-day-emq-ctn").html(emq_table);
    $("#log-day-pdt-rpt-header").html(data.number);
  });
}

function get_going_orders() {
  var $table = $('#item-table');
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/work_orders/query_going";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;

      var button = "<button class = 'btn btn-link worker-show-btn' type = 'button' data-rpt ='" + id + "'>分配工单</button>" + "<a class=' btn btn-link  ' href='/factories/" + data_fct + '/work_orders/' + id + "/edit'>编辑</a>";

      var feedstr = "<span class='badge text-white " + item.color + " mr-3'>" + item.state + "</span>";
      data.push({
        'id' : id,
        'number' : item.number,
        'ctg' : item.ctg,
        'reminder' : item.reminder,
        'content' : item.content,
        'address' : item.address,
        'state' : feedstr,
        'pdt_time' : item.pdt_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'button' : button 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

function get_goed_orders() {
  var $table = $('#item-table');
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/work_orders/query_goed";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;

      var button = "<button class = 'btn btn-link   worker-show-btn' type = 'button' data-rpt ='" + id + "'>分配工单</button>" + "<a class=' btn btn-link  ' href='/factories/" + data_fct + '/work_orders/' + id + "/edit'>编辑</a>" + "<button class = 'btn btn-link   worker-complete-btn' type = 'button' data-rpt ='" + id + "'>办结</button>";

      var feedstr = "<span class='badge text-white " + item.color + " mr-3'>" + item.state + "</span>";
      data.push({
        'id' : id,
        'number' : item.number,
        'ctg' : item.ctg,
        'reminder' : item.reminder,
        'content' : item.content,
        'address' : item.address,
        'state' : feedstr,
        'pdt_time' : item.pdt_time,
        'limit_time' : item.limit_time,
        'person' : item.person,
        'phone' : item.phone,
        'button' : button 
      });
    });
    $table.bootstrapTable('load', data);
  })
}
