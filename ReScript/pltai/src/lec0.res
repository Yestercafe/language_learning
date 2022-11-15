let __nodebug = false

let separate = (info: string) => {
    Js.log("")
    Js.log(Js.String.repeat(2 + Js.String.length(info) + 2, "-"))
    Js.log("| " ++ info)
    Js.log(Js.String.repeat(2 + Js.String.length(info) + 2, "-"))
}

module Expr0 = {
    type rec expr =
        | Cst(int)
        | Add(expr, expr)
        | Mul(expr, expr)

    let rec eval = (expr: expr) => {
        switch expr {
        | Cst(i) => i
        | Add(a, b) => eval(a) + eval(b)
        | Mul(a, b) => eval(a) * eval(b)
        }
    }
}

separate("Expr0: (1 + 2) * 3 == 9")
let expr0: Expr0.expr = Mul(Add(Cst(1), Cst(2)), Cst(3))
Js.log(Expr0.eval(expr0))

module Instr0 = {
    type instr   = Cst(int) | Add | Mul
    type instrs  = list<instr>
    type operand = int
    type stack   = list<operand>

    let rec eval = (instrs: instrs, stack: stack) => {
        if !__nodebug {
            Js.log2("instrs:", instrs)
            Js.log2("stack:", stack)
            Js.log2("len of stack:", Belt.List.length(stack))
        }
        switch (instrs, stack) {
        | (list{Cst(i), ...rest}, s) =>
            eval(rest, list{i, ...s})
        | (list{Add, ...rest}, list{a, b, ...s}) =>
            eval(rest, list{a + b, ...s})
        | (list{Mul, ...rest}, list{a, b, ...s}) =>
            eval(rest, list{a * b, ...s})
        | (list{}, list{top, ...rest}) => {
            assert (0 == Belt.List.length(rest))
            top
        }
        | _ => assert false
        }
    }
}

separate("Instr0: (1 + 2) * 3 == 9")
// Notice: expr `a + b`, the `a` is pushed before `b`
let instr0: Instr0.instrs = list{Cst(1), Cst(2), Add, Cst(3), Mul}
Js.log(Instr0.eval(instr0, list{}));

module Expr0_Instr0 = {
    // hw2
    let rec compile = (expr: Expr0.expr): Instr0.instrs => {
        switch expr {
        | Cst(i) => list{ Cst(i) }
        | Add(a, b) => List.append(List.append(compile(a), compile(b)), list{ Add })
        | Mul(a, b) => List.append(List.append(compile(a), compile(b)), list{ Mul })
        }
    }
}

separate("Compile Expr0 -> Instr0: (1 + 2) * 3 == 9")
Js.log(Instr0.eval(Expr0_Instr0.compile(expr0), list{}))

module Expr1 = {
    type rec expr =
        | Cst(int)
        | Add(expr, expr)
        | Mul(expr, expr)
        | Var(string)
        | Let(string, expr, expr)

    type env = list<(string, int)>

    let rec eval = (expr: expr, env: env) => {
        switch expr {
        | Cst(x) => x
        | Add(a, b) => eval(a, env) + eval(b, env)
        | Mul(a, b) => eval(a, env) * eval(b, env)
        // List.assoc(x, env): get the corresponding value in env(which type is like [(key, value)]) where key is `name`
        | Var(name) => List.assoc(name, env)
        | Let(name, val, expr) => eval(expr, list{(name, eval(val, env)), ...env})
        }
    }
}

separate("Expr1: let x = 2 in x * (x + 3) == 10")
let expr1: Expr1.expr = Let("x", Cst(2), Mul(Var("x"), Add(Var("x"), Cst(2))))
Js.log(Expr1.eval(expr1, list{}))

module Nameless = {
    type rec expr =
        | Cst(int)
        | Add(expr, expr)
        | Mul(expr, expr)
        | Var(int)
        | Let(expr, expr)

    type env = list<int>
    let rec eval = (expr: expr, env: env) => {
        switch expr {
        | Cst(x) => x
        | Add(a, b) => eval(a, env) + eval(b, env)
        | Mul(a, b) => eval(a, env) * eval(b, env)
        | Var(i) => List.nth(env, i)
        | Let(val, expr) => eval(expr, list{eval(val, env), ...env})
        }
    }
}

separate("Nameless: let _0 = 2 in _0 * (_0 + 3) == 10")
let nameless: Nameless.expr = Let(Cst(2), Mul(Var(0), Add(Var(0), Cst(2))))
Js.log(Nameless.eval(nameless, list{}))

module Expr1_Nameless = {
    type nameList = list<string>

    let getIndexOfNameInList = (list: nameList, name: string) => {
        let rec aux = (list: nameList, idx: int) => {
            switch list {
            | list{x, ...rest} => {
                if x == name {
                    idx
                } else {
                    aux(rest, idx + 1)
                }
            }
            | list{} => assert false
            }
        }
        aux(list, 0)
    }

    // This is a trick which I used usually when I was implementing my version of C++ STL,
    // and the function named `aux` in `getIndexOfNameInList` above is also this trick called auxiliary functions
    let compile = (expr: Expr1.expr): Nameless.expr => {
        let rec compile = (expr: Expr1.expr, nameList: nameList): Nameless.expr => {
            switch expr {
            | Cst(x) => Cst(x)
            | Add(a, b) => Add(compile(a, nameList), compile(b, nameList))
            | Mul(a, b) => Mul(compile(a, nameList), compile(b, nameList))
            | Var(name) => Var(getIndexOfNameInList(nameList, name))
            | Let(name, val, expr) => Let(compile(val, nameList), compile(expr, list{name, ...nameList}))
            }
        }
        compile(expr, list{})
    }
}

separate("Compile Expr1 to Nameless: let x = 2 in x * (x + 3) == 10")
Js.log(Nameless.eval(Expr1_Nameless.compile(expr1), list{}))

// hw3-1
module Instr1 = {
    type instr   = Cst(int) | Add | Mul | Var(int) | Swap | Pop
    type instrs  = list<instr>
    type operand = int
    type stack   = list<operand>

    let rec eval = (instrs: instrs, stack: stack) => {
        if !__nodebug {
            Js.log2("instrs:", instrs)
            Js.log2("stack:", stack)
            Js.log2("len of stack:", Belt.List.length(stack))
        }
        switch (instrs, stack) {
        | (list{Cst(i), ...rest}, s) =>
            eval(rest, list{i, ...s})
        | (list{Add, ...rest}, list{a, b, ...s}) =>
            eval(rest, list{a + b, ...s})
        | (list{Mul, ...rest}, list{a, b, ...s}) =>
            eval(rest, list{a * b, ...s})
        | (list{Var(i), ...rest}, s) =>
            eval(rest, list{List.nth(s, i), ...s})
        | (list{Swap, ...rest}, list{a, b, ...s}) =>
            eval(rest, list{b, a, ...s})
        | (list{Pop, ...rest}, list{_, ...s}) =>
            eval(rest, s)
        | (list{}, list{top, ...rest}) => {
            // assert (0 == Belt.List.length(rest))
            Js.log("exec here")
            top
        }
        | _ => assert false
        }
    }
}

separate("Instr1: let x = 2 in x + x == 4")
let instr1: Instr1.instrs = list{Cst(2), Var(0), Var(1), Add, Swap, Pop}
Js.log(Instr1.eval(instr1, list{}))

// hw3-2
module Nameless_Instr1 = {
    type varType = VTemp | VLocal

    let findIndexInCombinedStack = (stack: list<varType>, i: int) => {
        let rec aux = (stack: list<varType>, ri: int, ii: int) => {
            switch stack {
            | list{VTemp, ...rest} => aux(rest, ri + 1, ii)
            | list{VLocal, ...rest} => {
                if ii == i {
                    ri
                } else {
                    aux(rest, ri + 1, ii + 1)
                }
            }
            | list{} => assert false
            }
        }
        aux(stack, 0, 0)
    }

    let compile = (expr: Nameless.expr): Instr1.instrs => {
        let rec compile = (expr: Nameless.expr, varTypes: list<varType>): list<Instr1.instr> => {
            if !__nodebug {
                Js.log2("expr:", expr)
                Js.log2("varTypes:", varTypes)
            }
            let ret: Instr1.instrs = switch expr {
            | Cst(x) => list{Cst(x)}
            | Add(a, b) => List.append(List.append(compile(a, varTypes), compile(b, list{VTemp, ...varTypes})), list{Add})
            | Mul(a, b) => List.append(List.append(compile(a, varTypes), compile(b, list{VTemp, ...varTypes})), list{Mul})
            | Var(i) => list{Var(findIndexInCombinedStack(varTypes, i))}
            | Let(val, expr) => List.append(List.append(compile(val, varTypes), compile(expr, list{VLocal, ...varTypes})), list{Swap, Pop})
            }
            if !__nodebug {
                Js.log2("ret:", ret)
            }
            ret
        }
        compile(expr, list{})
    }
}

// let nameless: Nameless.expr = Let(Cst(2), Mul(Var(0), Add(Var(0), Cst(2))))
separate("Compile Nameless -> Instr1: let _0 = 2 in _0 * (_0 + 3) == 10")
Js.log(Nameless_Instr1.compile(nameless))  // problem here
