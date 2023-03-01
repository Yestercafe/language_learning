#[derive(Clone, Debug)]
struct ListNode {
    val: i32,
    next: Option<Box<ListNode>>,
}

#[derive(Debug)]
struct MyLinkedList {
    head: Option<Box<ListNode>>,
    size: i32,
}

impl MyLinkedList {

    fn new() -> Self {
        MyLinkedList {
            head: None,
            size: 0,
        }
    }
    
    fn get(&self, index: i32) -> i32 {
        if index < 0 || index >= self.size {
            return -1;
        }
        
        let mut itr = &self.head;
        for _ in 0..index {
            if let Some(ref t) = itr {
                itr = &t.next;
            } else {
                panic!();
            }
        }

        if let Some(ref t) = itr {
            t.val
        } else {
            panic!()
        }
    }
    
    fn add_at_head(&mut self, val: i32) {
        let next = self.head.clone();
        self.head = Some(Box::new(ListNode { val, next }));
    }
    
    fn add_at_tail(&mut self, val: i32) {
        match self.head {
            None => self.add_at_head(val),
            _ => {
                let mut itr = &self.head;
                loop {
                    if let Some(ref t) = itr {
                        if let Some(_) = &t.next {
                            ;
                        } else {
                            break;
                        }
                    }
                }
                
                if let Some(ref mut t) = mut itr {
                    t.next = Some(Box::new(ListNode { val, next: None }));
                }
            }
        }

    }
    
    fn add_at_index(&mut self, index: i32, val: i32) {

    }
    
    fn delete_at_index(&mut self, index: i32) {

    }
}

fn main() {
    let mut linkedList = MyLinkedList::new();
    linkedList.add_at_head(1);
    linkedList.add_at_tail(3);
    linkedList.add_at_index(1,2);               //链表变为1-> 2-> 3
    let ref_1 = linkedList.get(1);            //返回2
    linkedList.delete_at_index(1);              //现在链表是1-> 3
    let ref_2 = linkedList.get(1);            //返回3
    println!("{} {}", ref_1, ref_2);
}
