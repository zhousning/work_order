$(".nlps.index").ready(function() {
  $("#nlp-analyze").click(function() {
    var texts = $.trim($("#nlp-post").val());
    texts = texts.replace(/[\s"]/g, "");
    $.post("/nlps/analyze", { text: texts}, function(data){
      var items = data.word_count;
      var result = "";
      for (var i=0; i<items.length; i++) {
        result += "<tr><td>" + items[i][0] +"</td><td>" + items[i][1] + "</td></tr>"; 
      }
      $(".nlp-word-frequency").html(result);
    });
  });
  $("#nlp-poem").click(function() {
    var texts = $.trim($("#nlp-post").val());
    texts = texts.replace(/[\s"]/g, "");
    $.get("/nlps/poem", { text: texts}, function(data){
      var items = data.word_count;
      var result = items['poem'][0]['content'];
      $(".poem-container").html(result);
    });
  });

  $("form#new_ocr").submit(function(res) {
    $.cookie("ocrdownload", "process");
    var tha = res;
    $(".btn-ocr-submit").attr("disabled",true);
    $(".ocr-progress").css("display","flex");
    checkCookie();
  });
})

function checkCookie() {
  var cookieVal = $.cookie("ocrdownload");
  if (cookieVal == "process") {
    setTimeout("checkCookie();", 1000);
  } else {
    window.location = "/ocrs";
  }
}
