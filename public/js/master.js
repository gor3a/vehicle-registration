// let changeEyeSlash = document.getElementById(ggz);
// changeEyeSlash.onclick 

function openNav() {
    document.getElementById("mySidenav").style.width = "250px";
}

function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}

$(document).ready(function () {
    $('.js-example-basic-single').select2({width: '100%'});
});


$(document).ready(function () {
    $("#successMessage,#errorMessage").delay(2000).slideUp(300);
});
