use <functions.scad>
use <operations.scad>
use <shapes.scad>

module insert(r_insert_foot, r_insert_head, z_insert_foot, z_insert_head) {
  hexagonal_prism(z_insert_foot + z_insert_head, r_insert_head);
  rounded_cross_shaped_prism(2 * r_insert_foot, (2 / sqrt(3)) * r_insert_head,
      z_insert_foot);
}

function head_x(z_part, a_rails) =
  z_part * cos(a_rails);

function head_y(z_part, a_rails) =
  z_part * sin(a_rails);

function head_z(x_part, a_rails) =
  x_part * tan(a_rails);

module head_outline(x_part, y_head, z_head, a_rails) {
  polygon([
      [0, 0],
      [x_part, 0],
      [x_part, z_head + head_z(x_part, a_rails)],
      [0, z_head]]);
}

module head(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head, a_rails) {
  mirror_copy([0, 1, 0])
    translate([- x_part_back, 0, z_foot + z_web + z_head])
    rotate([- 90, 0, 0])
    linear_extrude(y_head / 2)
    head_outline(x_part_back + x_part_front, y_head, z_head, a_rails);
}

module head_cut(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut, a_rails) {
  mirror_copy([0, 1, 0])
    translate([- x_part_back, 0, z_foot + z_web + z_head])
    rotate([- 90, 0, 0])
    translate([0, 0, z_head / 2])
    linear_extrude(y_head / 2 - z_head / 2 + $e)
    offset(- z_head)
    head_outline(x_part_back + x_part_front, y_head, z_head, a_rails);
}

module head_sheath(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut, a_rails) {
  let (h_head = z_head + head_z(x_part_back + x_part_front, a_rails),
      r_sheath = y_cut / 2 + z_head,
      z_rail = z_foot + z_web + z_head)
    translate([0, 0, z_rail - h_head - $e])
    cylinder(h_head + 2 * $e, r_sheath, r_sheath);
}

module carved_head(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut, a_rails) {
  difference() {
    head(x_part_back, x_part_front,
        y_foot, y_web, y_head, z_foot, z_web, z_head, a_rails);
    head_cut(x_part_back, x_part_front,
        y_foot, y_web, y_head, z_foot, z_web, z_head,
        y_cut, z_cut, e_cut, a_rails);
  }
  intersection() {
    head(x_part_back, x_part_front,
        y_foot, y_web, y_head, z_foot, z_web, z_head, a_rails);
    head_sheath(x_part_back, x_part_front,
        y_foot, y_web, y_head, z_foot, z_web, z_head,
        y_cut, z_cut, e_cut, a_rails);
  }
}

module quarter_web(x_part,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut) {
  let (r_cut = y_web / 2,
      r_cut_bound = sqrt(2) * r_cut,
      x_cut = r_cut * trig_atrig((y_cut / 2 + e_cut) / r_cut))
    difference() {
      cube([x_part, y_web / 2, z_foot + z_web]);
      translate([x_part - x_cut, 0, - $e])
        hollow_cylinder_quadrant(z_foot + z_web + 2 * $e, r_cut, r_cut_bound);
    }
}

module quarter_foot(x_part,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut) {
  let (r_cut = y_web / 2,
      r_cut_bound = sqrt(2) * r_cut,
      x_cut = r_cut * trig_atrig((r_cut - z_foot + e_cut) / r_cut))
    difference() {
      cube([x_part, y_foot / 2, z_foot]);
      translate([x_part - x_cut, y_foot / 2 + $e, z_foot - r_cut])
        rotate([90, 0, 0])
        hollow_cylinder_quadrant(y_foot / 2 + 2 * $e, r_cut, r_cut_bound);
    }
}

module quarter_rails(x_part,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut) {
  quarter_web(x_part,
      y_foot, y_web, y_head, z_foot, z_web, z_head,
      y_cut, z_cut, e_cut);
  quarter_foot(x_part,
      y_foot, y_web, y_head, z_foot, z_web, z_head,
      y_cut, z_cut, e_cut);
}

module half_rails(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut) {
  quarter_rails(x_part_front,
      y_foot, y_web, y_head, z_foot, z_web, z_head,
      y_cut, z_cut, e_cut);
  mirror([1, 0, 0])
    quarter_rails(x_part_back,
        y_foot, y_web, y_head, z_foot, z_web, z_head,
        y_cut, z_cut, e_cut);
}

module half_tooth(y_cut, z_cut, e_cut, x_tooth) {
  rotate([- 90, 0, 0])
    right_triangular_prism(y_cut / 2, x_tooth, z_cut);
}

module half_teeth(y_cut, z_cut, e_cut, r_countersink,
    n_teeth_back, n_teeth_front, x_tooth, x_step) {
  let (x_offset = x_tooth * ceil(r_countersink / x_tooth)) {
    for (i = [0 : n_teeth_front - 1])
      translate([x_offset + x_tooth + x_step * i, 0, 0])
      half_tooth(y_cut, z_cut, e_cut, x_tooth);
    for (i = [0 : n_teeth_back - 1])
      translate([- (x_offset + x_tooth + x_step * i), 0, 0])
      half_tooth(y_cut, z_cut, e_cut, x_tooth);
  }
}

module carved_rails(x_part_back, x_part_front,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_countersink, r_insert_foot, r_insert_head,
    z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  mirror_copy([0, 1, 0])
    translate([- head_y(z_foot + z_web, a_rails), 0,
        z_foot + z_web
        - head_x(z_foot + z_web, a_rails)
        - head_z(x_part_back, a_rails)])
    rotate([0, a_rails, 0]) {
      let (c = scale_rails ? 1 / cos(a_rails) : 1)
        difference() {
          half_rails(c * x_part_back, c * x_part_front,
              y_foot, y_web, y_head, z_foot, z_web, z_head,
              y_cut, z_cut, e_cut);
          translate([- c * x_part_back - $e, - y_cut / 2, - $e])
            cube([c * x_part_back + c * x_part_front + 2 * $e,
            y_cut, z_cut + $e]);
        }
      translate([0, 0, z_cut])
        half_teeth(y_cut, z_cut, e_cut, r_countersink,
            n_teeth_back, n_teeth_front, x_tooth, x_step);
    }
  carved_head(x_part_back, x_part_front,
      y_foot, y_web, y_head, z_foot, z_web, z_head,
      y_cut, z_cut, e_cut, a_rails);
  translate([0, 0, z_foot + z_web + z_head])
    insert(r_insert_foot, r_insert_head, z_insert_foot, z_insert_head);
}

module mount(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut, n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_countersink, r_hole, r_insert_foot, r_insert_head,
    z_insert_foot, z_insert_head,
    a_rails, scale_rails) {
  difference() {
    carved_rails(x_part_back, x_part_front,
        y_foot, y_web, y_head,
        z_foot, z_web, z_head,
        y_cut, z_cut, e_cut,
        n_teeth_back, n_teeth_front, x_tooth, x_step,
        r_countersink, r_insert_foot, r_insert_head,
        z_insert_foot, z_insert_head,
        a_rails, scale_rails);
    let (h_head = z_head + head_z(x_part_back + x_part_front, a_rails)) {
      translate([0, 0, - h_head - $e])
        cylinder_medial(z_cut + h_head + 2 * $e, r_countersink);
      translate([0, 0, z_cut])
        cone_medial(z_foot + z_web + z_head - z_cut, r_countersink, r_hole);
      translate([0, 0, z_foot + z_web + z_head - $e])
        cylinder_medial(z_insert_foot + z_insert_head + 2 * $e, r_hole);
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
        [- x_arrow_head, - y_arrow_head / 2]]);
}

module decorated_mount(x_part_back, x_part_front,
    y_foot, y_web, y_head, z_foot, z_web, z_head,
    y_cut, z_cut, e_cut, n_teeth_back, n_teeth_front, x_tooth, x_step,
    r_countersink, r_hole, r_insert_foot, r_insert_head,
    z_insert_foot, z_insert_head,
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails) {
  mount(x_part_back, x_part_front,
      y_foot, y_web, y_head, z_foot, z_web, z_head,
      y_cut, z_cut, e_cut, n_teeth_back, n_teeth_front, x_tooth, x_step,
      r_countersink, r_hole, r_insert_foot, r_insert_head,
      z_insert_foot, z_insert_head,
      a_rails, scale_rails);
  translate([x_part_front - x_arrow_dist, 0, z_foot + z_web + z_head])
    arrow_decoration(x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
        z_arrow);
}
