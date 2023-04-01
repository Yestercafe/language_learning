#[derive(Debug)]
pub enum IR {
    Cst(i32),
    Add,
    Mul,
    Var(String),
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
