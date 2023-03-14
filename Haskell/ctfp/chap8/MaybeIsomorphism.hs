import Data.Functor.Identity

newtype Const c a = Const c
type Maybe' a = Either (Const () a) (Identity a)

maybe'2Maybe :: Maybe' a -> Maybe a
maybe'2Maybe (Left (Const _)) = Nothing
maybe'2Maybe (Right (Identity a)) = Just a

maybe2Maybe' :: Maybe a -> Maybe' a
maybe2Maybe' (Just a) = Right $ Identity a
maybe2Maybe' Nothing = Left $ Const ()
