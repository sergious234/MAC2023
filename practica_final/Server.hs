{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# LANGUAGE PatternSynonyms #-}

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

type RequestHandler = (Request -> IO ())
type Route = (String, RequestHandler)
type Routes = [Route]

data Request = Request {path :: String, handler :: Handle, vista :: String}

base = "./web";

get_file_name:: FilePath -> IO (Maybe String)
get_file_name path = do
    existe <- doesFileExist $ base ++ path
    putStrLn $ "Existe: " ++ base ++ path ++ " ?"
    (if existe then return $ Just $ base ++ path else return Nothing)

get_handler:: Routes -> String -> Maybe (Request -> IO())
get_handler [] _ = Nothing
get_handler (h:rest) path =
    if fst h == path then
        Just $ snd h
    else
        get_handler rest path

routing:: String -> IO String
routing html_file = do
    res <- try $ readFile html_file
    case res of
        Left (ex :: SomeException) -> return " "
        Right contents -> return contents

dynamic_file:: Request -> IO()
dynamic_file req = do
    let hdl = handler req
    file_path <- get_file_name $ path req
    putStrLn $ base++ path req
    case file_path of
        Just path -> do
            content <- routing path
            hPutStrLn hdl content
        Nothing -> do
            hPutStrLn hdl "Error"

set_dynamic_view:: Handle -> FilePath -> IO()
set_dynamic_view hdl fp = do

    file_p <- get_file_name $ base++fp
    case file_p of
        Just f -> do
            content <- routing f
            hPutStrLn hdl content
        Nothing -> putStrLn $ "Error en el servidor de aplicaciones, archivo: " ++ base++fp ++ " no encontrado!"


-- tail $ scanl(\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') "GET /home/usuario"
manage_hdl:: Routes -> Handle -> Socket -> IO ()
manage_hdl routes hdl clientSock = do
    -- Envía "Hola mundo" al socket cliente
    x <- hGetLine hdl

    let l = zipWith (\n linea -> show n ++ ": " ++ linea) [1..] (lines x)
    mapM_ putStrLn l


    let path = tail $ scanl(\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') x
--takeWhile (/=' ') $ dropWhile (/='/') x
    putStrLn $ "Peticion: " ++ show path
    let request_handler = fromMaybe dynamic_file $ get_handler routes $ head path

    hPutStrLn hdl "HTTP/1.0 200 OK"
    hPutStrLn hdl "Content-Type: text/html"
    hPutStrLn hdl ""

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
    putStrLn $ "Closing conection with: " ++ show clientSock


main_server:: Routes -> Socket -> IO()
main_server routes sock = do

    -- Acepta una conexión entrante
    (clientSock, clientAddr) <- accept sock
    putStrLn $ "Conexión aceptada desde " ++ show clientAddr

    -- Obtiene un identificador de archivo (file descriptor) para el socket cliente
    hdl <- socketToHandle clientSock ReadWriteMode
    manage_hdl routes hdl clientSock


