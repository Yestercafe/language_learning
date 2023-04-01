mod compiler;
mod ir;
mod syntax;
mod vm;
use compiler::Program;
use syntax::{
    Expr::{App, Cst, If, Let, Letfn, Prim, Var},
    Primitive::{Add, Mul},
};
use vm::VM;

fn main() {
    let mut program = Program::new(Let(
        "a".into(),
        Box::new(Cst(2)),
        Box::new(Letfn(
            "cube".into(),
            vec!["x".into()],
            Box::new(Letfn(
                "square".into(),
                vec!["x".into()],
                Box::new(Prim(Mul, vec![Var("x".into()), Var("x".into())])),
                Box::new(Prim(
                    Mul,
                    vec![App("square".into(), vec![Var("x".into())]), Var("x".into())],
                )),
            )),
            Box::new(App("cube".into(), vec![Var("a".into())])),
        )),
    ));
    println!("{:?}", program);

    let ir = program.compile();
    println!("{:?}", ir);

    let machine_codes = ir.compile();
    println!("{:?}", machine_codes);

    let mut vm = VM::new(machine_codes, true);
    vm.run()
}

/*
let codes: Vec<i32> = vec![
    0, 1, // Cst 1
    0, 2, // Cst 2
    0, 3, // Cst 3
    6, 11, 3, // Call 11(Var 0) 3
    9, 21, // Goto 21(Exit)
    3, 3, // Var 4
    3, 2, // Var 3
    1, // Add
    3, 1, // Var 2
    1, // Add
    7, 3,  // Ret 3
    10, // Exit
];

Result:
Code seq: [0, 1, 0, 2, 0, 3, 6, 11, 3, 9, 21, 3, 3, 3, 2, 1, 3, 1, 1, 7, 3, 10]
Current pc: 0, rts: []
Current pc: 2, rts: [1]
Current pc: 4, rts: [1, 2]
Current pc: 6, rts: [1, 2, 3]
Current pc: 11, rts: [9, 3, 2, 1]
Current pc: 13, rts: [9, 3, 2, 1, 1]
Current pc: 15, rts: [9, 3, 2, 1, 1, 2]
Current pc: 16, rts: [9, 3, 2, 1, 3]
Current pc: 18, rts: [9, 3, 2, 1, 3, 3]
Current pc: 19, rts: [9, 3, 2, 1, 6]
Current pc: 9, rts: [6]
Current pc: 21, rts: [6]
Halt. pc: 21, rts: [6]
 */
