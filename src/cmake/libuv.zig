const LibUV = @This();
const Self = LibUV;
const std = @import("std");
const cmake = @import("../cmake.zig");

pub fn build(b: *std.Build, opt: anytype) *std.Build.Step.Compile {
    const libuv = b.addStaticLibrary(.{
        .name = "uv",
        .target = opt.target,
        .optimize = opt.optimize,
    });
    libuv.linkLibC();
    cmake.addMacros(b, libuv);
    if (libuv.rootModuleTarget().os.tag == .windows) {
        libuv.addCSourceFiles(.{
            .files = LibUV.C_WIN_SOURCES,
            .root = b.path("Utilities/cmlibuv/src"),
            .flags = &.{"-D_GNU_SOURCE"},
        });
        libuv.addCSourceFiles(.{
            .files = LibUV.WIN_C_SOURCES,
            .root = b.path("Utilities/cmlibuv/src/win"),
            .flags = &.{"-D_GNU_SOURCE"},
        });
        libuv.addIncludePath(b.path("Utilities/cmlibuv/src/win"));
        libuv.root_module.addCMacro("WIN32_LEAN_AND_MEAN", "");
        libuv.root_module.addCMacro("_WIN32_WINNT", "0x0600");
    } else {
        libuv.addCSourceFiles(.{
            .files = LibUV.C_SOURCES,
            .root = b.path("Utilities/cmlibuv/src"),
            .flags = &.{"-D_GNU_SOURCE"},
        });
        libuv.addCSourceFiles(.{
            .files = LibUV.UNIX_C_SOURCES,
            .root = b.path("Utilities/cmlibuv/src/unix"),
            .flags = &.{"-D_GNU_SOURCE"},
        });
        libuv.addIncludePath(b.path("Utilities/cmlibuv/src/unix"));
    }
    libuv.addIncludePath(opt.generated_headers);
    inline for (Self.IncludePaths) |p| {
        libuv.addIncludePath(b.path(p));
    }
    return libuv;
}
pub const IncludePaths = &.{
    "Utilities/cmlibuv/include",
    "Utilities/cmlibuv/src",
};

pub const WIN_C_SOURCES = &.{
    "async.c",
    "core.c",
    "detect-wakeup.c",
    "dl.c",
    "error.c",
    "fs.c",
    "fs-event.c",
    "getaddrinfo.c",
    "getnameinfo.c",
    "handle.c",
    "loop-watcher.c",
    "pipe.c",
    "poll.c",
    "process.c",
    "process-stdio.c",
    "req-inl.h",
    "signal.c",
    "snprintf.c",
    "stream.c",
    "tcp.c",
    "thread.c",
    "tty.c",
    "udp.c",
    "util.c",
    "winapi.c",
    "winsock.c",
};

pub const C_WIN_SOURCES = &.{
    "fs-poll.c",
    "idna.c",
    "inet.c",
    "threadpool.c",
    "strscpy.c",
    "strtok.c",
    "timer.c",
    "uv-common.c",
};

pub const C_SOURCES = &.{
    "strscpy.c",
    "strtok.c",
    "timer.c",
    "uv-common.c",
};

pub const UNIX_C_SOURCES = &.{
    "cmake-bootstrap.c",
    "core.c",
    "fs.c",
    "loop.c",
    "loop-watcher.c",
    "no-fsevents.c",
    "pipe.c",
    "poll.c",
    "posix-hrtime.c",
    "posix-poll.c",
    "process.c",
    "signal.c",
    "stream.c",
    "tcp.c",
    "tty.c",
};
