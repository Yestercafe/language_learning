import Data.Bifunctor (Bifunctor)
import Data.Functor.Identity

class MyBifunctor f where
    bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
    bimap g h = first g . second h
    first :: (a -> c) -> f a b -> f c b
    first g = bimap g id
    second :: (b -> d) -> f a b -> f a d
    second = bimap id

instance MyBifunctor (,) where
    bimap f g (x, y) = (f x, g y)
    first f (x, y) = (f x, y)
    second g (x, y) = (x, g y)

newtype BiComp bf fu gu a b = BiComp (bf (fu a) (gu b))

instance (MyBifunctor bf, Functor fu, Functor gu) =>
    MyBifunctor (BiComp bf fu gu) where
        bimap f1 f2 (BiComp x) = BiComp (bimap (fmap f1) (fmap f2) x)

main :: IO ()
main = do
    print "hello world"


data Pair a b = Pair a b
instance MyBifunctor Pair where
    bimap f g (Pair a b) = Pair (f a) (g b)
    first f (Pair a b) = Pair (f a) b
    second g (Pair a b) = Pair a (g b)


data PreList' a b = Nil | Cons a b

instance MyBifunctor PreList' where
    bimap _ _ Nil = Nil
    bimap f g (Cons a b) = Cons (f a) (g b)
    first _ Nil = Nil
    first f (Cons a b) =  Cons (f a) b
    second _ Nil = Nil
    second g (Cons a b) = Cons a (g b)

data K2 c a b = K2 c
instance MyBifunctor (K2 c) where
    bimap _ _ (K2 c) = K2 c

data Fst a b = Fst a
instance MyBifunctor Fst where
    bimap f _ (Fst a) = Fst $ f a

data Snd a b = Snd b
instance MyBifunctor Snd where
    bimap _ g (Snd b) = Snd $ g b

