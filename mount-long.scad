include <mount.scad>
include <mount-shared.scad>

color("DarkGray")
  decorated_mount(x_part_short / 2, x_part_long - x_part_short / 2, 4, 1,
    d_hole / 2, d_pillar_head / 2,
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails);
