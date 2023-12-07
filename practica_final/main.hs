{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wunused-imports #-}


import System.IO
import Server



home_page:: RequestHandler
home_page req = do
    let a = handler req
    putStrLn $ "Manejando peticion a " ++ path req
    case path req of
        "/home" -> set_dynamic_view a "/WEB-INF/jsps/home/home.jsp"
        _ -> hPutStrLn a "[ERROR] pagina no enrutada"
    hPutStrLn a ""

r :: [(String, RequestHandler)]
r = [("/", home_page)]


main :: IO ()
main = do
    let sc = ServerConfig{port="8080", routes = r}
    run_server sc