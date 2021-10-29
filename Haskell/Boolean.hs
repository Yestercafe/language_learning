-- Boolean.hs
import Prelude hiding ((/=),(==),not,and,or,(&&),(||))

(==) :: Bool -> Bool -> Bool
(==) True True   = True
(==) False False = True
(==) _ _         = False

not :: Bool -> Bool
not True  = False
not False = True

and, or, xor :: Bool -> Bool -> Bool
and True b1 = b1
and False _ = False

or True _   = True
or False b1 = b1

xor b1 b2 = not $ (==) b1 b2

infix 4 ==
infix 4 /=
infixl 3 &&
infixl 2 ||

(&&) = and
(||) = or
(/=) = xor

type S = Bool
type C = Bool
hA :: Bool -> Bool -> (S, C)
hA a b = (a /= b, a && b)

fA a b c = let (axb, aab)     = hA a b in
           let (axbxc, axbac) = hA axb c in (axbxc, axbac || aab)

nand, nor :: Bool -> Bool -> Bool
nand True True = False
nand _ _ = True

nor False False = True
nor _ _ = False

not1, not2 :: Bool -> Bool
not1 b = nand b b
not2 b = nor b b

and1, and2 :: Bool -> Bool -> Bool
-- and1 b1 b2 = not1 $ nand b1 b2
and1 b1 b2 = nand nb1b2 nb1b2
  where nb1b2 = nand b1 b2
-- and2 b1 b2 = nor (not2 b1) (not2 b2)
and2 b1 b2 = nor (nor b1 b1) (nor b2 b2)

or1, or2 :: Bool -> Bool -> Bool
-- or1 b1 b2 = nand (not1 b1) (not1 b2)
or1 b1 b2 = nand (nand b1 b1) (nand b2 b2)
-- or2 b1 b2 = not2 $ nor b1 b2
or2 b1 b2 = nor nb1b2 nb1b2
  where nb1b2 = nor b1 b2

xor1 :: Bool -> Bool -> Bool
-- xor1 b1 b2 = or1 (and1 b1 (not1 b2)) (and1 (not1 b1) b2)
xor1 b1 b2 = nand (nand b1 nb1b2) (nand b2 nb1b2)
  where nb1b2 = nand b1 b2

xnor1 :: Bool -> Bool -> Bool
-- xnor1 b1 b2 = or1 (and1 b1 b2) (and1 (not1 b1) (not1 b2))
xnor1 b1 b2 = nand (nand b1 b2) orb1b2
  where orb1b2 = nand (nand b1 b1) (nand b2 b2)

gets :: [a] -> Int -> a
gets l i = head $ drop i l

