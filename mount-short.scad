use <mount.scad>
include <mount-shared.scad>

color("DarkGray")
  decorated_mount(x_part_short / 2, x_part_short / 2,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    2, 3, x_tooth, x_step,
    d_hole / 2, d_insert_foot / 2, d_insert_head / 2, z_insert_foot, z_insert_head,
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails);
