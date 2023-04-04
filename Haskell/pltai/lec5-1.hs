import Data.Maybe (fromMaybe)
import Control.Exception.Base (assert)

data Typ
    = TInt
    | TBool
    | TVar String
    | TArr Typ Typ
    deriving Show

data Expr
    = CstI Integer
    | CstB Bool
    | Var String
    | If Expr Expr Expr
    | Fun String Expr
    | App Expr Expr
    | Add Expr Expr
    deriving Show

type Constraints = [(Typ, Typ)]

type Context = [(String, Typ)]

newTvar :: String -> Typ
newTvar i = TVar $ "T" ++ show i

checkExpr :: Context -> Expr -> (Typ, Constraints)
checkExpr ctx (CstI x) = (TInt, [])
checkExpr ctx (CstB x) = (TBool, [])
checkExpr ctx (Var v) = (fromMaybe undefined $ lookup v ctx, [])
checkExpr ctx f@(Fun fname body) = (TArr tParam tResult, constr)   -- (T -> T1, C)
    where tParam = newTvar $ show f -- fresh T
          (tResult, constr) = checkExpr ((fname, tParam) : ctx) body   -- t : (T1, C)
checkExpr ctx a@(App fname arg) = (t, constrFun ++ constrArg ++ c)   -- (T, C1 + C2 + {T1 = T2 -> T})
    where t = newTvar $ show a     -- fresh T
          (tFun, constrFun) = checkExpr ctx fname  -- t1 : (T1, C1)
          (tArg, constrArg) = checkExpr ctx arg    -- t2 : (T2, C2)
          c = [(tFun, TArr tArg t)]   -- {T1 = T2 -> T}
checkExpr ctx i@(If cond conseq alt) = (t, constrCond ++ constrConseq ++ constrAlt ++ c)   -- (T, C1 + C2 + C3 + C)
    where t = newTvar $ show i     -- fresh T
          (tCond, constrCond) = checkExpr ctx cond          -- e1 : (T1, C1)
          (tConseq, constrConseq) = checkExpr ctx conseq    -- e2 : (T2, C2)
          (tAlt, constrAlt) = checkExpr ctx alt             -- e3 : (T3, C3)
          c = [(tCond, TBool), (t, tConseq), (t, tAlt)]     -- C = {T1 == Bool, T = T2, T = T3}
checkExpr ctx (Add e1 e2) = (TInt, constr1 ++ constr2 ++ c)
    where (t1, constr1) = checkExpr ctx e1
          (t2, constr2) = checkExpr ctx e2
          c = [(t1, TInt), (t2, TInt)]

occurs :: String -> Typ -> Bool
occurs _ TInt = False
occurs _ TBool = False
occurs name (TVar vname) = name == vname
occurs name (TArr e1 e2) = occurs name e1 && occurs name e2

subst :: Constraints -> String -> Typ -> Constraints
subst = go []
    where substTyp :: Typ -> String -> Typ -> Typ
          substTyp TInt _ _ = TInt
          substTyp TBool _ _ = TBool
          substTyp v@(TVar vname) x t = if vname == x then t else v
          substTyp (TArr e1 e2) x t = TArr (substTyp e1 x t) (substTyp e2 x t)
          go :: Constraints -> Constraints -> String -> Typ -> Constraints
          go ret [] _ _ = ret
          go ret ((e1, e2) : rest) x t = go ((substTyp e1 x t, substTyp e2 x t) : ret) rest x t

type Subst = [(String, Typ)]
solve :: Constraints -> Subst
solve cs = go cs []
    where go :: Constraints -> Subst -> Subst
          go [] s = s
          go (c : rest) s = case c of
                                (TInt, TInt) -> go rest s
                                (TBool, TBool) -> go rest s
                                (TArr t1 t2, TArr t3 t4) -> go ((t1, t3) : (t2, t4) : rest) s
                                (TVar x, t) -> if not $ occurs x t then go (subst rest x t) $ (x, t) : s else undefined
                                (t, TVar x) -> if not $ occurs x t then go (subst rest x t) $ (x, t) : s else undefined
                                _ -> undefined

typeSubst :: Typ -> Subst -> Typ
typeSubst TInt _ = TInt
typeSubst TBool _ = TBool
typeSubst (TVar vname) subst = fromMaybe undefined $ lookup vname subst
typeSubst (TArr e1 e2) subst = TArr (typeSubst e1 subst) (typeSubst e2 subst)

infer :: Expr -> Typ
infer expr = typeSubst t (reverse s)
    where (t, cs) = checkExpr [] expr
          s = solve cs

test = Fun "f" $ Fun "a" $ Fun "b" $ If (Var "a") (Add (App (Var "f") (Var "b")) (CstI 1)) (App (Var "f") (Var "a"))

main :: IO ()
main = print $ infer test
