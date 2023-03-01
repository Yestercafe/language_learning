module Expr0 = {
  // Tiny language 0
  type rec expr = 
    | Cst (int) // i
    | Add (expr, expr) // a + b
    | Mul (expr, expr) // a * b

  // Interpreter
  let rec eval = (expr) => {
    switch expr {
    | Cst (i) => i 
    | Add(a,b) => eval (a) + eval (b) 
    | Mul(a,b) => eval (a) * eval (b)
    }
  }
}

let app = List.append

module Instr0 = {

  // Machine Instructions
  type instr =  Cst (int) | Add | Mul

  // Interpreter
  let rec eval = (instrs,stk) => {
      switch (instrs,stk) {
      | (list{ Cst (i), ... rest},_) =>
          eval(rest, list{i,...stk})
      | (list{Add, ... rest}, list{a,b,...stk}) => 
          eval(rest, list{a+b, ...stk})
      | (list{Mul, ... rest}, list{a,b,...stk}) => 
          eval(rest, list{a*b, ...stk})
      | (list{}, list{a,..._stk}) => a
      | _ => assert false
    }
  }
}

// Compile expr0 to machine instructions
let rec compile = (expr: Expr0.expr): list<Instr0.instr> => {
    switch (expr) {
    | Cst(i) => list{ Cst(i) }
    | Add(a, b) => app (app (compile(a), compile(b)), list{ Add })
    | Mul(a, b) => app (app (compile(a), compile(b)), list{ Mul })
    }
}

module Expr1 = {
  // Tiny language 1
  type rec expr = 
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)
    | Var (string)
    | Let (string, expr, expr)

  // Interpreter with an environment
  type env = list<(string, int)>
  let rec eval = (expr, env) => {
    switch expr {
    | Cst (i) => i 
    | Add(a,b) => eval (a, env) + eval (b, env) 
    | Mul(a,b) => eval (a, env) * eval (b, env)
    | Var(x) => List.assoc (x, env)
    | Let(x,e1,e2) => eval(e2, list{(x,eval(e1,env)), ...env})
    }
  }
}

module Nameless = {
  // Tiny language 2
  type rec expr = 
    | Cst (int)
    | Add (expr, expr)
    | Mul (expr, expr)
    | Var (int)
    | Let (expr, expr)

  // Interpreter with a stack
  type s = list<int>
  let rec eval = (expr: expr, s) => {
    switch expr {
      | Cst(i) => i
      | Add(a,b) => eval (a, s) + eval (b, s)
      | Mul(a,b) => eval (a, s) * eval (b, s)
      | Var(n) => List.nth (s, n)
      | Let(e1,e2) => eval(e2, list{eval(e1,s), ...s})
    }
  }
}

// Compile expr with variable names to expr with indices
type cenv = list<string>

let index = (cenv, x) => {
    let rec go = (cenv, n) => {
        switch cenv {
            | list{} => raise (Not_found)
            | list{a, ...rest} => if a == x { n } else {go (rest, n+1)}
        }
    }
    go (cenv, 0)
}

let rec compile1 = (expr: Expr1.expr, cenv) : Nameless.expr => {
    switch expr {
        | Cst(i) => Cst(i)
        | Add(a,b) => Add(compile1(a, cenv), compile1(b, cenv))
        | Mul(a,b) => Mul(compile1(a, cenv), compile1(b, cenv))
        | Var(x) => Var(index(cenv, x))
        | Let(x,e1,e2) => Let(compile1(e1, cenv), compile1(e2, list{x,...cenv}))
    }
}

module Instr1 = {

// Machine Instructions with variables
  type instr =  Cst (int) | Add | Mul | Var (int) | Pop | Swap

  // Homework1 : Interpreter
  let rec eval = (instrs, stk) => {
      switch (instrs, stk) {
      | _ => assert false
    }
  }
}

// Homework2 : Compile Nameless.expr to Machine Instructions
let concatMany = Belt.List.concatMany

module NamelessToStackVM = {
  type sv = Slocal | Stmp
  type senv = list<sv>

  let sindex = (senv, i) => {
      let rec go = (senv, i, acc) => {
          switch senv {
              | list{} => raise (Not_found)
              | list{Slocal, ...rest} => if i == 0 { acc } else {go (rest, i-1, acc+1)}
              | list{Stmp, ...rest} => go (rest, i, acc+1)
          }
      }
      go (senv, i, 0)
  }

  let scompile = (expr) => {
    let rec go = (expr: Nameless.expr, senv: senv) : list<Instr1.instr> => {
      switch expr {
        | Cst(i) => list{ Cst(i) }
        | Var(s) => list{ Var(sindex(senv, s)) }
        | Add(e1, e2) => concatMany([ go(e1, senv), go(e2, list{Stmp,... senv}), list{ Add } ])
        | Mul(e1, e2) => concatMany([ go(e1, senv), go(e2, list{Stmp,... senv}), list{ Mul } ])
        | Let(e1, e2) => concatMany( [go(e1, senv), go(e2, list{Slocal,... senv}), list{ Swap, Pop } ])
      }
    }
    go(expr, list{})
  }
}

let expr1: Expr1.expr = Let("x", Cst(2), Mul(Var("x"), Add(Var("x"), Cst(2))))
Js.log(NamelessToStackVM.scompile(compile1(expr1, list{})))

module ExprToStackMV = {
  type sv = Slocal(string) | Stmp
  type senv = list<sv>

  let sindex = (senv, s) => {
    let rec go = (senv, acc) => {
      switch senv {
        | list{} => raise (Not_found)
        | list{Slocal(x), ...rest} => if x == s { acc } else {go (rest, acc+1)}
        | list{Stmp, ...rest} => go (rest, acc+1)
      }
    }
    go(senv, 0)
  }

  let scompile = (expr) => {
    let rec go = (expr: Expr1.expr, senv: senv) : list<Instr1.instr> => {
      switch expr {
        | Cst(i) => list{ Cst(i) }
        | Var(s) => list{ Var(sindex(senv, s)) }
        | Add(e1, e2) => concatMany([ go(e1, senv), go(e2, list{Stmp,... senv}), list{ Add } ])
        | Mul(e1, e2) => concatMany([ go(e1, senv), go(e2, list{Stmp,... senv}), list{ Mul } ])
        | Let(x, e1, e2) => concatMany( [go(e1, senv), go(e2, list{Slocal(x),... senv}), list{ Swap, Pop } ])
      }
    }
    go(expr, list{})
  }
}