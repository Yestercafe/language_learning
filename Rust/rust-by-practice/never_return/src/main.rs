fn main() {
    // never_return1();
    // never_return2();
    // never_return3();
    println!("Hello, world!");
}

fn never_return1() -> ! {
    panic!("never return")
}

use std::thread;
use std::time;
fn never_return2() -> ! {
    loop {
        println!("I return nothing!");
        thread::sleep(time::Duration::from_secs(1))
    }
}

fn never_return3() -> ! {
    unimplemented!()
}
