// cmake_example
//
// by Tobias Simetsreiter <dasimmet@gmail.com>
//

const std = @import("std");
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const cmake_import = b.lazyImport(@This(), "cmake");
    const verbose_cmake = b.option(
        bool,
        "verbose-cmake",
        "print cmake ouptut",
    ) orelse false;

    if (b.lazyDependency("sqlite3_cmake", .{
        .target = target,
        .optimize = optimize,
    })) |sqlite3_dep| {
        if (cmake_import) |cmake| {
            const cmake_sqlite3_step = cmake.addCMakeStep(b, .{
                .target = target,
                .name = "cmake sqlite3",
                .source_dir = sqlite3_dep.path(""),
                .verbose = verbose_cmake,
                .defines = &.{
                    .{ "CMAKE_BUILD_TYPE", if (optimize == .Debug) "Debug" else "Release" },
                    .{ "CMAKE_EXE_LINKER_FLAGS", "-s" }, // static executable builds
                },
            });
            const sqlite3_install = cmake_sqlite3_step.install(b, "");
            b.getInstallStep().dependOn(&sqlite3_install.step);
        }
    }

    if (b.lazyDependency("llvm", .{
        .target = target,
        .optimize = optimize,
    })) |llvm_dep| {
        if (cmake_import) |cmake| {
            const cmake_sqlite3_step = cmake.addCMakeStep(b, .{
                .target = target,
                .name = "cmake sqlite3",
                .source_dir = llvm_dep.path("llvm"),
                .verbose = verbose_cmake,
                .defines = &.{
                    .{ "CMAKE_BUILD_TYPE", if (optimize == .Debug) "Debug" else "Release" },
                    .{ "CMAKE_EXE_LINKER_FLAGS", "-s" }, // static executable builds
                },
            });
            const sqlite3_install = cmake_sqlite3_step.install(b, "");
            b.getInstallStep().dependOn(&sqlite3_install.step);
        }
    }
}
