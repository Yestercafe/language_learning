-- Complete the de Bruijn index based interpreter in natural semantics
-- Apply the de Bruijn index for extended lambda calculus (+ Let)

data DeBruijn
    = Var Integer
    | Fun DeBruijn
    | App DeBruijn DeBruijn
    | Let DeBruijn DeBruijn
    deriving Show

shift :: Integer -> DeBruijn -> DeBruijn
shift i = shiftAux i 0
    where shiftAux :: Integer -> Integer -> DeBruijn -> DeBruijn
          shiftAux i d t@(Var j) = if j < d then Var j else Var $ i + d
          shiftAux i d t@(Fun body) = Fun $ shiftAux i (d + 1) body
          shiftAux i d t@(App a b) = App (shiftAux i d a) (shiftAux i d b)
          shiftAux i d t@(Let val body) = Let (shiftAux i d val) (shiftAux i (d + 1) body)

-- t[u/x]
subst :: DeBruijn -> Integer -> DeBruijn -> DeBruijn
subst t@(Var i) x u = if i == x then u else Var $ i - 1
subst t@(Fun body) x u = Fun $ subst body (x + 1) $ shift 1 u
subst t@(App a b) x u = App (subst a x u) (subst a x u)
subst t@(Let val body) x u = Let (subst val x u) (subst body x u)

eval :: DeBruijn -> DeBruijn
eval v@(Var i) = v
eval f@(Fun body) = Fun $ eval body
eval a@(App f arg) = eval $ subst ef 0 earg
    where (Fun ef) = eval f
          earg = eval arg
eval l@(Let val body) = eval $ App (Fun body) val

churchTrue = Fun $ Fun $ Var 1
churchFalse = Fun $ Fun $ Var 0
ifThenElse = Fun $ Var 0

-- test = eval $ Let churchTrue $ Let churchFalse $ Var 1
test = eval $ Let churchFalse $ Let churchTrue $ App (App (App ifThenElse churchTrue) $ Var 1) $ Var 0

main :: IO ()
main = print test
