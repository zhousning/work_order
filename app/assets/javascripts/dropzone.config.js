Dropzone.options.myAwesomeDropzone = {
  paramName: "file",
  acceptedFiles: ".png,.jpg,.jpeg,application/pdf,.txt,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.mp4", 
  //addRemoveLinks: true,
  maxFiles: 10,
  maxFilesize: 5, // MB
  dictInvalidInputType: '文件类型不支持',
  dictFileTooBig: '文件不能超过5M',
  dictMaxFilesExceeded: '最多一次上传10个文件,刷新页面继续上传',
  init: function() {  
    this.on("totaluploadprogress", function(prg, total_bit, bit) {  
      if (prg == 100 ) {
        /*
        setTimeout(function(){ 
          window.location = "/portfolios/" + gon.portfolio + "/file_libs";
        }, 3000);
        */
      }
    });  
    /*this.on("complete", function(file, data) {  
      console.log("File " + file.name + "uploaded");  
      console.log("File " + data + "uploaded");  
    });  
    this.on("removedfile", function(file) {  
      console.log("File " + file.name + "removed");  
    });*/  
  } 
  /*accept: function(file, done) {
    //alert("nnnn");
    if (file.name == "justinbieber.jpg") {
      done("Naha, you don't.");
    }
    else { 
      done(); 
    }
  }*/
};
