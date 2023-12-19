{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wunused-imports #-}




--  ███╗   ███╗ █████╗  █████╗  █████╗  █████╗  █████╗  █████╗  █████╗  █████╗ ██╗███╗   ██╗
--  ████╗ ████║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║
--  ██╔████╔██║███████║███████║███████║███████║███████║███████║███████║███████║██║██╔██╗ ██║
--  ██║╚██╔╝██║██╔══██║██╔══██║██╔══██║██╔══██║██╔══██║██╔══██║██╔══██║██╔══██║██║██║╚██╗██║
--  ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██║██║  ██║██║  ██║██║  ██║██║  ██║██║  ██║██║██║ ╚████║
--  ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝


-- IMPORTANTE
-- Orden para mirar los archivos:
--  1º main.hs
--  2º Server.hs
--  3º Hsp.hs 
--  4º Rutas.hs
--
--
-- Hay un "porron" de imports
--
-- Para ejecutar se necesita la libreria de network
--      La he instalado con cabal:
--          "cabal install network"
--



import System.IO
import Server


-- Esta funcion se encarga de manejar requests que le lleguen al servidor
home_page:: RequestHandler
home_page req = do
    let a = handler req
    putStrLn $ "Manejando peticion a " ++ path req
    case path req of
        "/home" -> set_dynamic_view a "/WEB-INF/jsps/home/home.jsp"
        "/tank_table" -> set_dynamic_view a "/WEB-INF/jsps/tanks_crud.jsp"
        "/table" -> set_dynamic_view a "/WEB-INF/jsps/tank_table.jsp"
        _ -> hPutStrLn a "[ERROR] pagina no enrutada"
    hPutStrLn a ""


-- Aqui definimos que rutas son manejadas por que funciones.
--      En este caso todo lo que llegue a "/*" (osea / seguido de cualquier cosa)
--      va a ser manejado por la funcion home_page
rutes :: [(String, RequestHandler)]
rutes = [("/", home_page)]


-- Crear la configuracion y arrancar el servidor
-- Una vez arrancado el servidor pulsando "Enter" se para
main :: IO ()
main = do
    let sc = ServerConfig{port="8080", routes = rutes}
    run_server sc