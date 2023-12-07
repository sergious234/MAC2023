{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# OPTIONS_GHC -Wunused-imports #-}


module Rutas(
    Url,
    get_posible_routes
)  where


import Data.Maybe (catMaybes)

type Url = String

all_routes:: Url -> [Url]
all_routes x = tail $ scanl (\x y -> x ++ [y]) ""  $ takeWhile (/=' ') $ dropWhile (/='/') x

get_posible_routes::  Url -> [Url]
get_posible_routes url = do
    let rts = all_routes url
    let maybe_routes = map (\x -> if last x == '/' then Just (init x) else Nothing) rts
    catMaybes maybe_routes ++ [last rts]