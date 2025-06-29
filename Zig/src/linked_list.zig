const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;
const gpa = std.heap.page_allocator;

pub fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,

            pub fn init(data: T) Node {
                return Node{
                    .prev = null,
                    .next = null,
                    .data = data,
                };
            }
        };

        head: ?*Node,
        tail: ?*Node,
        len: usize,

        pub fn init() Self {
            return Self{
                .head = null,
                .tail = null,
                .len = 0,
            };
        }

        pub fn deinit(self: *Self) void {
            while (self.len != 0) {
                _ = self.pop_back();
            }
        }

        pub fn get_len(self: Self) usize {
            return self.len;
        }

        pub fn push_back(self: *Self, n: T) !void {
            var new_node = try gpa.create(Node);
            new_node.* = Node.init(n);

            if (self.len == 0) {
                self.head = new_node;
            } else {
                self.tail.?.next = new_node;
                new_node.prev = self.tail;
            }
            self.tail = new_node;

            self.len += 1;
        }

        pub fn push_front(self: *Self, n: T) !void {
            var new_node = try gpa.create(Node);
            new_node.* = Node.init(n);

            if (self.len == 0) {
                self.tail = new_node;
            } else {
                self.head.?.prev = new_node;
                new_node.next = self.head;
            }

            self.head = new_node;

            self.len += 1;
        }

        pub fn pop_back(self: *Self) ?T {
            if (self.len == 0) {
                return null;
            }

            const data = self.tail.?.data;
            const tail_prev = self.tail.?.prev;
            gpa.destroy(self.tail.?);

            if (tail_prev) |defer_tail_prev| {
                self.tail = defer_tail_prev;
                defer_tail_prev.next = null;
            } else {
                self.head = null;
                self.tail = null;
            }

            self.len -= 1;

            return data;
        }

        pub fn pop_front(self: *Self) ?T {
            if (self.len == 0) {
                return null;
            }

            const data = self.head.?.data;
            const head_next = self.head.?.next;
            gpa.destroy(self.head.?);

            if (head_next) |defer_head_next| {
                self.head = defer_head_next;
                defer_head_next.prev = null;
            } else {
                self.head = null;
                self.tail = null;
            }

            self.len -= 1;

            return data;
        }

        pub fn travel(self: Self) void {
            var iter = self.head;
            print("list:", .{});
            while (iter) |defer_iter| {
                print(" {}", .{defer_iter.data});
                iter = defer_iter.next;
            }
            print("\n", .{});
        }

        pub fn to_array(self: Self) !std.ArrayList(T) {
            var iter = self.head;
            var array_list = std.ArrayList(T).init(gpa);
            while (iter) |defer_iter| {
                try array_list.append(defer_iter.data);
                iter = defer_iter.next;
            }
            return array_list;
        }
    };
}

fn aux_compare_arraylist_and_array(comptime T: type, a: std.ArrayList(T), b: []const T) bool {
    if (a.items.len != b.len) {
        return false;
    }

    for (a.items, 0..) |item, i| {
        if (item != b[i]) {
            return false;
        }
    }

    return true;
}

test "linked list" {
    var list = LinkedList(i32).init();
    defer list.deinit();
    for (0..5) |n| {
        try list.push_back(@intCast(n + 1));
    }
    var list2arr = try list.to_array();
    try expect(aux_compare_arraylist_and_array(i32, list2arr, &[_]i32{1, 2, 3, 4, 5}));
    list.travel();
    list2arr.deinit();

    var popped = list.pop_back();
    if (popped) |defer_popped| {
        print("popped: {}\n", .{defer_popped});
    }
    list2arr = try list.to_array();
    try expect(aux_compare_arraylist_and_array(i32, list2arr, &[_]i32{1, 2, 3, 4}));
    list.travel();
    list2arr.deinit();

    popped = list.pop_front();
    if (popped) |defer_popped| {
        print("popped: {}\n", .{defer_popped});
    }
    list2arr = try list.to_array();
    try expect(aux_compare_arraylist_and_array(i32, list2arr, &[_]i32{2, 3, 4}));
    list.travel();
    list2arr.deinit();

    for (5..8) |n| {
        try list.push_front(@intCast(n + 1));
    }
    list2arr = try list.to_array();
    try expect(aux_compare_arraylist_and_array(i32, list2arr, &[_]i32{8, 7, 6, 2, 3, 4}));
    list.travel();
    list2arr.deinit();
}

