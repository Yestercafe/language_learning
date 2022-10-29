type instr = Cst (int) | Add | Mul  // no recursive
type instrs = list <instr>
type operand = int
type stack = list <operand>

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
