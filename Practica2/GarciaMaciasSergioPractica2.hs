--  ███╗   ██╗███████╗ ██████╗ ██████╗ ██████╗ ███████╗██╗  ██╗
--  ████╗  ██║██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
--  ██╔██╗ ██║███████╗██║   ██║██████╔╝██████╔╝█████╗  █████╔╝ 
--  ██║╚██╗██║╚════██║██║   ██║██╔══██╗██╔══██╗██╔══╝  ██╔═██╗ 
--  ██║ ╚████║███████║╚██████╔╝██████╔╝██║  ██║███████╗██║  ██╗
--  ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

-- EJERCICIO 1: Sea la función nsobrek tal que nsobrek 
-- n k es el número de combinaciones de n elementos tomados 
-- de k en k.

fact:: Double -> Double
fact 1 = 1
fact n = n * fact(n-1)


ifact:: Double -> Double
ifact n = (foldr(\x y -> x*y) 1 [1,2..n])

insobrek:: Double -> Double -> Double
insobrek n k = ifact(n) / (ifact(k) * ifact (n-k) )

nsobrek:: Double -> Double -> Double
nsobrek n k = fact(n) / (fact(k) * fact (n-k) )

gnsobrek::(Fractional a) => a -> a -> a 
gnsobrek n k = wfact(n) / (wfact(k) * wfact (n-k) )
    where 
        wfact 0 = 1
        wfact n = n * wfact(n-1)


nsobrek2:: Double -> Double -> Double
nsobrek2 n k = wfact(n) / (wfact(k) * wfact (n-k) )
    where 
        wfact 0 = 1
        wfact n = n * wfact(n-1)







--  ██████╗ ██╗████████╗ █████╗  ██████╗  ██████╗ ██████╗  █████╗ ███████╗
--  ██╔══██╗██║╚══██╔══╝██╔══██╗██╔════╝ ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
--  ██████╔╝██║   ██║   ███████║██║  ███╗██║   ██║██████╔╝███████║███████╗
--  ██╔═══╝ ██║   ██║   ██╔══██║██║   ██║██║   ██║██╔══██╗██╔══██║╚════██║
--  ██║     ██║   ██║   ██║  ██║╚██████╔╝╚██████╔╝██║  ██║██║  ██║███████║
--  ╚═╝     ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
-- (No tiene nada que ver con pitagoras)
-- EJERCICIO 2: Definir la función raíces tal que raíces a b c 
-- es la lista de las raices de la ecuación ax2 + bc + c = 0.
pitagoras:: Double -> Double -> Double -> [Double]
pitagoras a b c = 
    if b*b - 4*a*c > 0 then 
        [((-b-sqrt(b*b - 4*a*c))/(2*a)), ((-b+sqrt(b*b - 4*a*c))/(2*a))]
    else 
        error "Error"
    
gpitagoras:: Double -> Double -> Double -> [Double] 
gpitagoras a b c 
    |   (b*b - 4*a*c) >= 0 = [
            ((-b-sqrt(b*b - 4*a*c))/(2*a)), 
            ((-b+sqrt(b*b - 4*a*c))/(2*a))
        ]
    |   otherwise = error "Error"


tagoras:: (Double -> Double) -> Double -> Double -> Double -> Double 
tagoras func a b c = func (sqrt(b*b-4*a*c))

pi:: Double -> Double -> Double -> [Double]
pi a b c = [
            (-b + tagoras negate a b c) / (2*a), 
            (-b + tagoras id a b c)/(2*a)
        ]


wpi:: Double -> Double -> Double -> [Double]
wpi j i k = [tago j i k, goras j i k]
    where
        tago x y z = (-y -sqrt(y*y - 4*x*z)) / (2*x)
        goras x y z = (-y +sqrt(y*y - 4*x*z)) / (2*x)








--  ███████╗██╗██████╗  ██████╗ ███╗   ██╗ █████╗  ██████╗ ██████╗██╗
--  ██╔════╝██║██╔══██╗██╔═══██╗████╗  ██║██╔══██╗██╔════╝██╔════╝██║
--  █████╗  ██║██████╔╝██║   ██║██╔██╗ ██║███████║██║     ██║     ██║
--  ██╔══╝  ██║██╔══██╗██║   ██║██║╚██╗██║██╔══██║██║     ██║     ██║
--  ██║     ██║██████╔╝╚██████╔╝██║ ╚████║██║  ██║╚██████╗╚██████╗██║
--  ╚═╝     ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝╚═╝

-- Los números de Fibonacci quedan definidos por las ecuaciones


fib:: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib(n-1) + fib(n-2)


ifib:: Integer -> Integer
ifib n = fst (foldr(\x y -> ( snd y, (fst y + snd y)) ) (1,1) [1,2..n])

wfib :: Int -> Integer
wfib n = fibHelper (n+1) 0 1
  where
    fibHelper 0 a _ = a
    fibHelper n a b = fibHelper (n - 1) b (a + b)









--  ██████╗ ███████╗██████╗ ████████╗███████╗███╗   ██╗███████╗ ██████╗███████╗
--  ██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝████╗  ██║██╔════╝██╔════╝██╔════╝
--  ██████╔╝█████╗  ██████╔╝   ██║   █████╗  ██╔██╗ ██║█████╗  ██║     █████╗  
--  ██╔═══╝ ██╔══╝  ██╔══██╗   ██║   ██╔══╝  ██║╚██╗██║██╔══╝  ██║     ██╔══╝  
--  ██║     ███████╗██║  ██║   ██║   ███████╗██║ ╚████║███████╗╚██████╗███████╗
--  ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚══════╝ ╚═════╝╚══════╝
-- EJERCICIO 4: Comprobar la pertenencia a una lista usando una función recursiva.

pertenece::(Eq a) => [a] -> a -> Bool
pertenece [] _ = error "La lista tiene que tener elementos campeon"
pertenece (h:mascarpone) a =
    if (h == a) then True
    else if length mascarpone > 0 then pertenece mascarpone a
    else False

gpertenece::(Eq a) => [a] -> a -> Bool
gpertenece [] _ = error "La lista tiene que tener elementos campeon"
gpertenece (h:mascarpone) a 
    | a == h = True
    | length mascarpone >= 1 = gpertenece mascarpone a
    | otherwise  = False





--  ███████╗██╗   ██╗██╗     ███████╗██████╗      ██╗██╗  ██╗
--  ██╔════╝██║   ██║██║     ██╔════╝██╔══██╗    ███║██║  ██║
--  █████╗  ██║   ██║██║     █████╗  ██████╔╝    ╚██║███████║
--  ██╔══╝  ██║   ██║██║     ██╔══╝  ██╔══██╗     ██║╚════██║
--  ███████╗╚██████╔╝███████╗███████╗██║  ██║     ██║     ██║
--  ╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝     ╚═╝     ╚═╝

chunkList :: Int -> [a] -> [[a]]
chunkList _ [] = []
chunkList n xs = take n xs : chunkList n (drop n xs)

max_seq :: Int -> [Integer] -> Integer
max_seq n range = maximum (map (\chunk -> maximum( map(\e -> collatz 0 e) chunk)) (chunkList n range))

collatz:: Integer -> Integer -> Integer
collatz i 1 = i
collatz i n 
    | even n = collatz (i+1) (n `div` 2)
    | otherwise = collatz (i+1) (n*3+1)


ifcollatz:: Integer -> Integer -> Integer
ifcollatz i n =
    if n == 1 then i
    else if even n then ifcollatz (i+1) (n `div` 2)
    else ifcollatz (i+1) (n*3+1)

wcollatz:: Integer -> Integer -> Integer
wcollatz i n = wcollatz' i n
    where
        wcollatz' acc num
            | num == 1 = acc            
            | even num = wcollatz' (acc+1) (div num 2)
            | otherwise = wcollatz' (acc+1) (num*3+1)





--  ███████╗██╗   ██╗██╗     ███████╗██████╗     ██████╗ ██████╗ 
--  ██╔════╝██║   ██║██║     ██╔════╝██╔══██╗    ╚════██╗╚════██╗
--  █████╗  ██║   ██║██║     █████╗  ██████╔╝     █████╔╝ █████╔╝
--  ██╔══╝  ██║   ██║██║     ██╔══╝  ██╔══██╗     ╚═══██╗ ╚═══██╗
--  ███████╗╚██████╔╝███████╗███████╗██║  ██║    ██████╔╝██████╔╝
--  ╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═════╝ ╚═════╝ 

separa_fract:: [Char] -> [[Char]]
separa_fract cadena 
    | elem '/' cadena == True = [takeWhile(\x -> x /= '/') cadena, tail (dropWhile(\x -> x /= '/') cadena)]
    | otherwise = error "No es una entrada valida"


quita_ele_final:: Eq a => a -> [a] -> [a]
quita_ele_final target list
    | length (dropWhile (/=target) list) == 0 = []
    | otherwise = tail (dropWhile (/=target) list)

quita_ele:: Eq a => a -> [a] -> [a]
quita_ele _ [] = []
quita_ele target list = takeWhile (/=target) list ++ quita_ele_final target list

quitaRepes ::(Eq a) => Int -> [a] -> [a] -> [a]
quitaRepes index den nume
    | index >= length den = nume 
    | length nume == 0 = nume 
    | elem (den!!index) nume = quitaRepes (index+1) den (quita_ele (den!!index) nume)
    | otherwise = quitaRepes (index+1) den nume


euler33:: [Char] -> [Char]
euler33 cadena = primera_parte cadena ++ "/" ++ segunda_parte cadena
    where
        primera_parte c = quitaRepes 0 (separa_fract c !! 1) (separa_fract c !! 0)
        segunda_parte w = quitaRepes 0 (separa_fract w !! 0) (separa_fract w !! 1)