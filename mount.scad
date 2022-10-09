use <functions.scad>
use <operations.scad>
use <shapes.scad>

module insert(r, h0, h1, w) {
  hexagonal_prism(r, h0 + h1);
  rounded_cross(r, h0, 2 * w);
}

module head(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  let (w = x_part_back + x_part_front)
    mirror_copy([0, 1, 0])
    translate([- x_part_back, 0, z_foot + z_web + z_head])
    rotate([- 90, 0, 0])
    linear_extrude(y_head / 2)
    polygon([[0, 0], [w, 0],
        [w, w * tan(a_rails) + z_head], [0, z_head]]);
}

module hollowed_head(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  let (d_inset = z_head)
    let (w = x_part_back + x_part_front) {
      difference() {
        /// This is the essential part.
        head(x_part_back, x_part_front,
            y_foot, y_web, y_head,
            z_foot, z_web, z_head,
            y_cut, z_cut, e_cut,
            n_teeth_back, n_teeth_front, x_tooth, x_step,
            r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
            a_rails, scale_rails);
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
          head(x_part_back, x_part_front,
              y_foot, y_web, y_head,
              z_foot, z_web, z_head,
              y_cut, z_cut, e_cut,
              n_teeth_back, n_teeth_front, x_tooth, x_step,
              r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
              a_rails, scale_rails);
          translate([0, 0, z_foot + z_web + z_head - (w * tan(a_rails) + z_head) - $e])
            cylinder(w * tan(a_rails) + z_head + 2 * $e, gradius, gradius, $fn);
        }
    }
}

module half_web(x_part,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  let (r_cut = y_web / 2,
      d_cut = sqrt(2) * r_cut,
      x_cut = r_cut * trig_atrig((y_cut / 2 + e_cut) / r_cut))
    difference() {
      cube([x_part, y_web / 2, z_foot + z_web]);
      translate([x_part - x_cut, 0, - $e])
        hollow_cylinder_quadrant(z_foot + z_web + 2 * $e, r_cut, d_cut);
    }
}

module half_foot(x_part,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  let (r_cut = y_head / 2,
      d_cut = sqrt(2) * r_cut,
      x_cut_other = r_cut * trig_atrig((y_cut / 2 + e_cut) / r_cut))
    let (x_cut = r_cut * trig_atrig((r_cut - z_foot + e_cut) / r_cut))
    difference() {
      cube([x_part, y_foot / 2, z_foot]);
      translate([x_part - x_cut, y_foot / 2 + $e, z_foot - r_cut])
        rotate([90, 0, 0])
        hollow_cylinder_quadrant(y_foot / 2 + 2 * $e, r_cut, d_cut);
    }
}

/// TODO This is on the wrong side!
module tooth(y_cut, z_cut, x_tooth) {
  rotate([90, 90, 0])
    skew_triangular_prism(z_cut, x_tooth, y_cut / 2);
}

module teeth(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  for (i = [0 : n_teeth_front - 1])
    let (a_tooth = y_cut / 2 + x_tooth,
        x_here = a_tooth + x_step * i)
    translate([x_here, 0, 0])
    tooth(y_cut, z_cut, x_tooth);
  for (i = [0 : n_teeth_back - 1])
    let (a_tooth = - y_cut / 2 - x_tooth,
        x_here = a_tooth - x_step * i)
    translate([x_here, 0, 0])
    tooth(y_cut, z_cut, x_tooth);
}

module half_rails(x_part,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  union() {
    half_web(x_part,
        y_foot, y_web, y_head,
        z_foot, z_web, z_head,
        y_cut, z_cut, e_cut,
        n_teeth_back, n_teeth_front, x_tooth, x_step,
        r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
        a_rails, scale_rails);
    half_foot(x_part,
        y_foot, y_web, y_head,
        z_foot, z_web, z_head,
        y_cut, z_cut, e_cut,
        n_teeth_back, n_teeth_front, x_tooth, x_step,
        r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
        a_rails, scale_rails);
  }
}

module body(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  hollowed_head(x_part_back, x_part_front,
      y_foot, y_web, y_head,
      z_foot, z_web, z_head,
      y_cut, z_cut, e_cut,
      n_teeth_back, n_teeth_front, x_tooth, x_step,
      r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
      a_rails, scale_rails);
  mirror_copy([0, 1, 0]) {
    translate([- (z_foot + z_web) * sin(a_rails), 0,
        z_foot + z_web + z_head - z_head - x_part_back * tan(a_rails)
        - (z_foot + z_web) * cos(a_rails)])
      rotate([0, a_rails, 0]) {
        difference() {
          union() {
            half_rails(x_part_front / (scale_rails ? cos(a_rails) : 1),
                y_foot, y_web, y_head,
                z_foot, z_web, z_head,
                y_cut, z_cut, e_cut,
                n_teeth_back, n_teeth_front, x_tooth, x_step,
                r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
                a_rails, scale_rails);
            mirror([1, 0, 0])
              half_rails(x_part_back / (scale_rails ? cos(a_rails) : 1),
                  y_foot, y_web, y_head,
                  z_foot, z_web, z_head,
                  y_cut, z_cut, e_cut,
                  n_teeth_back, n_teeth_front, x_tooth, x_step,
                  r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
                  a_rails, scale_rails);
          }
          translate([- x_part_back / (scale_rails ? cos(a_rails) : 1) - $e, - y_cut / 2, - $e])
            cube([(x_part_back + x_part_front) / (scale_rails ? cos(a_rails) : 1) + 2 * $e, y_cut, z_cut + $e]);
        }
        translate([0, 0, z_cut])
          teeth(x_part_back, x_part_front,
              y_foot, y_web, y_head,
              z_foot, z_web, z_head,
              y_cut, z_cut, e_cut,
              n_teeth_back, n_teeth_front, x_tooth, x_step,
              r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
              a_rails, scale_rails);
      }
  }
  translate([0, 0, z_foot + z_web + z_head])
    insert(r_insert_head, z_insert_foot, z_insert_head, r_insert_foot); // TODO r_insert_foot
}

module mount(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  difference() {
    body(x_part_back, x_part_front,
        y_foot, y_web, y_head,
        z_foot, z_web, z_head,
        y_cut, z_cut, e_cut,
        n_teeth_back, n_teeth_front, x_tooth, x_step,
        r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails);
    let (rx = y_cut / 2) {
      translate([0, 0, - (x_part_back + x_part_front) * tan(a_rails) - $e])
        cylinder_mid(z_cut + (x_part_back + x_part_front) * tan(a_rails) + $e, rx + $e, $fn);
      translate([0, 0, z_cut - $e])
        cone_mid(z_foot + z_web + z_head - z_cut + $e, rx + $e, r_hole, $fn);
      translate([0, 0, z_foot + z_web + z_head - z_cut + z_cut - $e])
        cylinder_mid(z_insert_foot + z_insert_head + 2 * $e, r_hole, $fn);
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
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails) {
  mount(x_part_back, x_part_front,
      y_foot, y_web, y_head,
      z_foot, z_web, z_head,
      y_cut, z_cut, e_cut,
      n_teeth_back, n_teeth_front, x_tooth, x_step,
      r_hole, r_insert_foot, r_insert_head, z_insert_foot, z_insert_head,
    a_rails, scale_rails);
  translate([x_part_front - x_arrow_dist, 0, z_foot + z_web + z_head])
    arrow_decoration(x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
        z_arrow);
}
