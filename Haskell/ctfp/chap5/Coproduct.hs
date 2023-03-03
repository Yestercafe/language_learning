p :: Int -> Either Int Bool
p = Left

q :: Bool -> Either Int Bool
q = Right

data M = A Int
       | C Int
       | B Bool

i :: Int -> M
i = A

j :: Bool -> M
j = B

m1 :: M -> Either Int Bool
m1 (A a) = Left a
m1 (B b) = Right b
m1 (C c) = Left 0

m2 :: M -> Either Int Bool
m2 (A a) = Left a
m2 (B b) = Right b
m2 (C c) = Left $ (-) c 1
