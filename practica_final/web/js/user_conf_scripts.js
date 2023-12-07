document.getElementById("close_session_button").addEventListener("click", function () {
    event.preventDefault();
    
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "close_session", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        console.log(xhr.status);
        if (xhr.status >= 200 && xhr.status < 300) {
            alert("Sesion cerrada con exito!")
            window.location.href = "/SPR/home";
        } else {
            // La solicitud falló
            alert("Hubo un fallo al cerrar la sesion");
        }
    };

    xhr.send();

});

