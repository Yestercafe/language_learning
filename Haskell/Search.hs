-- Search.hs

search :: (Ord a) => a -> [a] -> Bool
search a [] = False
search a xs | m < a = search a behind
            | m > a = search a front
            | otherwise = True
            where (front, m:behind) = splitAt (div (length xs) 2) xs

