{-# OPTIONS_GHC -Wall #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# HLINT ignore "Use if" #-}
{-# OPTIONS_GHC -Wunused-imports #-}


module Hsp(
    process_file,
    get_segment_path
)  where

import System.Directory
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as BS
import Control.Exception (SomeException, try)
import qualified Data.ByteString.Char8 as BS8
import Data.Maybe (fromMaybe)


type Path = String
type ServerString = BS.ByteString

hsp_id :: BS8.ByteString
hsp_id = BS8.pack "<%@include"

hsp_prefix :: BS8.ByteString
hsp_prefix = BS8.pack "<%@include file=\""

hsp_suffix :: BS8.ByteString
hsp_suffix = BS8.pack "\" %>"

routing:: Path -> IO ServerString
routing html_file = do
    res <- try $ BS.readFile html_file
    let v = TE.encodeUtf8 $ T.pack " "
    case res of
        Left (_ :: SomeException) -> return v
        Right contents -> return contents


read_file:: Path -> IO ServerString
read_file path = do
    file_p <- doesFileExist path
    putStrLn $ "[INFO] Buscando archivo: " ++ path
    case file_p of
        True -> routing path
        False -> return $ TE.encodeUtf8 $ T.pack $ "[ERROR] Error en el servidor de aplicaciones, archivo: " ++ path ++ " no encontrado!"



read_segment:: Path -> IO ServerString
read_segment path = do
    read_file path

get_segment_path:: Path -> ServerString -> Path
get_segment_path rel_path bs8_segment = do
    let bs8_seg = BS8.strip bs8_segment
    -- putStrLn $ "[INFO] Intentando leer segmento: " ++ BS8.unpack bs8_seg
    let file_path = fromMaybe (BS8.pack "Error Su") $ 
            BS8.stripSuffix hsp_suffix $ 
            fromMaybe (BS8.pack "Error Pre") $ 
            BS8.stripPrefix hsp_prefix bs8_seg
    
    rel_path ++ BS8.unpack file_path

{-
insert_segment::Path -> ServerString -> IO ServerString
insert_segment segment_path server_string = do
    sc <- read_segment segment_path
    return $ BS8.append server_string sc
-}


is_hsp_segment:: ServerString -> Bool
is_hsp_segment x =
    BS8.isPrefixOf hsp_id (BS8.strip x)

combinarIOBSList :: [IO ServerString] -> IO ServerString
combinarIOBSList ioList = BS8.concat <$> sequence ioList

process_file:: Path -> Path -> IO ServerString
process_file rel_path path = do
    file_content <- read_file path
    let l = BS8.lines file_content
    let pf = map (\x ->
            if is_hsp_segment x then
                read_segment $ get_segment_path rel_path x
            else
                return x
            ) l
    combinarIOBSList pf