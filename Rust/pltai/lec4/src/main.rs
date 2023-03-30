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

/*
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
