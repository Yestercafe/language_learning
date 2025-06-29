TARGET := build

build:
	zig build --summary all

test:
	zig build test --summary all

clean:
	rm -rf zig-out

purge: clean
	rm -rf .zig-cache

