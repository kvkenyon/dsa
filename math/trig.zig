const std = @import("std");
const math = std.math;
const testing = std.testing;

// A trigonometry implementation

pub fn circle(r: f32) type {
    return struct {
        const Self = @This();

        r: f32 = r,

        pub fn circumference(self: *Self) f32 {
            return 2 * math.pi * self.r;
        }
        // Theta must be in radians
        pub fn arc_length(self: *Self, theta: f32) f32 {
            return self.r * theta;
        }

        pub fn area(self: *Self, theta: f32) f32 {
            return 0.5 * math.pow(self.r, 2) * theta;
        }
    };
}

pub fn angle(deg: f32) type {
    return struct {
        const Self: type = @This();

        deg: f32 = deg,
        rad: f32 = (deg * (math.pi / 180)),
    };
}

// 2pi/6 = radians(2,6);
pub fn radians(n: f32, d: f32) f32 {
    return n * math.pi / d;
}

test "angle" {}
