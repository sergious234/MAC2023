{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# OPTIONS_GHC -Wunused-imports #-}
{-# OPTIONS_GHC -Wall #-}
{-# HLINT ignore "Use if" #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}

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
import System.FilePath (takeDirectory)
import System.FilePath.Posix (takeExtension)

type RequestHandler = (Request -> IO ())
type Route = (String, RequestHandler)
type Routes = [Route]
type ServerString = BS.ByteString

data Request = Request {path :: String, handler :: Handle, vista :: String}

data ServerConfig = ServerConfig {port::String, routes::Routes}

base :: String
base = "./web";

get_handler:: Routes -> String -> Maybe (Request -> IO())
get_handler [] _ = Nothing
get_handler (h:rest) path =
    if fst h == path then
        Just $ snd h
    else
        get_handler rest path

routing:: String -> IO ServerString
routing file_path = do
    putStrLn $ "[INFO] Intentando leer: " ++ file_path
    res <- try $ BS.readFile file_path
    let v = TE.encodeUtf8 $ T.pack " "
    case res of
        Left (_ :: SomeException) -> return v
        Right contents -> do
            BS.putStr contents
            return contents

dynamic_file:: Request -> IO()
dynamic_file req = do
    let hdl = handler req
    let file_path = base ++ path req
    x <- doesFileExist file_path
    --putStrLn $ "[INFO] Buscando: " ++ file_path
    (if x then (do
        content <- routing file_path
        BS.hPut hdl content) else (do
        hPutStrLn hdl "Error"))

set_dynamic_view:: Handle -> FilePath -> IO()
set_dynamic_view hdl fp = do
    let file_path = base++fp
    file_p <- doesFileExist file_path
    putStrLn $ "[INFO] Buscando archivo: " ++ file_path
    (if file_p then (do
        processed_content <- process_file (takeDirectory file_path++"/") file_path
        BS.hPut hdl processed_content) else putStrLn $ "[ERROR] Error en el servidor de aplicaciones, archivo: " ++ base++fp ++ " no encontrado!")

search_route:: Routes -> [String] -> Maybe (String, Request -> IO())
search_route _ [] = Nothing
search_route routs (h:t) =
    case get_handler routs h of
        Nothing -> search_route routs t
        Just v -> Just (h,v)

manage_hdl:: Routes -> Handle -> Socket -> IO ()
manage_hdl routes hdl clientSock = do
    x <- hGetLine hdl

    -- let l = zipWith (\n linea -> show n ++ ": " ++ linea) [1..] (lines x)

    -- let bad_paths = tail $ scanl (\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') x
    let no_root = tail $ get_posible_routes $ takeWhile (/=' ') $ dropWhile (/='/') x
    let paths = "/":no_root


    -- let cosos = obtenerSubcadenas $ takeWhile (/=' ') $ dropWhile (/='/') x -- "/" :tail (splitBy '/' $ takeWhile (/=' ') $ dropWhile (/='/') x)
    putStrLn $ "[INFO] Possible pathds : " ++ show paths

    -- putStrLn $ "Paths de la peticion: " ++ show paths

    let ruta_solicitada = base++last paths

    exists <- doesFileExist ruta_solicitada
    if exists  then
        putStrLn $ "[INFO] Se solicita el fichero: " ++ ruta_solicitada
    else
        putStrLn $ "[INFO] Se solicita una ruta: " ++ ruta_solicitada


    let (_path, req_hdl) = (if exists then ("", dynamic_file) else (case search_route routes paths of
            Just (p, h) -> (p,h)
            Nothing -> ("", dynamic_file)))


    let request = Request {path = last paths, handler = hdl, vista = "/"}

    hPutStrLn hdl "HTTP/1.1 200 OK"

    case takeExtension ruta_solicitada of
        ".svg" -> hPutStrLn hdl "Content-Type: image/svg+xml"
        ".jpg" -> hPutStrLn hdl "Content-Type: image/jpg"
        ".jpeg" -> hPutStrLn hdl "Content-Type: image/jpeg"
        ".png" -> hPutStrLn hdl "Content-Type: image/png"
        ".css" -> hPutStrLn hdl "Content-Type: text/css"
        _ -> hPutStrLn hdl "Content-Type: text/html; charset=utf-8"


    --hPutStrLn hdl "Content-Type: text/html; charset=utf-8"
    hPutStrLn hdl "Content-Language: es"
    hPutStrLn hdl ""
    req_hdl request

    hClose hdl
    close clientSock
    putStrLn $ "[INFO] Closing conection with: " ++ show clientSock

main_server:: Routes -> Socket -> IO()
main_server routes sock = do

    -- Acepta una conexión entrante
    (clientSock, clientAddr) <- accept sock
    putStrLn $ "[INFO] Conexión aceptada desde " ++ show clientAddr

    -- Obtiene un identificador de archivo (file descriptor) para el socket cliente
    hdl <- socketToHandle clientSock ReadWriteMode
    manage_hdl routes hdl clientSock

run_server:: ServerConfig -> IO()
run_server config = do
    -- Crea un socket
    sock <- socket AF_INET Stream 0  -- AF_INET para IPv4, Stream para TCP
    setSocketOption sock ReuseAddr 1 -- Esto para que no de problemas al reiniciar

    let p = port config
    let r = routes config
    -- Configura la dirección y el puerto al que el socket se va a unir
    let addrInfo = defaultHints { addrFlags = [AI_PASSIVE], addrSocketType = Stream }
    addr:_ <- getAddrInfo (Just addrInfo) Nothing (Just p)  -- Puerto 8080

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