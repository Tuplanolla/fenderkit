use <functions.scad>
use <operations.scad>
use <shapes.scad>

module hexagon(r) {
  circle_out(r, fn = 6);
}

module hexagonal_prism(r, h) {
  linear_extrude(h)
    hexagon(r);
}

module support_structure(r, h, w) {
  rotate_copy([0, 0, 90])
    mirror_copy([1, 0, 0])
    let (d = 2 * r / cos(30) * cos(60))
    intersection() {
      translate([0, - d / 2, 0])
        cube([w / 2, d, h]);
      translate([0, 0, - $e])
        cylinder(h + 2 * $e, w / 2, w / 2);
    }
}

module screw_slot(r, h0, h1, w) {
  hexagonal_prism(r, h0 + h1);
  support_structure(r, h0, w);
}

module hollow_quad_cylinder(h, r0, r1) {
  intersection() {
    hollow_cylinder(h, r0, r1);
    translate([0, 0, - $e])
      cube([r1 + $e, r1 + $e, h + 2 * $e]);
  }
}

module grooved_head_block_solid(x_part_back, x_part_front, a_rails) {
  let (w = x_part_back + x_part_front)
    mirror_copy([0, 1, 0])
    translate([- x_part_back, 0, z_foot + z_web + z_head])
    rotate([- 90, 0, 0])
    linear_extrude(y_head / 2)
    polygon([[0, 0], [w, 0],
        [w, w * tan(a_rails) + z_head], [0, z_head]]);
}

module grooved_head_block(x_part_back, x_part_front, a_rails) {
  let (d_inset = z_head)
    let (w = x_part_back + x_part_front) {
      difference() {
        /// This is the essential part.
        grooved_head_block_solid(x_part_back, x_part_front, a_rails);
        /// The rest is here to save material.
        mirror_copy([0, 1, 0])
          translate([- x_part_back, 0, z_foot + z_web + z_head])
          rotate([- 90, 0, 0])
          translate([0, 0, d_inset / 2])
          linear_extrude(y_head / 2 - d_inset / 2 + $e)
          offset(- d_inset)
          polygon([[0, 0], [w, 0],
              [w, w * tan(a_rails) + z_head], [0, z_head]]);
      }
      let (gradius = y_cut / 2 + d_inset)
        intersection() {
          grooved_head_block_solid(x_part_back, x_part_front, a_rails);
          translate([0, 0, z_foot + z_web + z_head - (w * tan(a_rails) + z_head) - $e])
            cylinder(w * tan(a_rails) + z_head + 2 * $e, gradius, gradius, $fn);
        }
    }
}

module grooved_mid_block(x_part_back) {
  let (r_cut = y_web / 2,
      d_cut = sqrt(2) * r_cut,
      x_cut = r_cut * trig_atrig((y_cut / 2 + e_cut) / r_cut))
    difference() {
      cube([x_part_back, y_web / 2, z_foot + z_web]);
      translate([x_part_back - x_cut, 0, - $e])
        hollow_quad_cylinder(z_foot + z_web + 2 * $e, r_cut, d_cut);
    }
}

module grooved_bed(x_part_back) {
  let (r_cut = y_head / 2,
      d_cut = sqrt(2) * r_cut,
      x_cut_other = r_cut * trig_atrig((y_cut / 2 + e_cut) / r_cut))
    let (x_cut = r_cut * trig_atrig((r_cut - z_foot + e_cut) / r_cut))
    difference() {
      cube([x_part_back, y_foot / 2, z_foot]);
      translate([x_part_back - x_cut, y_foot / 2 + $e, z_foot - r_cut])
        rotate([90, 0, 0])
        hollow_quad_cylinder(y_foot / 2 + 2 * $e, r_cut, d_cut);
    }
}

module skew_triangle(w, h, d) {
  linear_extrude(d)
    polygon([[0, 0], [0, w], [h, 0]]);
}

module tooth() {
  mirror_copy([0, 1, 0])
    rotate([90, 90, 0])
    skew_triangle(x_tooth, z_cut, y_cut / 2);
}

module teeth(n_front, n_back) {
  for (i = [0 : n_front - 1])
    let (a_tooth = y_cut / 2 + x_tooth,
        x_here = a_tooth + x_step * i)
    translate([x_here, 0, 0])
    tooth();
  for (i = [0 : n_back - 1])
    let (a_tooth = - y_cut / 2 - x_tooth,
        x_here = a_tooth - x_step * i)
    translate([x_here, 0, 0])
    tooth();
}

module half_part(x_part_back, r) {
  union() {
    grooved_mid_block(x_part_back);
    grooved_bed(x_part_back);
  }
}

module part(n_front, n_back, x_part_back, x_part_front, r) {
  grooved_head_block(x_part_back, x_part_front, a_rails);
  mirror_copy([0, 1, 0]) {
    translate([- (z_foot + z_web) * sin(a_rails), 0,
        z_foot + z_web + z_head - z_head - x_part_back * tan(a_rails)
        - (z_foot + z_web) * cos(a_rails)])
      rotate([0, a_rails, 0]) {
        difference() {
          union() {
            half_part(x_part_front / (scale_rails ? cos(a_rails) : 1), r);
            mirror([1, 0, 0])
              half_part(x_part_back / (scale_rails ? cos(a_rails) : 1), r);
          }
          translate([- x_part_back / (scale_rails ? cos(a_rails) : 1) - $e, - y_cut / 2, - $e])
            cube([(x_part_back + x_part_front) / (scale_rails ? cos(a_rails) : 1) + 2 * $e, y_cut, z_cut + $e]);
        }
        translate([0, 0, z_cut])
          teeth(n_front, n_back);
      }
  }
  translate([0, 0, z_foot + z_web + z_head])
    screw_slot(r, z_pillar_foot, z_pillar_head, d_pillar_foot);
}

module mount(n_front, n_back, x_part_back, x_part_front, r0, r1) {
  difference() {
    part(n_front, n_back, x_part_back, x_part_front, r1);
    let (rx = y_cut / 2) {
      translate([0, 0, - (x_part_back + x_part_front) * tan(a_rails) - $e])
        cylinder_mid(z_cut + (x_part_back + x_part_front) * tan(a_rails) + $e, rx + $e, $fn);
      translate([0, 0, z_cut - $e])
        cone_mid(z_foot + z_web + z_head - z_cut + $e, rx + $e, r0, $fn);
      translate([0, 0, z_foot + z_web + z_head - z_cut + z_cut - $e])
        cylinder_mid(z_pillar_foot + z_pillar_head + 2 * $e, r0, $fn);
    }
  }
}

module arrow_decoration(x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow) {
  let (x_arrow = x_arrow_head + x_arrow_tail,
      y_arrow = y_arrow_head)
    linear_extrude(z_arrow)
    polygon([
        [0, 0],
        [- x_arrow_head, y_arrow_head / 2],
        [- x_arrow_head, y_arrow_tail / 2],
        [- x_arrow, y_arrow_tail / 2],
        [- x_arrow, - y_arrow_tail / 2],
        [- x_arrow_head, - y_arrow_tail / 2],
        [- x_arrow_head, - y_arrow_head / 2]
    ]);
}

module decorated_mount(x_part_back, x_part_front,
    n_front, n_back, r0, r1,
    //
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails) {
  mount(n_front, n_back, x_part_back, x_part_front, r0, r1);
  translate([x_part_front - x_arrow_dist, 0, z_foot + z_web + z_head])
    arrow_decoration(x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
        z_arrow);
}
