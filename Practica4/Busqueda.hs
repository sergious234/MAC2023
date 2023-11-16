-- Esto de aqui me lo recomienda el ghc para quitar los
-- warnings. Podria no ponerlo me "revienta" que me esté marcando
-- todo el rato que no estoy usando camelCase.
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use camelCase" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}

module Busqueda where

import GHC.Float (floorDouble)
import Debug.Trace (trace)

--  ███████╗███████╗ ██████╗        ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗
--  ██╔════╝██╔════╝██╔═══██╗       ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║
--  ███████╗█████╗  ██║   ██║       ███████╗█████╗  ███████║██████╔╝██║     ███████║
--  ╚════██║██╔══╝  ██║▄▄ ██║       ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║
--  ███████║███████╗╚██████╔╝       ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║
--  ╚══════╝╚══════╝ ╚══▀▀═╝        ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝

seq_search :: Integer -> IO ()
seq_search num = do
  putStrLn $ "¿Es este number? " ++ show num
  v <- getLine
  case v of
    "si" -> putStrLn "Soy un buen bicharraco, he descubierto tu numero"
    "no" -> seq_search $ num + 1
    _otherwise -> do
      putStrLn "Crack, o si o no, no me vuelvas loco"
      seq_search $ num + 1

--  ██████╗ ██╗███╗   ██╗ █████╗ ██████╗ ██╗   ██╗    ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗
--  ██╔══██╗██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║
--  ██████╔╝██║██╔██╗ ██║███████║██████╔╝ ╚████╔╝     ███████╗█████╗  ███████║██████╔╝██║     ███████║
--  ██╔══██╗██║██║╚██╗██║██╔══██║██╔══██╗  ╚██╔╝      ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║
--  ██████╔╝██║██║ ╚████║██║  ██║██║  ██║   ██║       ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║
--  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝

bin_search :: Integer -> Integer -> IO ()
bin_search min max = do
  -- No se si hemos dado el let pero es para
  -- simplificarme la vida
  let mid = div (max + min) 2
  putStrLn $ "mayor, menor o igual que: " ++ show mid
  v <- getLine
  case v of
    "mayor" -> bin_search (mid + 1) max
    "menor" -> bin_search min $ mid - 1
    _otherwise -> putStrLn "Que bueno soy, he encontrado el numero"




--
--  ██╗███╗   ██╗████████╗███████╗██████╗ ██████╗  ██████╗ ██╗      █████╗ ████████╗██╗ ██████╗ ███╗   ██╗    
--  ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔═══██╗██║     ██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║    
--  ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██████╔╝██║   ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║    
--  ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔═══╝ ██║   ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║    
--  ██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ╚██████╔╝███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║    
--  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝    
--                                                                                                            
--                          ███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗                                  
--                          ██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║                                  
--                          ███████╗█████╗  ███████║██████╔╝██║     ███████║                                  
--                          ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║                                  
--                          ███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║                                  
--                          ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝                                  
interpolation_search :: [Int] -> Int -> IO()
interpolation_search lista x = do buscar 0 (length lista -1)
    where
        buscar :: Int -> Int -> IO()
        buscar izquierda derecha = do
            let condicion = izquierda <= derecha && x >= (lista !! izquierda) && x <= (lista !! derecha);
            if condicion then do
                  let indice = izquierda + div ((x - (lista !! izquierda)) * (derecha - izquierda)) ((lista !! derecha) - (lista !! izquierda));
                  if lista !! indice == x then
                    putStrLn $ "Encontrado en: " ++ show indice
                  else if lista !! indice < x then
                    buscar (indice+1) derecha
                  else
                    buscar izquierda (indice-1)
            else 
                putStrLn "No encontrado"
