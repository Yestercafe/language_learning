module List (List (Empty, List), createList, listToVanillaList, listPush, listInsert, listPop, listRemove, listLength, listEmpty, listPushFront, listSort, listFlip) where

data List a
  = Empty
  | List a (List a)
  deriving (Show, Eq)

createList :: [a] -> List a
createList = foldr List Empty

listToVanillaList :: List a -> [a]
listToVanillaList Empty = []
listToVanillaList (List x xs) = x : listToVanillaList xs

listPush :: List a -> a -> List a
listPush Empty y = List y Empty
listPush (List x xs) y = List x $ listPush xs y

listInsert :: List a -> Int -> a -> List a
listInsert Empty 0 x = List x Empty
listInsert Empty _ x = error "List is not too long enough!"
listInsert (List x xs) idx y =
  if idx == 0
    then List y (List x xs)
    else List x (listInsert xs (idx - 1) y)

listPop :: List a -> List a
listPop Empty = error "List is empty!"
listPop (List x Empty) = Empty
listPop (List x xs) = List x (listPop xs)

listRemove :: List a -> Int -> List a
listRemove Empty _ = error "List is not too long enough!"
listRemove (List x xs) idx =
  if idx == 0
    then xs
    else List x (listRemove xs (idx - 1))

listLength :: List a -> Int
listLength Empty = 0
listLength (List x xs) = 1 + listLength xs

listEmpty :: List a -> Bool
listEmpty xs = 0 == listLength xs

listPushFront :: List a -> a -> List a
listPushFront Empty y = List y Empty
listPushFront (List x xs) y = List y (List x xs)

listSortAux :: (Ord a) => List a -> List a
listSortAux Empty = Empty
listSortAux (List x Empty) = List x Empty
listSortAux (List x (List y ys)) =
  if x > y
    then List y $ listSort (List x ys)
    else List x $ listSort (List y ys)

listSort :: (Ord a) => List a -> List a
listSort xs = if xs == res then res else listSort res
  where
    res = listSortAux xs

listFlip :: List a -> List a
listFlip Empty = Empty
listFlip (List x xs) = listPush (listFlip xs) x

instance Ord a => Ord (List a) where
  compare :: List a -> List a -> Ordering
  compare Empty Empty = EQ
  compare Empty (List x xs) = LT
  compare (List x xs) Empty = GT
  compare (List x xs) (List y ys)
    | x < y = LT
    | x > y = GT
    | x == y = compare xs ys
