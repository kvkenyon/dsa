const std = @import("std");
const testing = std.testing;
const math = std.math;

fn bin_pow1(x: i128, n: i128) i128 { // x=3, n=13
    if (n == 0) return 1;
    const res: i128 = bin_pow1(x, @divTrunc(n, 2));
    res *= res;
    if (@mod(n, 2) == 1) return res * x;
    return res;
}

fn bin_pow(x: u128, n: u128) error{Overflow}!u128 {
    var res: u128 = 1;
    var a = x;
    var b = n;
    while (b > 1) : (b = @divTrunc(b, 2)) {
        if (@mod(b, 2) == 1) {
            const ov = @mulWithOverflow(res, a);
            if (ov[1] != 0) return error.Overflow;
            res = ov[0];
        }
        const ov = @mulWithOverflow(a, a);
        if (ov[1] != 0) return error.Overflow;
        a = ov[0];
    }
    if (b == 1) {
        const ov = @mulWithOverflow(res, a);
        if (ov[1] != 0) return error.Overflow;
        res = ov[0];
    }
    return res;
}

const Matrix = struct {
    mat: [2][2]u128,
    pub fn mul(self: Matrix, other: Matrix) !Matrix {
        var ret: [2][2]u128 = .{ .{ 0, 0 }, .{ 0, 0 } };
        for (0..2) |i| {
            for (0..2) |j| {
                for (0..2) |k| {
                    ret[i][j] += self.mat[i][k] * other.mat[k][j];
                }
            }
        }
        return Matrix{ .mat = ret };
    }
};

// linear fib
pub fn slow_fib(n: u32) u128 {
    var a: u128 = 0;
    var b: u128 = 1;
    for (0..n) |_| {
        const tmp = a + b;
        a = b;
        b = tmp;
    }
    return a;
}

// log(n) fibonacci using binary exponentiation on matrices
pub fn fast_fib(n: u32) u128 {
    var a = Matrix{
        .mat = .{
            .{ 1, 1 },
            .{ 1, 0 },
        },
    };
    var b = n;
    var res = Matrix{ .mat = .{
        .{ 1, 0 },
        .{ 0, 1 },
    } };
    while (b > 0) : (b = @divTrunc(b, 2)) {
        if (b & 1 == 0b00001) {
            res = try res.mul(a);
        }
        a = try a.mul(a);
    }

    return res.mat[0][1];
}

test "algebra.bin_pow" {
    try testing.expect(try bin_pow(2, 0) == 1);
    try testing.expect(try bin_pow(3, 13) == math.pow(u128, 3, 13));
    try testing.expect(try bin_pow(2, 16) == math.pow(u128, 2, 16));
    try testing.expect(try bin_pow(2, 32) == math.pow(u128, 2, 32));
    try testing.expect(try bin_pow(2, 64) == 18446744073709551616);
    try testing.expect(try bin_pow(2, 127) == 170141183460469231731687303715884105728);
    try testing.expectError(error.Overflow, bin_pow(2, 128));
    try testing.expectError(error.Overflow, math.powi(u128, 2, 128));
}

test "algebra.Matrix" {
    const m1 = Matrix{ .mat = .{
        .{ 1, 0 },
        .{ 0, 1 },
    } };
    const m2: Matrix = Matrix{ .mat = .{
        .{ 1, 1 },
        .{ 1, 1 },
    } };
    const m3 = Matrix{
        .mat = .{
            .{ 1, 1 },
            .{ 1, 1 },
        },
    };
    try testing.expect(m1.mat[0][0] == 1);
    try testing.expectEqualDeep(m3, try m1.mul(m2));
}

test "algebra.fast_fib" {
    try testing.expect(fast_fib(13) == 233);
}

test "algebra.slow_fibn" {
    try testing.expect(slow_fib(13) == 233);
}

pub fn main() !void {
    std.debug.print("{}\n", .{try bin_pow(2, 127)});
}
