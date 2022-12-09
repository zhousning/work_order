$(".documents.show").ready(function() {
  if ($(".documents.show").length > 0) {
    if (gon.documentStatus != 101) {
      var timesRun = 0;
      var timerId = setInterval(function() {
        $.get(
          "http://"+window.location.host+"/websites/"+gon.websiteId+"/documents/"+gon.documentId+"/check", null,
          function(data, textStatus) {
            if (data.status == 101) {
              //var download = "/websites/"+gon.websiteId+"/documents/"+gon.documentId+"/download?ft="
              //$("#document_status .repalce_content").html("生成网站成功，请点击下载网站，不支持迅雷下载");
              //$("#document_link .repalce_content").html("<a href='"+download+"html"+"' class='btn btn-sm btn-warning'>预览网页</a>" + "\n" + "<a href='"+download+"html"+"' class='btn btn-sm btn-success download-modal' data-file='html'>下载网站</a>");
              var url = "/websites/"+gon.websiteId+"/documents/"+gon.documentId
              location.href = url;
              clearInterval(timerId);
            }
            else if (data.status % 10 >= 2 && data.status % 10 <= 9) {
              $("#document_status .repalce_content").html("生成网站失败，请重试或与客服联系");
              clearInterval(timerId);
            }
            else {
              // do nothing
            }
        });
        timesRun += 1;
        if (timesRun === 18) {
          $("#document_status .repalce_content").html("生成网站超时，请重试或与客服联系");
          clearInterval(timerId);
        }
      }, 10000);
    }
  }

});
