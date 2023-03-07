data Tree a = Leaf a
            | Node (Tree a) (Tree a)

instance Functor Tree where
    fmap f (Leaf l) = Leaf $ f l
    fmap f (Node tl tr) = Node (fmap f tl) (fmap f tr)
