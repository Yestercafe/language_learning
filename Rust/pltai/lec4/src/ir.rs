use std::collections::HashMap;

use num_traits::ToPrimitive;

use crate::vm::Opcode;

#[derive(Debug)]
pub enum IR {
    Cst(i32),
    Add,
    Mul,
    Var(usize),
    Pop,
    Swap,
    Label(String),
    Call(String, i32),
    Ret(i32),
    IfZero(String),
    Goto(String),
    Exit,
}

pub struct IRProgram {
    program: Vec<IR>,
}

impl IRProgram {
    pub fn new(instructions: Vec<IR>) -> Self {
        Self {
            program: instructions,
        }
    }

    pub fn compile(self) -> Vec<i32> {
        let mut label_addr: HashMap<String, i32> = HashMap::new();
        let mut res: Vec<i32> = vec![];

        let mut pc = 0i32;
        for ir in &self.program {
            match ir {
                IR::Cst(_) => pc += 2,
                IR::Add => pc += 1,
                IR::Mul => pc += 1,
                IR::Var(_) => pc += 2,
                IR::Pop => pc += 1,
                IR::Swap => pc += 1,
                IR::Call(_, _) => pc += 3,
                IR::Ret(_) => pc += 2,
                IR::IfZero(_) => pc += 2,
                IR::Goto(_) => pc += 2,
                IR::Exit => pc += 1,
                IR::Label(label) => {
                    label_addr.insert(label.clone(), pc);
                }
            }
        }

        for ir in self.program {
            match ir {
                IR::Cst(x) => {
                    res.push(Opcode::Cst as i32);
                    res.push(x);
                }
                IR::Add => res.push(Opcode::Add as i32),
                IR::Mul => res.push(Opcode::Mul as i32),
                IR::Var(x) => {
                    res.push(Opcode::Var as i32);
                    res.push(i32::try_from(x).unwrap());
                }
                IR::Pop => res.push(Opcode::Pop as i32),
                IR::Swap => res.push(Opcode::Swap as i32),
                IR::Label(_) => {}
                IR::Call(name, arity) => {
                    res.push(Opcode::Call as i32);
                    res.push(*label_addr.get(&name).unwrap());
                    res.push(arity);
                }
                IR::Ret(arity) => {
                    res.push(Opcode::Ret as i32);
                    res.push(arity);
                }
                IR::IfZero(label) => {
                    res.push(Opcode::IfZero as i32);
                    res.push(*label_addr.get(&label).unwrap());
                }
                IR::Goto(label) => {
                    res.push(Opcode::Goto as i32);
                    res.push(*label_addr.get(&label).unwrap());
                }
                IR::Exit => res.push(Opcode::Exit as i32),
            }
        }
        return res;
    }
}

impl std::fmt::Debug for IRProgram {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut line_number = 1;
        for code in &self.program {
            if let IR::Label(_) = &code {
                f.write_str("\n")?;
            }
            f.write_str(&format!("{:>2}: {:?}\n", line_number, code))?;
            line_number += 1;
        }
        Ok(())
    }
}
