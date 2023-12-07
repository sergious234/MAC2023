<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" type="text/css" href="css/main_menu.css"/>
    </head>
    <body class="bg-zinc-950">
       	<div class="flex flex-col">
            <div class="flex flex-row gap-x-32">
                <%@include file="../nav_bar.jsp" %>
                <div class="flex">
                    <div class="grid min-h-screen grid-rows-2">
                        <div>
                            <section class="pt-10 text-white">
                                <p class="text-5xl">Spanish Ranking</p>
                                <p class="pt-2 max-w-sm">
                                    La mejor aplicación para el seguimiento de clanes
                                    españoles durante la temporada de clan wars.
                                </p>
                            </section>
                        </div>

                        <div>
                        </div>

                    </div>
                </div>
            </div>
            <%@include file="../footer.jsp" %>
        </div>
    </body>

</html>