mod front_of_house;

fn main() {
    assert_eq!(hello_package::hosting::seat_at_table(), "sit down please");
    assert_eq!(hello_package::eat_at_restaurant(),"yummy yummy!");

    println!("success!")
}