struct LinkedListNode {
mut:
	val int
	next &LinkedListNode
}

struct LinkedList {
mut:
	len usize
	sentinel &LinkedListNode
}

fn new_linked_list() LinkedList {
	return LinkedList {
		0,
		&LinkedListNode {0, unsafe { nil }}
	}
}

fn (mut self LinkedList) clear() {
	self.len = 0
	self.sentinel = unsafe { nil }
}

fn (self LinkedList) size() usize {
	return self.len
}

fn (mut self LinkedList) push_front(val int) {
	old_head := self.sentinel.next
	self.sentinel.next = &LinkedListNode{val, old_head}
	self.len += 1
}

fn (mut self LinkedList) push_back(val int) {
	mut prev, mut curr := self.sentinel, self.sentinel.next
	unsafe {
		for curr != nil {
			prev = curr
			curr = curr.next
		}
		prev.next = &LinkedListNode{val, nil}
	}
	self.len += 1
}

fn (mut self LinkedList) pop_front() {
	if self.len == 0 { return }
	self.sentinel.next = self.sentinel.next.next
	self.len -= 1
}

fn (mut self LinkedList) pop_back() {
	if self.len == 0 { return }
	mut prev, mut curr := self.sentinel, self.sentinel.next
	unsafe {
		for curr.next != nil {
			prev = curr
			curr = curr.next
		}
		prev.next = nil
	}
	self.len -= 1
}

fn (self LinkedList) traverse() {
	mut ptr := self.sentinel.next
	unsafe {
		for ptr != nil {
			print('${ptr.val} ')
			ptr = ptr.next
		}
	}
	println('')
}

fn main() {
	mut lst := new_linked_list()
	for i in 0..6 {
		lst.push_back(i)
	}

	lst.pop_front()
	lst.pop_back()

	lst.traverse()
}
