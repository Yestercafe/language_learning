data Shape = Circle Float
           | Rect Float Float
           | Square Float

area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect w h) = h * w
area (Square a) = a * a

circ :: Shape -> Float
circ (Circle r) = 2 * pi * r
circ (Rect w h) = 2 * (w + h)
circ (Square a) = 4 * a
