const std = @import("std");

pub fn build(b: *std.Build) void {
    const source_root = "src/";

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Run all tests");

    const Z8a4c1Il_test = b.addTest(.{
        .root_source_file = b.path(source_root ++ "Z8a4c1Il.zig"),
        .target = target,
        .optimize = optimize,
    });
    Z8a4c1Il_test.linkLibC();
    const run_Z8a4c1Il_test = b.addRunArtifact(Z8a4c1Il_test);
    test_step.dependOn(&run_Z8a4c1Il_test.step);

    const linked_list_test = b.addTest(.{
        .root_source_file = b.path(source_root ++ "linked_list.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_linked_list_test = b.addRunArtifact(linked_list_test);
    test_step.dependOn(&run_linked_list_test.step);

    const linked_list_dynamic_lib = b.addSharedLibrary(.{
        .name = "linked_list",
        .root_source_file = b.path(source_root ++ "linked_list.zig"),
        .target = target,
        .optimize = optimize,
        .version = .{.major = 0, .minor = 1, .patch = 0},
    });
    const run_linked_list_dynamic_lib = b.addInstallArtifact(linked_list_dynamic_lib, .{});
    linked_list_dynamic_lib.step.dependOn(&run_linked_list_test.step);

    b.default_step = b.step("build", "Build the project");
    b.default_step.dependOn(&run_linked_list_dynamic_lib.step);
}
