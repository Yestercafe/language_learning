module Main where

lst :: [Int]
lst = filter (\x -> x > 10 && even x) [1..]

lst' :: [Int]
lst' = [x | x <- [0..], even x, x > 10]

piIter :: Int -> Double
piIter times = 4 * (+)
                     (sum $ take times [1 / ((2 * fromIntegral x - 1) * 2 ^ (2 * x - 1) * (-1) ^ (x - 1)) | x <- [1..]])
                     (sum $ take times [1 / ((2 * fromIntegral x - 1) * 3 ^ (2 * x - 1) * (-1) ^ (x - 1)) | x <- [1..]])

main :: IO ()
main = do
  print $ take 10 lst
  print $ take 10 lst'
  print $ piIter 1000

