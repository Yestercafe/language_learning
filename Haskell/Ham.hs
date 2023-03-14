module Main where

merge :: (Ord a) => [a] -> [a] -> [a]
merge a [] = a
merge [] b = b
merge (a : as) (b : bs) | a == b    = a : merge as bs
                        | a < b     = a : merge as (b : bs)
                        | otherwise = b : merge (a : as) bs

ham :: [Int]
ham = 1 : merge (map (2*) ham) (merge (map (3*) ham) (map (5*) ham))

main :: IO ()
main = print (take 15 ham)
