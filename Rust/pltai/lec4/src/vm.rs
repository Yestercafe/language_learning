use num_derive::FromPrimitive;
use num_traits::FromPrimitive;

#[derive(FromPrimitive)]
enum Opcode {
    Cst = 0,
    Add = 1,
    Mul = 2,
    Var = 3,
    Pop = 4,
    Swap = 5,
    Call = 6,
    Ret = 7,
    IfZero = 8,
    Goto = 9,
    Exit = 10,
}

#[derive(Debug)]
pub struct VM {
    code: Vec<i32>,
    rts: Vec<i32>,  // Runtime Stack
    pc: usize,
    halt: bool,
    debug_mode: bool,
}

impl VM {
    pub fn new(code: Vec<i32>, debug_mode: bool) -> VM {
        VM {
            code,
            rts: vec![],
            pc: 0,
            halt: false,
            debug_mode
        }
    }

    fn onestep(&mut self) {
        if self.halt {
            println!("The virtual machine halted.");
            return
        }
        match FromPrimitive::from_i32(self.code[self.pc]) {
            Some(Opcode::Cst) => {
                let i = self.code[self.pc + 1];
                self.rts.push(i);
                self.pc += 2;
            },
            Some(Opcode::Add) => {
                let op2 = self.rts.pop().unwrap();
                let op1 = self.rts.pop().unwrap();
                self.rts.push(op1 + op2);
                self.pc += 1;
            },
            Some(Opcode::Mul) => {
                let op2 = self.rts.pop().unwrap();
                let op1 = self.rts.pop().unwrap();
                self.rts.push(op1 * op2);
                self.pc += 1
            },
            Some(Opcode::Var) => {
                let i = self.code[self.pc + 1];
                self.rts.push(self.rts[usize::try_from(i).unwrap()]);
                self.pc += 2;
            },
            Some(Opcode::Pop) => {
                self.rts.pop();
                self.pc += 1;
            },
            Some(Opcode::Swap) => {
                let op2 = self.rts.pop().unwrap();
                let op1 = self.rts.pop().unwrap();
                self.rts.push(op2);
                self.rts.push(op1);
            },
            Some(Opcode::Call) => {
                let callee_addr = self.code[self.pc + 1];
                // self.pc now is caller_addr
                let arity = self.code[self.pc + 2];
                let mut args = vec![];
                for _ in 0..arity {
                    args.push(self.rts.pop().unwrap());
                }
                self.rts.push(i32::try_from(self.pc + 3).unwrap());   // return addr
                for arg in args {
                    self.rts.push(arg);
                }
                self.pc = usize::try_from(callee_addr).unwrap();
            },
            Some(Opcode::Ret) => {
                let arity = self.code[self.pc + 1];
                let return_value = self.rts.pop().unwrap();
                for _ in 0..arity { self.rts.pop(); }
                let return_addr = self.rts.pop().unwrap();
                self.rts.push(return_value);
                self.pc = usize::try_from(return_addr).unwrap();
            },
            Some(Opcode::IfZero) => {
                let conseq_addr = self.code[self.pc + 1];
                let rts_top = self.rts.pop().unwrap();
                if rts_top == 0 {
                    self.pc = usize::try_from(conseq_addr).unwrap();
                } else {
                    self.pc += 2;
                }
            },
            Some(Opcode::Goto) => {
                let target_addr = self.code[self.pc + 1];
                self.pc = usize::try_from(target_addr).unwrap();
            },
            Some(Opcode::Exit) => {
                self.halt = true;
            },
            None => {
                panic!("Read wrong opcode!")
            }
        }
    }

    pub fn run(&mut self) {
        println!("Code seq: {:?}", self.code);
        while !self.halt {
            if self.debug_mode {
                println!("Current pc: {}, rts: {:?}", self.pc, self.rts);
            }
            self.onestep();
        }
        println!("Halt. pc: {}, rts: {:?}", self.pc, self.rts);
    }
}
