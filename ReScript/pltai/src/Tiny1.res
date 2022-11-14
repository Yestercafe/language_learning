type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)
    | Var (string)
    | Let (string, expr, expr)

type env= list<(string, int)>

let rec eval = (expr, env) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a, env) + eval (b, env)
    | Mul (a, b) => eval (a, env) * eval (b, env)
    | Var(x) => assoc (x, env)
    | Let(x, e1, e2) => eval(e2, list{(x, eval(e1, env)), ...env})
    }
}


