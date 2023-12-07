const especial_simbols = "!\"·$%#&/()=?¿^*¨Ç:;,.-´ç+`¡'º[]{}@|";
const numbers = "1234567890";


document.getElementById("login_button").addEventListener("click", function () {
    document.getElementById("signup_form").classList.add("hidden");
    document.getElementById("login_form").classList.remove("hidden");
});

document.getElementById("signup_button").addEventListener("click", function () {
    document.getElementById("login_form").classList.add("hidden");
    document.getElementById("signup_form").classList.remove("hidden");
 });



document.getElementById("send_login_button").addEventListener("click", function () {
    event.preventDefault();
    var xhr = new XMLHttpRequest();


    var user_name = document.getElementById("login_username").value;
    var pass = document.getElementById("login_password").value;
    var queryString = "username=" + encodeURIComponent(user_name)
            + "&password=" + encodeURIComponent(pass);

    xhr.open("POST", "/SPR/users/login", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xhr.onload = function () {
        console.log(xhr.status);
        if (xhr.status >= 200 && xhr.status < 300) {
            alert("Sesion iniciada con exito!")
            window.location.href = "/SPR/home";
        } else {
            // La solicitud falló
            alert("Hubo un fallo al procesar la solicitud");
        }
    };

    xhr.send(queryString);

});

document.getElementById("send_signup_button").addEventListener("click", function () {
    event.preventDefault();
    var xhr = new XMLHttpRequest();


    var user_name = document.getElementById("signup_username").value;
    var pass = document.getElementById("signup_password").value;
    var email = document.getElementById("signup_email").value;
    var queryString = "signup_username=" + encodeURIComponent(user_name)
            + "&signup_password=" + encodeURIComponent(pass)
            + "&signup_email=" + encodeURIComponent(email);

    xhr.open("POST", "/SPR/users/add", true);
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

    xhr.onload = function () {
        console.log(xhr.status);
        if (xhr.status >= 200 && xhr.status < 300) {
            //window.location.href = "crud";
            alert("Registrado con exito!");
        } else {
            // La solicitud falló
            alert("Hubo un fallo al procesar la solicitud");
        }
    };

    xhr.send(queryString);
});


let pass = document.getElementById("signup_password");
let pass_span = document.getElementById("spanClave");
pass.onchange = function () {
    const password = pass.value;

    let esp_chars = Array.from(password).filter(e => especial_simbols.includes(e, 0));
    let numbers_chars = Array.from(password).filter(e => numbers.includes(e, 0));
    pass_span.classList.add("text-red-500");
    pass_span.classList.remove("text-green-500");
    if (password.length < 10) {
        pass_span.innerText = "Al menos 10 caracteres";
    } else if (esp_chars.length < 1) {
        pass_span.innerText = "Al menos un caracter especial";
    } else if (numbers_chars.length < 1) {
        pass_span.innerText = "Al menos un numero";
    } else {
        pass_span.classList.remove("text-red-500");
        pass_span.classList.add("text-green-500");
        pass_span.innerText = "Contraseña segura!";
    }
};
