$(".order_logs").ready(function() {
  if ($(".order_logs.index").length > 0) {
    get_order_logs('order_logs');
  }
});

function get_order_logs(method) {
  var $table = $('#item-table');
  var data = [];
  //var data_fct = $('#fct').val();
  //var url = "/factories/" + data_fct + "/" + method + "/query_all";
  var url = "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var id = item.id;
      //var button = "<button id='info-btn' class = 'button button-primary button-small mr-1' type = 'button' data-rpt ='" + id + "'>查看</button>" + "<a class='button button-royal button-small mr-1' href='/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/" + method + "/" + id + "'>删除</a>"
      var button = "<a class='button button-primary button-small mr-1' href='/" + method + "/" + id + "/'>查看</a>" + "<a class='button button-royal button-small mr-1' href='/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/" + method + "/" + id + "'>删除</a>"
      data.push({
        'id' : index + 1,
         
        'feedback' : item.feedback,
         
        'content' : item.content,
         
        'longitude' : item.longitude,
         
        'latitude' : item.latitude,
         
        'upman' : item.upman,
         
        'nextman' : item.nextman,
         
        'start_time' : item.start_time,
         
        'end_time' : item.end_time,
         
        'state' : item.state,
         
        'img' : item.img,
         
        'address' : item.address,
         
        'item' : item.item,
        
        'button' : button 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

//var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.fct_id +"'>查看</button>"; 
//var factory = item.factory;
//var search = "<a class='button button-royal button-small mr-1' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/factories/" + factory + "/" + method + "/" + id + "'>删除</a>"