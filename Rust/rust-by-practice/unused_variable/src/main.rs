fn main() {
    f1();
    f2();
    println!("hello world");
}

#[allow(unused_variables)]
fn f1() {
    let x = 1;
}

fn f2() {
    let _x = 1;
}
