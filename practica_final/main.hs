{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
import Network.Socket
import System.IO
import Control.Arrow (ArrowLoop(loop))
import Control.Monad (forever)
import Control.Exception (handle, try, IOException, SomeException)
import Control.Concurrent
import Data.Maybe (fromMaybe)
import GHC.Data.StringBuffer (hPutStringBuffer)
import Server



home_page:: RequestHandler
home_page req = do
    let a = handler req
    putStrLn $ "Manejando peticion a " ++ path req
    case path req of
        "/home" -> set_dynamic_view a "/WEB-INF/jsps/home/home.jsp"
        _ -> hPutStrLn a "[ERROR] pagina no enrutada"
    hPutStrLn a ""

routes = [("/", home_page)]


main :: IO ()
main = do
    -- Crea un socket
    sock <- socket AF_INET Stream 0  -- AF_INET para IPv4, Stream para TCP
    setSocketOption sock ReuseAddr 1 -- Esto para que no de problemas al reiniciar

    -- Configura la dirección y el puerto al que el socket se va a unir
    let addrInfo = defaultHints { addrFlags = [AI_PASSIVE], addrSocketType = Stream }
    addr:_ <- getAddrInfo (Just addrInfo) Nothing (Just "8080")  -- Puerto 8080

    -- Enlaza el socket a la dirección
    bind sock (addrAddress addr)

    -- Escucha por conexiones entrantes
    listen sock 5  -- Máximo de 5 conexiones en la cola

    putStrLn "Esperando conexiones..."

     -- Inicia un hilo que ejecuta la acción "miBucle"
    threadId <- forkIO $ forever $ do main_server routes sock

    -- Espera hasta que se ingrese algo por la consola
    _ <- getLine

    -- Manda una señal para matar el hilo
    killThread threadId
    putStrLn "Hilo terminado."

    -- Esperar 1s (Recive microsegundos)
    threadDelay 1000000
    close sock
    putStrLn "Bye bye.jsps"
