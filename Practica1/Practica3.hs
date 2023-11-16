get_mayor_abs:: [Integer] -> Integer
get_mayor_abs values = maximum (map (abs) values)

num_veces::(Eq a) => [a] -> a -> Int
num_veces values val = length ( filter (\x -> x == val) values )

cambia_el_primero::[a] -> a -> [a]
cambia_el_primero (_:resto) val = val:resto

cambia_el_n::a -> Int -> [a] -> [a]
cambia_el_n new_val n list = take (n-1) list ++ [new_val] ++ drop (n) list

palabras_mayores_n:: Int -> [[Char]] -> [[Char]]
palabras_mayores_n minimo palabras = filter (\x -> length x > minimo) palabras


--   _______        __   _______ .______          _______. __       _______. __    ______        _______.
--  |   ____|      |  | |   ____||   _  \        /       ||  |     /       ||  |  /  __  \      /       |
--  |  |__         |  | |  |__   |  |_)  |      |   (----`|  |    |   (----`|  | |  |  |  |    |   (----`
--  |   __|  .--.  |  | |   __|  |      /        \   \    |  |     \   \    |  | |  |  |  |     \   \    
--  |  |____ |  `--'  | |  |____ |  |\  \----.----)   |   |  | .----)   |   |  | |  `--'  | .----)   |   
--  |_______| \______/  |_______|| _| `._____|_______/    |__| |_______/    |__|  \______/  |_______/    
--                                                                                                       
--                      .______   ____    ____                               
--                      |   _  \  \   \  /   /                               
--                      |  |_)  |  \   \/   /                                
--                      |   _  <    \_    _/                                 
--                      |  |_)  |     |  |                                   
--                      |______/      |__|                                   
--                                                                                                       
--       _______. _______ .______        _______  __    ______                                           
--      /       ||   ____||   _  \      /  _____||  |  /  __  \                                          
--     |   (----`|  |__   |  |_)  |    |  |  __  |  | |  |  |  |                                         
--      \   \    |   __|  |      /     |  | |_ | |  | |  |  |  |                                         
--  .----)   |   |  |____ |  |\  \----.|  |__| | |  | |  `--'  |                                         
--  |_______/    |_______|| _| `._____| \______| |__|  \______/                                          
--                                                                                                       

-- Suma Pares Resta Impares
spri:: [Integer] -> Integer
spri values = sum (filter(\x -> mod x 2 == 0) values) - sum (filter(\x -> mod x 2 == 1) values)

-- Tiene algun divisor mayor que pero menor que el
tiene_divisor:: Integer -> Bool
tiene_divisor n = any(\x -> mod n x == 0) [2,3 .. floor(sqrt(fromIntegral n))]
--                                                           ^^^^^^^^^^^^
--                                                    Esto lo he sacado de la documentacion
--                                                    de Haskell que me hacia falta para la sqrt


-- Haskell es lentillo y mi algoritmo es super basico asi que
-- por si acaso no le pidas mas de 100 numeros primos
genera_n_primos:: Int -> [Integer]
genera_n_primos n = take(n) (filter(\x -> tiene_divisor x == False) [1,2..])


-- Esto esta "to wapo"
compon_foldr_de_n:: Integer -> [Char]
compon_foldr_de_n n = foldr (\x y -> "(" ++ show x ++ "+" ++ y ++ ")" ) "0" [1,2 .. n]

-- Suma los Primeros N No Primos
spnnp:: Integer -> Integer
spnnp n = sum (filter(\x -> tiene_divisor x == True) [1,2 .. n])


{- Esto es magia negra ;)

show_step:: [Integer] -> Int -> IO ()
show_step (x:sum) it = putStr("(foldr(\\x y -> (" ++  show x ++  " + " ++ show (head sum) ++ ") )) " ++  show (x + head sum) ++ " " ++ show [1..it-1] ++  "\n");


indexa_lista:: [[Integer]] -> [([Integer],Int)]
indexa_lista values = zip values [length values, (length values) - 1 .. 0]

expand_foldr:: Integer -> [Integer] -> IO [()]
expand_foldr acc (h:t)  = 
    mapM(\(state, it) -> show_step state it ) (indexa_lista(reverse (foldr(\x y -> [[x, sum (head y)]] ++ y ) [[acc,acc]] (h:t))))

-}