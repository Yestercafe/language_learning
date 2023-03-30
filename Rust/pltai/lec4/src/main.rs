mod vm;
use vm::VM;

fn main() {
    let codes: Vec<i32> = vec![
        0, 1,           // Cst 1
        0, 2,           // Cst 2
        0, 3,           // Cst 3
        6, 11, 3,       // Call 11(Var 0) 3
        9, 21,          // Goto 21(Exit)
        3, 3,           // Var 4
        3, 2,           // Var 3
        1,              // Add
        3, 1,           // Var 2
        1,              // Add
        7, 3,           // Ret 3
        10,             // Exit
    ];
    let mut new_vm = VM::new(codes, true);
    new_vm.run()
}
