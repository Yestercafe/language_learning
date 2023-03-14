type Reader r a = r -> a

fmap :: (a -> b) -> Reader r a -> Reader r b
fmap f g = f . g

type Op r a = a -> r

class Contravariant f where
    contramap :: (b -> a) -> (f a -> f b)

instance Contravariant (Op r) where
    contramap f g = g . f

