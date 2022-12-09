$(".registrations, .passwords").ready(function() {
  $("#send-confirm-code").click(function(){
    var phone = $("#inputPhone").val();
    if(!(/^1[34578]\d{9}$/.test(phone))){ 
      alert("手机号码有误，请重填");  
      return false; 
    } 
    $(this).attr("disabled", "disabled");
    var max = 60;
    var that = this;
    var timer = setInterval(function(){
      $(that).html(max + "秒");
      if (max == 0){
        $(that).removeAttr("disabled");
        $(that).html("重新发送");
        clearInterval(timer);
      }
      max--;
    }, 1000);
    var url = "/systems/send_confirm_code?phone=" + phone ;
    $.get(url);
  });
  $("#new_user").submit(function(e){
    var confirm_code = $.trim($("#confirm_code").val());
    if (code == '') {
      e.preventDefault();
    }
  });
});

//$(".users.mobile_authc_new").ready(function() {
//  $("#authc-modal-btn").click();
//});
