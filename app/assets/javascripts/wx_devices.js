$(".wx_devices").ready(function() {
  if ($(".wx_devices.index").length > 0) {
    getWxDeviceItems('wx_devices');
  }
});

function getWxDeviceItems(method) {
  var $table = $('#item-table')
  var url = "/" + method + "/query_all";
  $.get(url).done(function (objs) {
    var data = [];
    $.each(objs, function(index, item) {
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
        'pos_no' : item.pos_no
      });
    });
    $table.bootstrapTable('load', data);
  })
}

