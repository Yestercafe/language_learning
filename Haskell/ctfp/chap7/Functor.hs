class MyFunctor f where
    myFmap :: (a -> b) -> f a -> f b

instance MyFunctor Maybe where
    myFmap _ Nothing = Nothing
    myFmap f (Just x) = Just (f x)

data List a = Nil | Cons a (List a)

instance MyFunctor List where
    myFmap _ Nil = Nil
    myFmap f (Cons x rest) = Cons (f x) (myFmap f rest)

-- reader function
instance MyFunctor ((->) r) where
    myFmap = (.)

