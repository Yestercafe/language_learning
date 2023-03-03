type A = Either Int Int  -- a + a
type B = (Bool, Int)     -- 2 * a

a2b :: A -> B
a2b (Left a) = (False, a)
a2b (Right a) = (True, a)

b2a :: B -> A
b2a (False, a) = Left a
b2a (True, a) = Right a
