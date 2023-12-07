{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# HLINT ignore "Use if" #-}
{-# OPTIONS_GHC -Wunused-imports #-}


module Hsp(
    process_file,
    get_fragment_path
)  where

import System.Directory
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as BS
import Control.Exception (SomeException, try)
import qualified Data.ByteString.Char8 as BS8
import Data.Maybe (fromMaybe)
import System.FilePath (takeDirectory)


type ServerString = BS.ByteString


-- Unas cuantas constantes mas harcodeadas
-- que el codigo de Fundamento de Analisis de Algoritmos
hsp_id :: BS8.ByteString
hsp_id = BS8.pack "<%@include"

hsp_prefix :: BS8.ByteString
hsp_prefix = BS8.pack "<%@include file=\""

hsp_suffix :: BS8.ByteString
hsp_suffix = BS8.pack "\" %>"


-- Ni mirar, leer archivo y devolver vacio o contenido, 
-- igual que antes
routing:: FilePath -> IO ServerString
routing html_file = do
    res <- try $ BS.readFile html_file
    let v = TE.encodeUtf8 $ T.pack " "
    case res of
        Left (_ :: SomeException) -> return v
        Right contents -> return contents

-- Busca el archivo y si existe devuelve su contenido, en caso
-- contrario devuelve un mensaje de Error
read_file:: FilePath -> IO ServerString
read_file path = do
    file_p <- doesFileExist path
    putStrLn $ "[INFO] Buscando archivo: " ++ path
    case file_p of
        True -> routing path
        False -> return $ TE.encodeUtf8 $ T.pack $ "[ERROR] Error en el servidor de aplicaciones, archivo: " ++ path ++ " no encontrado!"



read_fragment:: FilePath -> IO ServerString
read_fragment path = do
    read_file path

-- Long story short:
--
--  Suponemos que rel_path es ./web/WEB-INF/jsps/home
--
--  Esta funcion se encarga de convertir esto:
--       <%@include file="../nav_bar.jsp" %>
--
--  A esto:
--       ./web/WEB-INF/jsps/home/../nav_bar.jsp
--
-- Basicamente extrae el valor de "file" y se lo pone al final de rel_path
--
-- Esto obtiene la ruta del fragmento
get_fragment_path:: FilePath -> ServerString -> FilePath
get_fragment_path rel_path bs8_fragment = do
    let bs8_seg = BS8.strip bs8_fragment
    -- putStrLn $ "[INFO] Intentando leer fragmento: " ++ BS8.unpack bs8_seg
    let file_path = fromMaybe (BS8.pack "Error Su") $
            BS8.stripSuffix hsp_suffix $
            fromMaybe (BS8.pack "Error Pre") $
            BS8.stripPrefix hsp_prefix bs8_seg

    rel_path ++ BS8.unpack file_path

-- Comprueba si una String es un fragmento
is_hsp_fragment:: ServerString -> Bool
is_hsp_fragment x =
    BS8.isPrefixOf hsp_id (BS8.strip x)



-- Funcion auxiliar, no hace falta ni mirarla
arrejuntaIO :: [IO ServerString] -> IO ServerString
arrejuntaIO ioList = BS8.concat <$> sequence ioList

-- Recive un path de un fichero, lo analiza buscando fragmentos 
--      (<%@include file="../nav_bar.jsp" %>)
-- Y en caso de que los encuentre va reemplaza el fragmento
-- por el html correspondiente
process_file:: FilePath -> IO ServerString
process_file path = do
    file_content <- read_file path
    let rel_path = takeDirectory path++"/"
    let l = BS8.lines file_content
    let pf = map (\x ->
            if is_hsp_fragment x then
                read_fragment $ get_fragment_path rel_path x
            else
                return x
            ) l
    arrejuntaIO pf