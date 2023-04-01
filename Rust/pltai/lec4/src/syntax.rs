#[derive(Debug, Clone)]
pub enum Primitive {
    Add,
    Mul,
}

#[derive(Debug, Clone)]
pub enum Expr {
    Cst(i32),
    Var(String),
    Let(String, Box<Expr>, Box<Expr>),
    Letfn(String, Vec<String>, Box<Expr>, Box<Expr>),
    App(String, Vec<Expr>),
    Prim(Primitive, Vec<Expr>),
    If(Box<Expr>, Box<Expr>, Box<Expr>),
}
