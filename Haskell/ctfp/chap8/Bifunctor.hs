import Data.Bifunctor (Bifunctor)
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
