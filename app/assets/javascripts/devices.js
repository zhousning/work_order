$(".devices").ready(function() {
  if ($(".devices.index").length > 0) {
    getDeviceItems('devices');
  }
});

function getDeviceItems(method) {
  var $table = $('#item-table')
  var data = [];
  var data_fct = $('#fct').val();
  var url = "/factories/" + data_fct + "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      var button = "<button id='info-btn' class = 'button button-primary button-small' type = 'button' data-rpt ='" + item.id + "' data-fct = '" + item.factory +"'>查看</button>"; 
      var factory = item.factory;
      var id = item.id;
      //var search = "<a class='button button-royal button-small mr-3' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/factories/" + factory + "/" + method + "/" + id + "'>删除</a>"
      //var search = "<a class='button button-royal button-small mr-3' href='/factories/" + factory + "/" + method + "/" + id + "/edit'>编辑</a>"
      data.push({
        'id' : index + 1,
        'idno' : item.idno,
        'name' : item.name,
        'mdno' : item.mdno,
        'unit' : item.unit,
        'pos' : item.pos,
        'supplier' : item.supplier,
        'pos_no' : item.pos_no
        //'state' : item.state
        //'search' : search 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

