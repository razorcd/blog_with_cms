$(function(){
  //$("#users_captcha_key").attr('id','captcha_key')
  $('.simple_captcha_refresh_button').on('click', function(e){
    e.preventDefault();
    $.get(e.target.href, function(data){
      //exec(data);
      console.log(data);
    })
  })

})