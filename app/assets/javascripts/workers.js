$(".workers").ready(function() {
  if ($(".workers.index").length > 0) {
    get_workers('query_all')
    worker_info_bind()
  }
  if ($(".workers.unvalidate").length > 0) {
    get_workers('query_unvalidate')
    worker_info_bind()
    worker_operate_bind()
  }
});


function worker_info_bind() {
  $("#item-table").on('click', 'button.log-show-btn', function(e) {
    $('#logModal').modal();
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/factories/" + gon.fct + "/workers/" + data_id + "/signlogs";
    $.get(url).done(function (data) {
      var emq = data;
      var emq_table = '<tr><th></th><th>时间</th><th>负责人</th><th>站点</th><th>经纬度</th><th></th></tr>';
      for (var i=0; i<emq.length; i++) {
        var j = i + 1
        emq_table += '<tr>'; 
        emq_table += "<td>" + j + "</td>"; 
        emq_table += "<td>" + emq[i].time + "</td>"; 
        emq_table += "<td>" + emq[i].fzr + "</td>"; 
        emq_table += "<td>" + emq[i].zd + "</td>"; 
        emq_table += "<td>" + emq[i].jwd + "</td>"; 
        emq_table += "<td>" + "<img class='h-100px' src='" + emq[i].img + "'/>" + "</td>"; 
        emq_table += '</tr>'; 
      }
      $("#log-day-emq-ctn").html(emq_table);
    });
  });
  $("#item-table").on('click', 'button.worker-show-btn', function(e) {
    $('#newModal').modal();
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/factories/" + gon.fct + "/workers/" + data_id + "/query_info";
    $.get(url).done(function (data) {
      var emq = data.info;
      var address = data.address;
      var imgs = data.img;
      
      var emq_table = '<tr><th>姓名</th><th>身份证</th><th>电话</th></tr>';
      emq_table += '<tr>'; 
      for (var i=0; i<emq.length; i++) {
        emq_table += "<td>" + emq[i] + "</td>"; 
      }
      emq_table += '</tr>'; 
      $("#day-emq-ctn").html(emq_table);

      var image = ''
      for (var j=0; j<imgs.length; j++) {
         image += "<img class='col-6' src='" + imgs[j] + "'/>" 
      }
      $("#chart-ctn").html(image);
    });
  });
}

function worker_operate_bind() {
  $("#item-table").on('click', 'button.receive-worker-btn', function(e) {
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/factories/" + gon.fct + "/workers/" + data_id + "/receive";
    $.get(url).done(function (data) {
      if (data.state == '0') {
        get_workers('query_unvalidate')
      } else {
        alert('正在处理中');
      }
    });
  });
  $("#item-table").on('click', 'button.reject-worker-btn', function(e) {
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/factories/" + gon.fct + "/workers/" + data_id + "/reject";
    $.get(url).done(function (data) {
      if (data.state == '0') {
        get_workers('query_unvalidate')
      } else {
        alert('正在处理中');
      }
    });
  });
}

function get_workers(method) {
  var $table = $('#item-table');
  var data = [];
  var fct = gon.fct;
  var url = "/factories/" + fct + "/workers/" + method;
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;
      data.push({
        'id' : index + 1,
        'wxuser' : item.wxuser,
        'name' : item.name,
        'idno' : item.idno,
        'phone' : item.phone,
        'gender' : item.gender,
        'adress' : item.adress,
        'state' : item.state,
        'desc' : item.desc,
        'info' : item.info,
        'button' : item.search 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

