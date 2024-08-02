jQuery(document).on('turbolinks:load',function(){
    $(".js-modalWindow").click(function(){
        $("body").append("<div class='overlay'></div>");
        $(".overlay").fadeIn(300);
        var target = $(".card-img-top").attr("src");
        var largeImage = "<img class='modalContent' src='" + target + "' >";
        $(".overlay").append(largeImage);
        $("body").addClass("is-active");
        return false;
    });

    $("body").on("click",".overlay", function(){
        $(this).fadeOut(300, function(){
            $(this).remove();
            $("body").removeClass("is-active");
        });
    });
});