$(".grp_devices").ready(function() {
  if ($(".grp_devices.index").length > 0) {
    getGrpDeviceItems('grp_devices');
  }
});

function getGrpDeviceItems(method) {
  var $table = $('#item-table')
  var url = "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    var data = [];
    $.each(objs, function(index, item) {
      //var search = "<a class='button button-royal button-small mr-3' href='/grp_devices/" + item.id + "/edit'>编辑</a><a data-confirm='确定删除吗?' class='button button-caution button-small' rel='nofollow' data-method='delete' href='/grp_devices/" + item.id + "'>删除</a>"
      data.push({
        'id' : index + 1,
        'fct' : item.fct,
        'idno' : item.idno,
        'name' : item.name,
        'mdno' : item.mdno,
        'unit' : item.unit,
        'pos' : item.pos,
        'supplier' : item.supplier,
        'state' : item.state,
        'pos_no' : item.pos_no,
        'search' : item.search 
      });
    });
    $table.bootstrapTable('load', data);
  })
}

