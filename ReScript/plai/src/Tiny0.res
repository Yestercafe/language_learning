type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)

let rec eval = (expr : expr) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a) + eval (b)
    | Mul (a, b) => eval (a) * eval (b)
    }
}


