use <functions.scad>
use <operations.scad>

/// ## Two-Dimensional Shapes

/// The invocation `circle_inscribed(r)`
/// produces a regular polygon with `$fn` sides and the inner radius `r`,
/// approximating a circle from the inside.
module circle_inscribed(r) {
  circle(r);
}

/// The invocation `circle_circumscribed(r)`
/// produces a regular polygon with `$fn` sides and the outer radius `r`,
/// approximating a circle from the outside.
module circle_circumscribed(r) {
  let (c = circumscription_factor())
    circle(c * r);
}

/// The invocation `circle_medial(r)`
/// produces a regular polygon with `$fn` sides and the mean radius `r`,
/// approximating a circle.
module circle_medial(r) {
  let (c = mean(1, circumscription_factor()))
    circle(c * r);
}

/// The invocation `hexagon_inscribed(r)`
/// produces a regular hexagon with the outer radius `r`.
module hexagon_inscribed(r) {
  circle_inscribed(r, $fn = 6);
}

/// The invocation `hexagon_circumscribed(r)`
/// produces a regular hexagon with the inner radius `r`.
module hexagon_circumscribed(r) {
  circle_circumscribed(r, $fn = 6);
}

/// The invocation `right_triangle(x, y)`
/// produces a right triangle with the side lengths `x` and `y`.
/// The right angle of the triangle is placed at the origin.
module right_triangle(x, y) {
  polygon([[0, 0], [x, 0], [0, y]]);
}

/// The invocation `isosceles_right_triangle(x)`
/// produces an isosceles right triangle with the side length `x`.
/// The right angle of the triangle is placed at the origin.
module isosceles_right_triangle(x) {
  right_triangle(x, x);
}

/// The invocation `cross_shape(w, d)`
/// produces a cross shape with the width `w` and thickness `d`.
/// The center of the shape is placed at the origin.
module cross(w, d) {
  rotate_copy([0, 0, 90])
    translate([- w / 2, - d / 2, 0])
    square([w, d]);
}

/// ## Three-Dimensional Shapes

/// The invocation `cone_inscribed(h, r0, r1)`
/// produces a regular polygonal prism with `$fn` sides, the height `h`,
/// the intitial inner radius `r0` and the terminal inner radius `r1`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cone_inscribed(h, r0, r1) {
  cylinder(h, r1 = r0, r2 = r1);
}

/// The invocation `cone_circumscribed(h, r0, r1)`
/// produces a regular polygonal prism with `$fn` sides, the height `h`,
/// the intitial outer radius `r0` and the terminal outer radius `r1`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cone_circumscribed(h, r0, r1) {
  let (c = circumscription_factor())
    cylinder(h, r1 = c * r0, r2 = c * r1);
}

/// The invocation `cone_medial(h, r0, r1)`
/// produces a regular polygonal prism with `$fn` sides, the height `h`,
/// the intitial mean radius `r0` and the terminal mean radius `r1`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cone_medial(h, r0, r1) {
  let (c = mean(1, circumscription_factor()))
    cylinder(h, r1 = c * r0, r2 = c * r1);
}

/// The invocation `cylinder_inscribed(h, r)`
/// produces a regular polygonal prism with `$fn` sides,
/// the height `h` and the inner radius `r`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cylinder_inscribed(h, r) {
  cone_inscribed(h, r, r);
}

/// The invocation `cylinder_circumscribed(h, r)`
/// produces a regular polygonal prism with `$fn` sides,
/// the height `h` and the outer radius `r`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cylinder_circumscribed(h, r) {
  cone_circumscribed(h, r, r);
}

/// The invocation `cylinder_medial(h, r)`
/// produces a regular polygonal prism with `$fn` sides,
/// the height `h` and the mean radius `r`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cylinder_medial(h, r) {
  cone_medial(h, r, r);
}

/// The invocation `hollow_cylinder(h, r0, r1)`
/// produces a hollow regular polygonal prism with `$fn` sides,
/// the height `h`, the inner radius `r0` and the outer radius `r1`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module hollow_cylinder(h, r0, r1) {
  difference() {
    cylinder_circumscribed(h, r1);
    translate([0, 0, - $e])
      cylinder_inscribed(2 * $e + h, r0);
  }
}

/// The invocation `hollow_cylinder_quadrant(h, r0, r1)`
/// produces the first quadrant of a hollow regular polygonal prism
/// with `$fn` sides, the height `h`,
/// the inner radius `r0` and the outer radius `r1`.
/// The base of the prism is placed at the origin and
/// its height grows along the `z` axis.
module hollow_cylinder_quadrant(h, r0, r1) {
  intersection() {
    hollow_cylinder(h, r0, r1);
    translate([0, 0, - $e])
      cube([r1 + $e, r1 + $e, h + 2 * $e]);
  }
}

/// The invocation `hexagonal_prism(h, r)`
/// produces a regular hexagonal prism
/// with the height `h` and inner radius `r`.
/// The center of the prism is placed at the origin and
/// its height grows along the `z` axis.
module hexagonal_prism(h, r) {
  cylinder_circumscribed(h, r, $fn = 6);
}

/// The invocation `right_triangular_prism(h, x, y)`
/// produces a right triangular prism
/// with the height `h` and side lengths `x` and `y`.
/// The right angle of the triangle is placed at the origin and
/// its height grows along the `z` axis.
module right_triangular_prism(h, x, y) {
  linear_extrude(h)
    right_triangle(x, y);
}

/// The invocation `isosceles_right_triangular_prism(h, x)`
/// produces an isosceles right triangular prism
/// with the height `h` and side length `x`.
/// The right angle of the triangle is placed at the origin and
/// its height grows along the `z` axis.
module isosceles_right_triangular_prism(h, x) {
  right_triangular_prism(h, x, x);
}

/// The invocation `torus(r0, r1)`
/// produces an approximation of a toroidal surface
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

/// The invocation `cross_shaped_prism(w, t, h)`
/// produces a cross-shaped prism
/// with the width `w`, the thickness `t` and the height `h`.
/// The center of the prism is placed at the origin and
/// its height grows along the `z` axis.
module cross_shaped_prism(w, t, h) {
  rotate_copy([0, 0, 90])
    translate([- w / 2, - t / 2, 0])
    cube([w, t, h]);
}

/// The invocation `rounded_cross_shaped_prism(d, t, h)`
/// produces a rounded cross-shaped prism
/// with the diameter `d`, the thickness `t` and the height `h`.
/// The center of the prism is placed at the origin and
/// its height grows along the `z` axis.
module rounded_cross_shaped_prism(d, t, h) {
  intersection() {
    cross_shaped_prism(d, t, h);
    translate([0, 0, - $e])
      cylinder(h + 2 * $e, d / 2, d / 2);
  }
}
