# CMake bootstrapped with build.zig

using the zig build system, this repository bootstraps `cmake` `3.30.1` without any system cmake
or the usual shellscript method. it takes a while and is only tested on x64 linux,
but can be used to build your C/C++ dependency libraries.

the package also has a custom `CMakeStep` that will configure and build and install a cmake project,
and providdes a `.install(b, name)` function to get the artifacts:
```
zig fetch --save git+https://github.com/dasimmet/zig-cmake.git
```
build.zig (from [example](./example/build.zig)):
```
pub fn build() void {
  const cmake_import = b.lazyImport(@This(), "cmake");

  if (cmake_import) |cmake| {
    const cmakeStep = cmake.addCMakeStep(b, .{
      .target = b.standardTargetOptions(.{}),
      .name = "cmake_my_project",
      .source_dir = b.path(""), // or path to directory containing CMakeLists.txt
        .defines = &.{
            .{ "CMAKE_BUILD_TYPE", if (optimize == .Debug) "Debug" else "Release" },
        },
    });
  }
  const install_step = cmakeStep.install(b, ""); // installs the 
  b.getInstallStep().dependOn(&install_step.step);
}
```

# Supported

- ✅ stage1 linux
- ✅ stage2 linux
- ✅ example build step linux

- ✅ stage1 windows
- 🏃‍♂️ stage2 windows
- 🏃‍♂️ example build step windows

- ✅ stage1 macos
- 🏃‍♂️ stage2 macos
- 🏃‍♂️ example build step macos

- 🏃‍♂️test building other cmake projects
- 🏃‍♂️try to link cmake fully static
- 🏃‍♂️test other architectures
