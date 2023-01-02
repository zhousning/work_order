function form_parse_submit() {
  $(".btn-parse-submit").attr("disabled",true);
  $(".ctn-progress").css("display","flex");
}

 
function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $(input).siblings('.blah').attr('src', e.target.result);
    };

    reader.readAsDataURL(input.files[0]);
  }
}

function readFileName(input) {
  $(input).siblings('.append-url').html($(input).val());
}
function loadDataToBstpTable(table, url, request_params) {
  var $table = $(table)
  $.get(url, request_params).done(function (data) {
    $table.bootstrapTable('load', data);
  })
}
