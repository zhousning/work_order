$(".notices.index, .wares.index").ready(function() {
  if ($(".notices.index").length > 0 || $(".wares.index").length > 0) {
    var activeSystemClass = $('.list-group-item.active');

    //something is entered in search form
    $('#system-search').keyup( function() {
       var that = this;
        // affect all table rows on in systems table
        var tableBody = $('.table-list-search tbody');
        var tableRowsClass = $('.table-list-search tbody tr');
        $('.search-sf').remove();
        tableRowsClass.each( function(i, val) {
        
            //Lower text for case insensitive
            var rowText = $(val).text().toLowerCase();
            var inputText = $(that).val().toLowerCase();
            if(inputText != '')
            {
                $('.search-query-sf').remove();
                tableBody.prepend('<tr class="search-query-sf"><td colspan="6"><strong>查找: "'
                    + $(that).val()
                    + '"</strong></td></tr>');
            }
            else
            {
                $('.search-query-sf').remove();
            }

            if( rowText.indexOf( inputText ) == -1 )
            {
                //hide rows
                tableRowsClass.eq(i).hide();
                
            }
            else
            {
                $('.search-sf').remove();
                tableRowsClass.eq(i).show();
            }
        });
        //all tr elements are hidden
        if(tableRowsClass.children(':visible').length == 0)
        {
            tableBody.append('<tr class="search-sf"><td class="text-muted" colspan="6">没有找到</td></tr>');
        }
    });
  }
});

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
