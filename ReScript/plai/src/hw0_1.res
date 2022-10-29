type rec expr =
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)

/*
let rec eval = (expr : expr) => {
    switch expr {
    | Cst (i) => i
    | Add (a, b) => eval (a) + eval (b)
    | Mul (a, b) => eval (a) * eval (b)
    }
}
 */

type instr = Cst (int) | Add | Mul  // no recursive
type instrs = list<instr>
type operand = int
type stack = list<operand>

/*
let rec eval = (instrs: instrs, stk: stack) => {
    switch (instrs, stk) {
    | (list{Cst (i), ...rest}, _) =>
        eval(rest, list{i, ...stk})
    | (list{Add, ...rest}, list{a, b, ...stk}) =>
        eval(rest, list{a + b, ...stk})
    | (list{Mul, ...rest}, list{a, b, ...stk}) =>
        eval(rest, list{a * b, ...stk})
    | _ => assert false
    }
}
 */

let rec compile = (expr: expr): list<instr> => {
    switch expr {
    | Cst(i) => list{ Cst(i) }
    | Add(e1, e2) => List.append(List.append(compile(e1), compile(e2)), list{Add})
    | Mul(e1, e2) => List.append(List.append(compile(e1), compile(e2)), list{Mul})
    }
}

