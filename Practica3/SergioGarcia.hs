ej1:: [Int]
ej1 = [x+10 | x <- [1..10]]

ej2:: [[Int]]
ej2 = [[x] | x <- [1..10], even x]

ej3:: [[Int]]
ej3 = [[11-x] | x <- [1..10]]

ej4:: [Bool]
ej4 = [odd x | x <- [1..10]]

ej5:: [(Integer, Bool)]
ej5 = [(x*3, x<4) | x <- [1..10], x<=6]

ej6:: [(Integer, Bool)]
ej6 = [(5*x, 5*x == 10) | x <- [1..10], x*5 < 20 || x*5 == 40 ]

ej7:: [(Integer, Integer)]
ej7 = [(x+10, x+11) | x <- [1..10], odd x]

ej8:: [[Integer]]
ej8 = [[5,6..x+6] | x <- [1..10], x<8, odd x]

ej9:: [Integer]
ej9 = [21-(x-1)*5| x <- [1..10], x < 6]

ej10:: [[Integer]]
ej10 = [[x+2,x..4] | x <- [1..10], even x]
