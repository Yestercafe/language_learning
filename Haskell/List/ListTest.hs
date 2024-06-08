module Main where

import List (List (Empty), createList, listPop, listPush, listPushFront, listSort, listToVanillaList, listInsert, listRemove, listFlip, listEmpty)

main :: IO ()
main = do
  let aList = createList [1, 2, 3]
  print $ listPush aList 4
  print $ listPop aList
  print $ listSort (listPushFront aList 4)
  print $ (==) (listSort (createList [4, 3, 2, 1])) (createList [1, 2, 3, 4])
  print $ (==) (createList (listToVanillaList aList)) aList
  print $ listInsert aList 0 4
  print $ listInsert aList 2 4
  print $ listRemove aList 1
  print $ listFlip aList
  print $ listEmpty aList
  print $ listEmpty (listPop (createList [1]))
  print $ aList < createList [1, 2, 4]
  print $ (createList [1, 2, 3, 4]) > (createList [1, 2, 3])
  print $ (createList []) < (createList [0])

-- print $ listPop (Empty :: List Int)
