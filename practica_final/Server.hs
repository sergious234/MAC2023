{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# LANGUAGE PatternSynonyms #-}
{-# HLINT ignore "Use if" #-}

module Server(
    main_server,
    set_dynamic_view,
    Request(..),
    RequestHandler,
    Route,
    Routes
)  where


import Network.Socket
import GHC.IO.Handle (Handle)
import System.IO
import Control.Arrow (ArrowLoop(loop))
import Control.Monad (forever)
import Control.Exception (handle, try, IOException, SomeException)
import Control.Concurrent
import Data.Maybe (fromMaybe)
import GHC.Data.StringBuffer (hPutStringBuffer)
import Network.Socket.Address hiding (accept)
import System.Directory
import qualified Data.Text.IO as TIO
import qualified Data.Text as T
import qualified Data.Sequence as TIO.Text
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as BS
import Network.Socket.ByteString (sendAll)

type RequestHandler = (Request -> IO ())
type Route = (String, RequestHandler)
type Routes = [Route]
type ServerString = BS.ByteString

data Request = Request {path :: String, handler :: Handle, vista :: String}

base = "./web";

get_handler:: Routes -> String -> Maybe (Request -> IO())
get_handler [] _ = Nothing
get_handler (h:rest) path =
    if fst h == path then
        Just $ snd h
    else
        get_handler rest path

routing:: String -> IO ServerString
routing html_file = do
    res <- try $ BS.readFile html_file
    let v = TE.encodeUtf8 $ T.pack " "
    case res of
        Left (ex :: SomeException) -> return v
        Right contents -> return contents

dynamic_file:: Request -> IO()
dynamic_file req = do
    let hdl = handler req
    let file_path = base ++ path req
    x <- doesFileExist file_path
    putStrLn $ "[INFO] Buscando: " ++ file_path
    case x of
        True -> do
            content <- routing file_path
            BS.hPut hdl content
        False -> do
            hPutStrLn hdl "Error"

set_dynamic_view:: Handle -> FilePath -> IO()
set_dynamic_view hdl fp = do
    let file_path = base++fp
    file_p <- doesFileExist file_path
    putStrLn $ "[INFO] Buscando archivo: " ++ file_path
    case file_p of
        True -> do
            content <- routing file_path
            BS.putStr content
            BS.hPut hdl content

        False -> putStrLn $ "Error en el servidor de aplicaciones, archivo: " ++ base++fp ++ " no encontrado!"

search_route:: Routes -> [String] -> Maybe (String, Request -> IO())
search_route routs [] = Nothing
search_route routs (h:t) =
    case get_handler routs h of
        Nothing -> search_route routs t
        Just v -> Just (h,v)

-- tail $ scanl(\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') "GET /home/usuario"
manage_hdl:: Routes -> Handle -> Socket -> IO ()
manage_hdl routes hdl clientSock = do
    x <- hGetLine hdl

    let l = zipWith (\n linea -> show n ++ ": " ++ linea) [1..] (lines x)
    -- mapM_ putStrLn l


    let paths = tail $ scanl (\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') x

    -- putStrLn $ "Paths de la peticion: " ++ show paths

    exists <- doesFileExist (base ++ last paths)
    if exists  then
        putStrLn $ "[INFO] Se solicita el fichero: " ++ base++last paths
    else 
        putStrLn $ "[INFO] Se solicita una ruta: " ++ base++last paths
        

    let (path, req_hdl) = case exists of
            True -> ("", dynamic_file)
            False -> case search_route routes paths of
                Just (p, h) -> (p,h)
                Nothing -> ("", dynamic_file)


    let request = Request {path = last paths, handler = hdl, vista = "/"}

    hPutStrLn hdl "HTTP/1.1 200 OK"
    hPutStrLn hdl "Content-Type: text/html; charset=utf-8"
    hPutStrLn hdl "Content-Language: es"
    hPutStrLn hdl ""
    req_hdl request

    {-
    --let html_file = fromMaybe (base++cadena) (get_file_name routes cadena)
    let html_file =  "index.html"
    print $ "html_file: " ++ html_file

    response <- routing html_file
        case response of
        " " -> do
            error $ "No se ha podido encontrar el archivo: " ++ html_file
        x -> do
            hPutStrLn hdl x


    let l = zipWith (\n linea -> show n ++ ": " ++ linea) [1..] (lines x)
    mapM_ putStrLn l

    -- Cierra el socket cliente   
    -}
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


