type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)
    | Var (string)
    | Let (string, expr, expr)

module Nameless {
    type rec expr =
        | Cst (int)
        | Add (expr, expr)
        | Mul (expr, expr)
        | Var (int)
        | Let (expr, expr)
}


let rec eval = (expr : Nameless.expr, env) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a, env) + eval (b, env)
    | Mul (a, b) => eval (a, env) * eval (b, env)
    | Var(n) => List.nth (env, n)
    | Let(e1, e2) => eval(e2, list{eval(e1, env)}, ...env)
    }
}

type cenv = list<int>

let rec comp = (expr: expr, cenv: cenv): Nameless.expr => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => Add(comp(a, cenv) + comp(b, cenv))
    | Mul (a, b) => Mul(comp(a, cenv), comp(b, cenv))
    | Var(x) => Var(index(cenv, x))
    | Let(x, e1, e2) => Let(comp(e1, cenv), comp(e2, list{x, ...env}))
    }
}
