-- Implement the substitution function N[v/x]:
-- subst (N: lambda, x: string, v: value) : lambda

data Lambda
    = Var String
    | Fun String Lambda
    | App Lambda Lambda
    deriving Show

churchTrue = Fun "x" (Fun "y" (Var "x"))
churchFalse = Fun "x" (Fun "y" (Var "y"))
ifThenElse = Fun "x" $ Var "x"

subst :: String -> Lambda -> Lambda -> Lambda
subst x va body@(Var name) = if name == x then va else body
subst x va body@(Fun funParam funBody) = if funParam == x then body else Fun x (subst x va funBody)
subst x va body@(App fun argument) = App (subst x va fun) $ subst x va argument

eval :: Lambda -> Lambda
eval v@(Var _) = v
eval t@(Fun _ _) = t
eval (App f arg) = eval $ subst x va body
    where (Fun x body) = eval f
          va = eval arg

test = eval (App (App (App ifThenElse churchTrue) churchFalse) churchTrue)

main :: IO ()
main = print test
