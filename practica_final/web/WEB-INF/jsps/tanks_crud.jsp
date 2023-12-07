
<!DOCTYPE html>
<html>
    <head>
        <title>CRUD</title>
        <meta charset="UTF-8">
        <script src="https://cdn.tailwindcss.com"></script>
        <!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
        <link rel="stylesheet" type="text/css" href="css/main_menu.css"/>
    </head>

    <body class="bg-zinc-950">
       	<div class="flex flex-col">
            <div class="flex flex-row gap-x-32">
                <%@include file="nav_bar.jsp" %>


                <div class="mt-10 text-start col-span-2">
                    <p class="text-4xl text-red-50">Nuevo tanque</p>
                    <div class="pt-20"></div>
                    <div>
                        <form id="add_form" class="grid grid-cols-6 text-red-50">
                            <div class="col-span-2 grid grid-rows-4 gap-y-5 max-w-min justify-items-start">
                                <label>Nombre </label>
                                <label>Daño </label>
                                <label>HP </label>
                                <label>  </label>
                            </div>

                            <div class="grid col-span-4 grid-rows-4 gap-y-5 justify-items-start">
                                <input required id="tank_name" class="text-black pl-2" type="text" placeholder="Nombre"/>
                                <input required id="tank_dmg" class="text-black pl-2" type="text" placeholder="Daño"/>
                                <input required  id="tank_hp" class="text-black pl-2" type="text" placeholder="HP"/>
                                <!-- <label>Aceptar </label> -->
                                <input id="add_submit" class="justify-self-center border rounded-full px-4 text-lime-400" type="submit" value="Insertar"/>
                            </div>


                        </form>
                    </div>
                </div>
                <div class="flex col-span-4 justify-center text-start">
                    <section class="mt-10 text-red-50 text-center">
                        <p class="max-h-fit text-4xl text-red-50">Listado de tanques</p>
                        <div class="pt-20"></div>
                        <!--
                        <table class="table-fixed">
                            <thead>
                                <tr>
                                    <th class="min-w-[1.5rem]">    </th>
                                    <th class="min-w-[2.0rem]">    </th>
                                    <th class="border w-14">ID</th>
                                    <th class="border w-52">NOMBRE</th>
                                    <th class="border w-24">DAÑO</th>
                                    <th class="border w-24">VIDA</th>
                                </tr>
                            </thead>
                        </table>
                        -->
                        <div id="table_div">
                            <%@include file="tank_table.jsp" %>
                        </div>
                        <div class="pt-10">
                            <button id="previous_page" class="justify-self-center border rounded-full mx-14 px-4 text-lime-400 ">Anterior</button>
                            <span id="page_text"> 
                            </span>
                            <button id="next_page" class="justify-self-center border rounded-full mx-14 px-4 text-lime-400 ">Siguiente</button>

                        </div>
                    </section>

                </div>
                <div class="pl-24 col-span-2 mt-10 text-center">
                    <p class="text-4xl text-red-50">Modificar Tanque</p>
                    <div class="pt-20"></div>
                    <form id="update_form" class="grid grid-cols-6 text-red-50">
                        <div class="col-span-2 grid grid-rows-5 gap-y-5 max-w-min justify-items-start">
                            <label>ID</label>
                            <label>Nombre</label>
                            <label>Daño</label>
                            <label>HP</label>
                            <label>  </label>
                        </div>
                        <div class="grid col-span-4 grid-rows-5 gap-y-5 justify-items-start">
                            <input required id="update_tank_id" class="text-black min-w-full pl-2" pattern="[0-9]+" type="text" placeholder="ID">
                            <input required id="new_tank_name" class="text-black min-w-full pl-2"  type="text" placeholder="Nombre">
                            <input required id="new_tank_dmg" class="text-black min-w-full pl-2" type="text" placeholder="Daño">
                            <input required id="new_tank_hp" class="text-black min-w-full pl-2" type="text" placeholder="HP">
                            <input id="update_submit" class="justify-self-center border rounded-full px-4 text-amber-400" type="submit" value="Update"/>
                        </div>

                    </form>
                </div>
            </div>
            <!-- </div> -->
            <%@include file="footer.jsp" %>
        </div>
        <script src="/js/tanks_crud.js"></script>
    </body>
</html>


