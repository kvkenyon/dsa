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

pub fn main() !void {
    std.debug.print("{}\n", .{math.pow(u128, 2, 64)});

    std.debug.print("{}\n", .{math.maxInt(u128)});
}
