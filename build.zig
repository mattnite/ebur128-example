const std = @import("std");
const pkgs = @import("gyro").pkgs;
const Ebur128Builder = @import("Ebur128Builder");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var ebur = try Ebur128Builder.init(b);
    defer ebur.deinit();

    const exe = b.addExecutable("ebur128-example", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkSystemLibrary("sndfile");
    pkgs.addAllTo(exe);
    ebur.link(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
