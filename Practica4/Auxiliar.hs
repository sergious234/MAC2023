{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- A esto ni caso, es para desactivar 
--            warnings 


module Auxiliar where


--      CAJITA DE IMPORTS
-- NO SACARLOS DE AQUI O DEJAN DE FUNCIONAR
-- SE SIENTEN COMO EN CASA
----------------------------------------------------- +
import Busqueda ( seq_search, bin_search, interpolation_search )         -- |
import Distribution.Compat.Prelude (exitSuccess)   -- |
import System.Info (os)                            -- |
import System.Process ( system )                   -- |
----------------------------------------------------- +


-- Con esto estamos contetos los dos tipos de personas:
--      1 Los que sabemos manejar un ordenador
--      2 Los que usan windows
--
get_os_clear_commad :: String
get_os_clear_commad =
  case os of
    "linux" -> "clear"
    _ -> "cls"

clear_screen :: IO ()
clear_screen = do
  _ <- system get_os_clear_commad
  return ()

tab = "    "
fg_rojo = "\x1b[31m"
fg_verde = "\x1b[32m"
fg_amarillo = "\x1b[33m"
fg_azul = "\x1b[34m"
fg_magenta = "\x1b[35m"
fg_cyan = "\x1b[36m"
fg_blanco = "\x1b[37m"
fg_end = "\x1b[0m"


rainbow :: [Char] -> IO ()
rainbow s = do
-- El mapM_ es para que devuelva IO () y poder mostrarlo. 
-- ^^^^^^^  Si usara el map normal no se mostrarian las cosas por pantalla
--  |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--  +------/
--  |                 
-- vvv
  mapM_ (\(c, i) -> putStr ("\x1b[" ++ show i ++ "m") >> putChar c) (zip s $ cycle [31, 32 .. 37])
-- ^^^^^^^^^^^^^^                                     ^^
--  \                                               No se exactamente que hace este        
--   \                                                operador pero lo necesito para que funcione
--    Esto te esta gustando y lo sabes  
-- 
-- Salto de linea final
-- vvvvvvvvvv
  putStrLn ""


selector :: IO ()
selector = do
  putStrLn "Pulsa enter para continuar"
  putStrLn "\n\n"
  opcion <- getLine
  clear_screen
  putStrLn $ fg_azul ++ "Opcion 1: Busqueda secuencial" ++ fg_end
  putStrLn $ fg_verde ++ "Opcion 2: Busqueda binaria" ++ fg_end
  putStrLn $ fg_amarillo ++ "Opcion 3: Busqueda InTeRpOlAtIvA" ++ fg_end
  putStrLn $ fg_magenta ++ "Opcion 4: Salir" ++ fg_end
  opcion <- getLine
  case opcion of
    "1" -> seq_search 0
    "2" -> bin_search 0 100
    "3" -> interpolation_search [0,1..100] 33
    "4" -> exitSuccess
    --     ^^^^^^^^^^^
    --     No lo hemos dado tampoco pero me arregla la vida

    _otherwise -> do
      putStrLn $ fg_rojo ++ "Eso no es una opción crack! (Pulsa enter para continuar)" ++ fg_end
      _x <- getLine
      putStrLn ""

menu :: IO ()
menu = do
  sequence_ actions
  where
    actions = repeat selector