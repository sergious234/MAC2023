{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# OPTIONS_GHC -Wunused-imports #-}
{-# OPTIONS_GHC -Wall #-}
{-# HLINT ignore "Use if" #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}



--  ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
--  ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
--  ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
--  ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
--  ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
--  ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝




-- Bueno, aqui declaramos el modulo y exportamos lo basico,
-- tipos y funciones que vamos a necesitar.
-- Como recomendacion mira primero el "run_server" y desde ahi vas
-- "down the rabbit hole" (referencia a Alicia en el pais de las maravillas)
--
--
--  https://en.wikipedia.org/wiki/Down_the_rabbit_hole
--      "Down the rabbit hole" is an English-language idiom or trope which refers to getting 
--      deep into something, or ending up somewhere strange. Lewis Carroll introduced the phrase 
--      as the title for chapter one of his 1865 novel Alice's Adventures in Wonderland, after which 
--      the term slowly entered the English vernacular.
module Server(
    run_server,
    set_dynamic_view,
    Request(..),
    ServerConfig(..),
    RequestHandler,
    Route,
    Routes
)  where


import Network.Socket
import System.IO
    ( hClose, hGetLine, hPutStrLn, Handle, IOMode(ReadWriteMode) )
import Control.Monad (forever)
import Control.Exception (try, SomeException)
import Control.Concurrent
import System.Directory
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as BS
import Rutas (get_posible_routes)
import Hsp (process_file)
import System.FilePath (takeExtension)

type RequestHandler = (Request -> IO ())
type Route = (String, RequestHandler)
type Routes = [Route]
type ServerString = BS.ByteString

data Request = Request {path :: String, handler :: Handle, vista :: String}

data ServerConfig = ServerConfig {port::String, routes::Routes}


-- Esta variable indica cual es el directorio raiz para buscar los elementos
-- dinamicos de nuestro servidor de aplicaciones, en este caso es el mismo que usa
-- el servidor de aplicaciones java GlassFish
base :: String
base = "./web";


-- Dadas unas rutas busca la que coincida con path, una busqueda
-- tipica recursiva sin mucho misterio.
get_handler:: Routes -> String -> Maybe (Request -> IO())
get_handler [] _ = Nothing
get_handler (h:rest) path =
    if fst h == path then
        Just $ snd h
    else
        get_handler rest path


-- TODO: Reemplazar cadena vacia por ERROR
-- A partir de un FilePath intentamos leer el fichero,
-- En caso positivo devolvemos en contenido, en caso
-- negativo devolvemos una cadena vacia
routing:: FilePath -> IO ServerString
routing file_path = do
    putStrLn $ "[INFO] Intentando leer: " ++ file_path
    res <- try $ BS.readFile file_path
    let v = TE.encodeUtf8 $ T.pack " "
    case res of
        Left (_ :: SomeException) -> return v
        Right contents -> return contents


-- Enroutamiento dinamico.
-- En caso de que el fichero no haya sido definido en la tabla 
-- de rutas buscarlo en el fichero root (./web) y mandarlo al handler
--
-- En caso de que no exista el fichero mandar
dynamic_file:: Request -> IO()
dynamic_file req = do
    let hdl = handler req
    let file_path = base ++ path req
    x <- doesFileExist file_path
    (if x then (do
        content <- routing file_path
        BS.hPut hdl content) else (do
        hPutStrLn hdl "[ERROR] Unknow dynamic file error"))

--
-- IMPORTANTE, ESTO NO TIENE QUE VER CON DYNAMIC_FILE !!!
--
-- Muy fácil: recivimos un Handler, un FilePath
--      Y le decimos:
--          Si existe el FilePath preparalo y envialo
--          Si NO existe manda este mensaje de error
set_dynamic_view:: Handle -> FilePath -> IO()
set_dynamic_view hdl fp = do
    let file_path = base++fp
    file_p <- doesFileExist file_path
    if file_p then (do
        processed_content <- process_file file_path
        BS.hPut hdl processed_content) 
    else putStrLn $ "[ERROR] Error en el servidor de aplicaciones, archivo: " ++ base++fp ++ " no encontrado!"


-- IMPORTANTE HABER VISTO PRIMERO EL MANAGE_HDL
--
-- El nombre de la función lo dice todo
-- nos dan las rutas definidas por el usuario (routs)
-- y las posibles rutas de la peticion ( ["/", "/home", "/home/usuarios"] )
--                                          El mismo ejemplo de antes
--
-- Buscaremos si existe un RequestHander para "/", sino existe buscamos para "/home", para "/home/usuarios"
-- Si lo encontramos devolvemos para cual lo hemos encontrado y su handler (para cual lo hemos encontrado me es util
-- para hacer trazas y debug)
--
-- Si no se encuentra pues Nothing (Si es nothing en el manage_hld se le asignara dynamic_file)
search_route:: Routes -> [String] -> Maybe (String, RequestHandler)
search_route _ [] = Nothing
search_route routs (h:t) =
    case get_handler routs h of
        Nothing -> search_route routs t
        Just v -> Just (h,v)


-- Aqui esta la chicha. 
-- manage_hdl es el encargado de leer la petición entrante y, dependiendo
-- de lo que el usuario (Firefox) en mi caso haya solicitado (por ejemplo /home)
-- obtener la "request_manager" correspondiente O buscar el archivo dinamico que 
-- haya solicitado, por ejemplo "js/formulario.js"

{-


                    ███████╗███████╗ ██████╗ ██╗   ██╗███████╗███╗   ███╗ █████╗ 
                    ██╔════╝██╔════╝██╔═══██╗██║   ██║██╔════╝████╗ ████║██╔══██╗
                    █████╗  ███████╗██║   ██║██║   ██║█████╗  ██╔████╔██║███████║
                    ██╔══╝  ╚════██║██║▄▄ ██║██║   ██║██╔══╝  ██║╚██╔╝██║██╔══██║
                    ███████╗███████║╚██████╔╝╚██████╔╝███████╗██║ ╚═╝ ██║██║  ██║
                    ╚══════╝╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝


                                                                                      +----------------------+
                                                                                      |   Buscar con la fn   |
                                                                  +-------------------+   dynamic_view el    |
                                                                  |                   |  fichero solicitado  |
                                                                  |                   +----------------------+
                                                                  |                             ^
                                                                  |                             |
                                                                  V                             NO
        +-------------------+                            +-------------------+                  |
        |                   | -------------------------> |                   |           +---------------+
        |  Firefox          |                            |  Haskell          |           | Está definida |      
        |  Client           |                            |  Server           | --------> |   la ruta     | 
        |                   | <------------------------- |  Application      |           |  solicitada ? |   
        |                   |                            |                   |           +---------------+
        +-------------------+                            +-------------------+                  |
                                                                  ^                             Si
                                                                  |                             |
                                                                  |                             V
                                                                  |                     +----------------------+  
                                                                  |                     | Ejecutar el handler  |              
                                                                  +---------------------+   asignado en el     |           
                                                                                        |      main.hs         |       
                                                                                        +----------------------+  
-} 

manage_hdl:: Routes -> Handle -> Socket -> IO ()
manage_hdl routes hdl clientSock = do
    x <- hGetLine hdl


    -- Estas dos lineas son importantes ya que del la peticion
    -- Ejemplo: GET /home/usuarios HTTP/1.1
    -- Obtendrá las diferentes posibles rutas:
    --
    --              INPUT                                    OUTPUT (paths)
    --      GET /home/usuarios HTTP/1.1   ---->   ["/", "/home", "/home/usuarios"]
    let no_root = tail $ get_posible_routes $ takeWhile (/=' ') $ dropWhile (/='/') x
    let paths = "/":no_root

    putStrLn $ "[INFO] Possible pathds : " ++ show paths

    let ruta_solicitada = base++last paths

    exists <- doesFileExist ruta_solicitada
    if exists  then
        putStrLn $ "[INFO] Se solicita el fichero: " ++ ruta_solicitada
    else
        putStrLn $ "[INFO] Se solicita una ruta: " ++ ruta_solicitada


    -- Aqui buscamos el request_handler en caso de que esté definido, en caso contrario devolvemos 
    -- uno dinamico que intentara buscar la archivo solicitado por el usuario
    let (_path, req_hdl) = (if exists then ("", dynamic_file) else (case search_route routes paths of
            Just (p, h) -> (p,h)
            Nothing -> ("", dynamic_file)))


    -- Creamos una estructura request para pasarsela al req_hdl
    let request = Request {path = last paths, handler = hdl, vista = "/"}


    -- Cabecera HTTP de "toa la vida de Dioh" indicando 200 OK añadiendo la cabecera
    -- Content-Type dependiendo de lo que nos hayan solicitado
    hPutStrLn hdl "HTTP/1.1 200 OK"
    case takeExtension ruta_solicitada of
        ".svg" -> hPutStrLn hdl "Content-Type: image/svg+xml"
        ".jpg" -> hPutStrLn hdl "Content-Type: image/jpg"
        ".jpeg" -> hPutStrLn hdl "Content-Type: image/jpeg"
        ".png" -> hPutStrLn hdl "Content-Type: image/png"
        ".css" -> hPutStrLn hdl "Content-Type: text/css"
        _ -> hPutStrLn hdl "Content-Type: text/html; charset=utf-8"


    -- Lenguaje español y saltito de linea
    hPutStrLn hdl "Content-Language: es"
    hPutStrLn hdl ""

    -- Le pasamos la request al handler para que se ejecute el codigo definido por
    -- el usuario en el main.hs
    req_hdl request

    -- Cerrar handler y socket para liberar recursos
    hClose hdl
    close clientSock
    putStrLn $ "[INFO] Closing conection with: " ++ show clientSock ++ "\n\n"


-- Este es el SERVER MAIN LOOP, donde se aceptaran las conexiones
-- entrantes y se las "despachará" con las rutas definidas en main.hs
main_server:: Routes -> Socket -> IO()
main_server routes sock = do

    -- Acepta una conexión entrante
    (clientSock, clientAddr) <- accept sock
    putStrLn $ "[INFO] Conexión aceptada desde " ++ show clientAddr

    -- Obtiene un identificador de archivo (file descriptor) para el socket cliente
    hdl <- socketToHandle clientSock ReadWriteMode
    manage_hdl routes hdl clientSock


-- "Mucho" de este código es de ChatGPT y StackOverdlow
-- donde he investigado para abrir un socket TCP y conectarlo
-- a un puerto. 
--
-- La idea de ServerConfig y ponerlo en otro hilo "forever" para poder
-- detenerlo desde fuera son mias.
run_server:: ServerConfig -> IO()
run_server config = do
    -- Crea un socket
    sock <- socket AF_INET Stream 0  -- AF_INET para IPv4, Stream para TCP
    setSocketOption sock ReuseAddr 1 -- Esto para que no de problemas al reiniciar

    let p = port config
    let r = routes config
    -- Configura la dirección y el puerto al que el socket se va a unir
    let addrInfo = defaultHints { addrFlags = [AI_PASSIVE], addrSocketType = Stream }
    addr:_ <- getAddrInfo (Just addrInfo) Nothing (Just p)  

    -- Enlaza el socket a la dirección
    Network.Socket.bind sock (addrAddress addr)

    -- Escucha por conexiones entrantes
    listen sock 5  -- Máximo de 5 conexiones en la cola

    putStrLn "Esperando conexiones..."

     -- Inicia un hilo que ejecuta la acción "miBucle"
    threadId <- forkIO $ forever $ main_server r sock

    -- Espera hasta que se ingrese algo por la consola
    _ <- getLine

    -- Manda una señal para matar el hilo
    killThread threadId
    putStrLn "Hilo terminado."

    -- Esperar 1s (Recive microsegundos)
    threadDelay 1000000
    close sock
    putStrLn "Bye bye.jsps"