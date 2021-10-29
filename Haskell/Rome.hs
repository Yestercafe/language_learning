-- Rome.hs

romeNotation :: [String]
romeNotation = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]

romeAmount :: [Int]
romeAmount = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]

romePair :: [(Int, String)]
romePair = zip romeAmount romeNotation

subtrahend :: Int -> (Int, String)
subtrahend n = head $ dropWhile (\(a, _) -> a > n) romePair

convert :: Int -> String
convert 0 = ""
convert n = let (rome, m) = subtrahend n
            in m ++ convert (n - rome)

-- Rome Inverse Function
romePair' :: [(String, Int)]
romePair' = zip romeNotation romeAmount
convert' :: String -> Int
convert' s | length s > 1 = let f = filter (\(a, _) -> a == take 2 s) romePair' in
                            if not $ null f
                            then snd (head f) + (convert' (drop 2 s))
                            else (convert' (take 1 s)) + (convert' $ tail s)
           | length s == 1 = let f = filter (\(a, _) -> a == [head s]) romePair' in
                             snd $ head f
           | otherwise = 0

-- Decimal to Binary
dToB, dToB' :: Int -> String
dToB n | n == 0 = "0"
       | otherwise = dToB' n
dToB' 0 = ""
dToB' n = dToB' (div n 2) ++ (show $ mod n 2)

