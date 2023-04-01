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

#[derive(Debug, Eq, PartialEq)]
enum VarType {
    VLocal,
    VTemp,
}

#[derive(Debug)]
pub struct Program {
    functions: Vec<Function>,
    naming: Vec<String>,
    var_types: Vec<VarType>,
    cnt_local: usize,
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
            cnt_local: 0,
        }
    }

    fn push_local(&mut self, name: String) {
        self.naming.push(name);
        self.var_types.push(VarType::VLocal);
        self.cnt_local += 1;
    }

    fn push_temp(&mut self) {
        self.naming.push("".into());
        self.var_types.push(VarType::VTemp);
    }

    fn pop_var(&mut self) -> (String, VarType) {
        let name = self.naming.pop().unwrap();
        if let Some(VarType::VLocal) = self.var_types.pop() {
            self.cnt_local -= 1;
            (name, VarType::VLocal)
        } else {
            (name, VarType::VTemp)
        }
    }

    fn get_index_of_var(&mut self, target: String) -> usize {
        let mut actual_pos = 0usize;
        let l = self.naming.len();
        for i in (0..l).rev() {
            if self.naming[i] == target {
                return actual_pos;
            }
            actual_pos += 1;
        }
        panic!("Can't find var {}", target)
    }

    fn compile_expr(&mut self, expr: FlatExpr) -> Vec<IR> {
        match expr {
            FlatExpr::Cst(x) => {
                vec![IR::Cst(x)]
            }
            FlatExpr::Var(x) => {
                vec![IR::Var(self.get_index_of_var(x))]
            }
            FlatExpr::Let(x, val, next) => {
                let mut seq = self.compile_expr(*val);
                self.push_local(x);
                seq.extend(self.compile_expr(*next));
                self.pop_var();
                seq.extend(vec![IR::Swap, IR::Pop]);
                seq
            }
            FlatExpr::Prim(prim, args) => {
                let mut seq: Vec<IR> = vec![];
                let l = args.len();
                for arg in args {
                    seq.extend(self.compile_expr(arg));
                    self.push_temp();
                }
                for _ in 0..l {
                    self.pop_var();
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

    fn compile_exprs(&mut self, exprs: Vec<FlatExpr>) -> Vec<IR> {
        let mut seq: Vec<IR> = vec![];
        let l = exprs.len();
        for expr in exprs {
            seq.extend(self.compile_expr(expr));
            self.push_temp();
        }
        for _ in 0..l {
            self.pop_var();
        }
        seq
    }

    pub fn compile(&mut self) -> IRProgram {
        let mut res: Vec<IR> = vec![IR::Call("main".into(), 0), IR::Exit];
        let functions = self.functions.clone();

        for function in functions {
            let l = function.parameters.len();
            res.push(IR::Label(function.name.clone()));
            for param in function.parameters {
                self.push_local(param);
            }
            res.extend(self.compile_expr(function.body));
            for _ in 0..l {
                self.pop_var();
            }
            res.push(IR::Ret(i32::try_from(l).unwrap()));
        }

        IRProgram::new(res)
    }
}
