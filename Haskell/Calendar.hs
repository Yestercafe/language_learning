type Weekday = Int
type Year    = Int
type Month   = Int
type Day     = Int

weekday' :: Year -> Day -> Weekday
weekday' y d = let y1 = y - 1 in
  (y1 + (div y1 4) - (div y1 100) + (div y1 400) + d) `mod` 7

isLeapYear :: Year -> Bool
isLeapYear y = ((mod y 4 == 0) && (mod y 100 /= 0)) || (mod y 400 == 0)

monthDays :: Year -> Month -> Int
monthDays y m | m == 2 = if not $ isLeapYear y then 28 else 29
              | elem m [1,3,5,7,8,10,12] = 31
              | elem m [4,6,9,11] = 30
              | otherwise = error "invalid month"

accDays :: Year -> Month -> Day -> Int
accDays y m d | d > monthDays y m = error "Invalid days"
              | otherwise = (sum $ take (m - 1) (map (monthDays y) [1..12])) + d

weekday y m d = weekday' y $ accDays y m d
