use <operations.scad>

/// The invocation `hollow_cylinder(h, r0, r1)` produces a hollow cylinder
/// with the height `h`, the inner radius `r0` and the outer radius `r1`.
/// The base of the cylinder is placed at the origin and
/// its height grows along the `z` axis.
module hollow_cylinder(h, r0, r1) {
  difference() {
    cylinder(h, r1, r1);
    translate([0, 0, - $e])
      cylinder(2 * $e + h, r0, r0);
  }
}

/// The invocation `hollow_cylinder_quadrant(h, r0, r1)`
/// produces the first quadrant of a hollow cylinder
/// with the height `h`, the inner radius `r0` and the outer radius `r1`.
/// The base of the cylinder is placed at the origin and
/// its height grows along the `z` axis.
module hollow_cylinder_quadrant(h, r0, r1) {
  intersection() {
    hollow_cylinder(h, r0, r1);
    translate([0, 0, - $e])
      cube([r1 + $e, r1 + $e, h + 2 * $e]);
  }
}

/// The invocation `torus(r0, r1)` produces a torus
/// with the toroidal radius (the distance
/// from the center of mass of the torus
/// to the centerline of the tube) `r0` and
/// the poloidal radius (the distance
/// from the centerline of the tube
/// to the surface of the torus) `r1`.
/// The center of mass of the torus is placed at the origin and
/// the tube revolves around the `z` axis.
module torus(r0, r1) {
  translate([0, 0, - r1])
    rotate_extrude()
    translate([r0, r1, 0])
    circle(r1);
}

/// The invocation `skew_triangle(x, y)` produces a right triangle
/// with the side lengths `x` and `y`.
/// The right angle of the triangle is placed at the origin.
module skew_triangle(x, y) {
  polygon([[0, 0], [x, 0], [0, y]]);
}

/// The invocation `skew_triangular_prism(x, y, z)`
/// produces a right triangular prism
/// with the side lengths `x` and `y` and height `z`.
/// The right angle of the triangle is placed at the origin and
/// its height grows along the `z` axis.
module skew_triangular_prism(x, y, z) {
  linear_extrude(z)
    skew_triangle(x, y);
}

/// The invocation `triangle(x)` produces an isosceles right triangle
/// with the side length `x`.
/// The right angle of the triangle is placed at the origin.
module triangle(x) {
  skew_triangle(x, x);
}

/// The invocation `triangular_prism(x, z)`
/// produces an isosceles right triangular prism
/// with the side length `x` and height `z`.
/// The right angle of the triangle is placed at the origin and
/// its height grows along the `z` axis.
module triangular_prism(x, z) {
  skew_triangular_prism(x, x, z);
}

/// TODO These.

module hexagon(r) {
  circle_out(r, fn = 6);
}

module hexagonal_prism(r, h) {
  linear_extrude(h)
    hexagon(r);
}

module cross(r, h, w) {
  let (d = 2 * r / cos(30) * cos(60))
    rotate_copy([0, 0, 90])
    mirror_copy([1, 0, 0])
    translate([0, - d / 2, 0])
    cube([w / 2, d, h]);
}

module rounded_cross(r, h, w) {
  intersection() {
    cross(r, h, w);
    translate([0, 0, - $e])
      cylinder(h + 2 * $e, w / 2, w / 2);
  }
}

module cylinder_out(height,radius,fn){
  let (fudge = (1+1/cos(180/fn)))
    cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cylinder_mid(height,radius,fn){
  let (fudge = (1+1/cos(180/fn))/2)
    cylinder(h=height,r=radius*fudge,$fn=fn);
}

module cone_mid(height,radius,radiuser,fn){
  let (fudge = (1+1/cos(180/fn))/2)
    cylinder(height,radius*fudge,radiuser*fudge,$fn=fn);
}

module circle_out(radius,fn){
  let (fudge = 1/cos(180/fn))
    circle(r=radius*fudge,$fn=fn);
}
