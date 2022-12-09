$(".wx_workers").ready(function() {
  if ($(".wx_workers.index").length > 0) {
    get_wx_workers('wx_workers')
    $("#item-table").on('click', 'button.log-show-btn', function(e) {
      $('#logModal').modal();
      var that = e.target
      var data_id = that.dataset['id'];
      var url = "/wx_workers/" + data_id + "/signlogs";
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
      var url = "/wx_workers/" + data_id + "/query_info";
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
});

function get_wx_workers(method) {
  var $table = $('#item-table');
  var data = [];
  var url = "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;
      var button = "<button class = 'button button-royal button-small mr-1 log-show-btn' type = 'button' data-id ='" + id + "'>签到记录</button><button class = 'button button-primary button-small mr-1 worker-show-btn' type = 'button' data-id ='" + id + "'>证件照</button>"
      data.push({
        'id' : index + 1,
         
        'name' : item.name,
         
        'idno' : item.idno,
         
        'phone' : item.phone,
         
        'gender' : item.gender,
         
        'adress' : item.adress,
         
        'fct' : item.fct,
        
        'button' : button 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

