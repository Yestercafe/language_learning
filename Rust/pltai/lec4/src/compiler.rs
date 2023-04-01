use std::collections::HashMap;

use uuid::Uuid;

use crate::ir::{IRProgram, IR};
use crate::syntax::{Expr, Primitive};

#[derive(Debug, Clone)]
pub enum FlatExpr {
    Cst(i32),
    Var(String),
    Let(String, Box<FlatExpr>, Box<FlatExpr>),
    App(String, Vec<FlatExpr>),
    Prim(Primitive, Vec<FlatExpr>),
    If(Box<FlatExpr>, Box<FlatExpr>, Box<FlatExpr>),
}

#[derive(Debug, Clone)]
pub struct Function {
    name: String,
    parameters: Vec<String>,
    body: FlatExpr,
}

impl Function {
    fn new(name: String, parameters: Vec<String>, body: FlatExpr) -> Self {
        Self {
            name,
            parameters,
            body,
        }
    }
}

fn encodePrimitive(prim: Primitive) -> IR {
    match prim {
        Primitive::Add => IR::Add,
        Primitive::Mul => IR::Mul,
    }
}

#[derive(Debug)]
enum VarType {
    VLocal,
    VTemp,
}

#[derive(Debug)]
pub struct Program {
    functions: Vec<Function>,
    naming: Vec<String>,
    var_types: Vec<VarType>,
}

impl Program {
    pub fn new(raw: Expr) -> Self {
        fn go(functions: &mut Vec<Function>, expr: Expr) -> FlatExpr {
            match expr {
                Expr::Cst(x) => FlatExpr::Cst(x),
                Expr::Var(v) => FlatExpr::Var(v),
                Expr::Let(name, val, next) => FlatExpr::Let(
                    name,
                    Box::new(go(functions, *val)),
                    Box::new(go(functions, *next)),
                ),
                Expr::App(name, args) => {
                    let mut flat_args: Vec<FlatExpr> = vec![];
                    for arg in args {
                        flat_args.push(go(functions, arg));
                    }
                    FlatExpr::App(name, flat_args)
                }
                Expr::Prim(prim, args) => {
                    let mut flat_args: Vec<FlatExpr> = vec![];
                    for arg in args {
                        flat_args.push(go(functions, arg));
                    }
                    FlatExpr::Prim(prim, flat_args)
                }
                Expr::If(cond, conseq, alt) => FlatExpr::If(
                    Box::new(go(functions, *cond)),
                    Box::new(go(functions, *conseq)),
                    Box::new(go(functions, *alt)),
                ),
                Expr::Letfn(name, params, body, next) => {
                    let fun = Function::new(name, params, go(functions, *body));
                    functions.push(fun);
                    go(functions, *next)
                }
            }
        }

        let mut functions: Vec<Function> = vec![];
        let main_body = go(&mut functions, raw);
        functions.push(Function::new("main".into(), vec![], main_body));
        Self {
            functions,
            naming: vec![],
            var_types: vec![],
        }
    }

    fn compile_expr(&self, expr: FlatExpr) -> Vec<IR> {
        match expr {
            FlatExpr::Cst(x) => {
                vec![IR::Cst(x)]
            }
            FlatExpr::Var(x) => {
                vec![IR::Var(x)]
            }
            FlatExpr::Let(x, val, next) => {
                let mut seq = self.compile_expr(*val);
                seq.extend(self.compile_expr(*next));
                seq.extend(vec![IR::Swap, IR::Pop]);
                seq
            }
            FlatExpr::Prim(prim, args) => {
                let mut seq: Vec<IR> = vec![];
                for arg in args {
                    seq.extend(self.compile_expr(arg));
                }
                seq.push(encodePrimitive(prim));
                seq
            }
            FlatExpr::App(name, args) => {
                let arity = args.len();
                let mut seq = self.compile_exprs(args);
                seq.push(IR::Call(name, i32::try_from(arity).unwrap()));
                seq
            }
            FlatExpr::If(cond, conseq, alt) => {
                let if_not_label = Uuid::new_v4().to_string();
                let end_if_label = Uuid::new_v4().to_string();
                let mut seq: Vec<IR> = vec![];
                seq.extend(self.compile_expr(*cond));
                seq.push(IR::IfZero(if_not_label.clone()));
                seq.extend(self.compile_expr(*conseq));
                seq.extend(vec![
                    IR::Goto(end_if_label.clone()),
                    IR::Label(if_not_label.clone()),
                ]);
                seq.extend(self.compile_expr(*alt));
                seq.push(IR::Label(end_if_label.clone()));
                seq
            }
        }
    }

    fn compile_exprs(&self, exprs: Vec<FlatExpr>) -> Vec<IR> {
        let mut seq: Vec<IR> = vec![];
        for expr in exprs {
            seq.extend(self.compile_expr(expr));
        }
        seq
    }

    pub fn compile(self) -> IRProgram {
        let mut arity_table: HashMap<String, i32> = HashMap::new();

        let mut res: Vec<IR> = vec![IR::Goto("main".into()), IR::Exit];

        for function in &self.functions {
            arity_table.insert(
                function.name.clone(),
                i32::try_from(function.parameters.len()).unwrap(),
            );
            res.push(IR::Label(function.name.clone()));
            res.extend(self.compile_expr(function.body.clone()));
            res.push(IR::Ret(i32::try_from(function.parameters.len()).unwrap()));
        }

        IRProgram::new(res)
    }
}
