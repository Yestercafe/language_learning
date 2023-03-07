type Writer a = (a, String)

(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 <> s2)

myReturn :: a -> Writer a
myReturn x = (x, "")

fmap f = id >=> (myReturn . f)
