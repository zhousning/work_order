$(".grp_inspectors").ready(function() {
  if ($(".grp_inspectors.index").length > 0) {
    get_grp_inspectors('grp_inspectors', 'query_unuse')
    grp_inspector_bind_event('query_unuse')
  }
});


function grp_inspector_bind_event(link) {
  $("#grp-jnzsbz").on('click', 'button.inspector-delete-btn', function(e) {
    var that = e.target
    var data_id = that.dataset['id'];
    var url = "/grp_inspectors/" + data_id + "/delete_inspector";
    var flag = confirm('确定删除吗?')
    if (flag) {
      $.get(url).done(function (data) {
        if (data.state == 'success') {
          get_grp_inspectors('grp_inspectors', link)
        }
      });
    }
  });
}

function get_grp_inspectors(method, link) {
  var $table = $('#grp-jnzsbz');
  var data = [];
  var url = "/" + method + "/" + link;
  $.get(url).done(function (objs) {
    $.each(objs, function(index, item) {
      data.push({
        'index' : index + 1,
         
        'name' : item.name,
         
        'phone' : item.phone,
         
        'nickname' : item.nickname,
         
        'sites' : item.sites,

        'button' : item.button
      });
    });
    $table.bootstrapTable('load', data);
  })
}

