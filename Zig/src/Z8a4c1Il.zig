const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;

test "comptime vars" {
    comptime var y: i32 = 1;

    y += 1;

    if (y != 2) {
        @compileError("wrong y value");
    }
}

test "slice" {
    const array = [_]i32{ 1, 2, 3, 4 };
    const runtime_zero: usize = 0;
    _ = &runtime_zero;
    const slice = array[runtime_zero..array.len];

    for (slice, 0..) |val, i| {
        print("{}: {}\n", .{ i, val });
    }

    const str = "Hello, world\n";
    _ = std.c.printf(str);

    print("str.len: {}\n", .{str.len});

    const str_slice = str[runtime_zero..str.len];
    for (str_slice) |c| {
        print("{}\n", .{c});
    }
}
