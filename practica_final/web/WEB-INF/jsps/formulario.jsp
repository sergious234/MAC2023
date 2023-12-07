<%-- 
    Document   : formulario
    Created on : 14 nov 2023, 17:48:00
    Author     : usuario
--%>

<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page language="java" import="java.util.List,java.lang.*" %> 
<!DOCTYPE html>
<html>
    <head>
        <title>SR</title>
        <meta charset="UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="/SPR/css/main_menu.css"/>
    </head>
    <body class="bg-zinc-950">
       	<div class="flex flex-col">
            <div class="flex flex-row">                
                <%@include file="nav_bar.jsp" %>
                <div class="flex flex-1 justify-center">
                    <div>
                        <section class="pt-10 text-white">
                            <p class="text-center text-5xl">Spanish Ranking</p>
                            <div class="flex flex-row justify-center">
                                <button id="signup_button" class="px-4 text-center pt-2 max-w-full">Registrate</button>
                                <button id="login_button" class="px-4 text-center pt-2 max-w-full">Inicia Sesion</button>
                            </div>
                        </section>

                        <form id="login_form" class="hidden text-white text-lg pt-10 text-center justify-center flex flex-col">

                            <div class="pt-6">
                                <p id="msgName">Nombre*</p>
                                <input required class="rounded-md pl-2 text-black" id="login_username" type="text" name="user_name" />
                            </div>

                            <div class="pt-6">
                                <p id="msgClave">Contraseña*</p>
                                <input required class="rounded-md pl-2 text-black" id="login_password" type="password" name="password" />
                            </div>

                            <div class="pt-10 flex justify-center">
                                <input id="send_login_button" type="submit" class="px-3 rounded-md bg-white text-black text-center" value="Iniciar sesion">
                            </div>
                            
                        </form>

                        <form id="signup_form" class="text-white text-lg pt-10 text-center justify-center flex flex-col">
                            <div class="pt-6">
                                <p id="msgName">Nombre*</p>
                                <input required class="rounded-md pl-2 text-black" id="signup_username" type="text" name="user_name" />
                            </div>

                            <div class="pt-6">
                                <p id="msgClave">Correo*</p>
                                <input required class="border-2 rounded-md pl-2
                                       text-black valid:border-green-500
                                       invalid:border-red-500" 
                                       id="signup_email"
                                       type="email"
                                       name="email" 
                                       />

                            </div>

                            <div class="pt-6">
                                <p id="msgClave">Contraseña*</p>
                                <input required class="rounded-md pl-2 text-black" id="signup_password" type="password" name="password" />
                            </div>
                            
                            <p class="font-semibold" id="spanClave"></p>

                            <div class="pt-10 flex justify-center">
                                <input id="send_signup_button" type="submit" class="px-3 rounded-md bg-white text-black text-center" value="Aceptar">
                            </div>
                        </form>
                    </div>


                </div>
            </div>
            <%@include file="footer.jsp" %>
        </div>

        <script src="/SPR/js/formulario.js"></script>
    </body> 
</html>
