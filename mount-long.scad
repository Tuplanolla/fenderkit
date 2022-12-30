use <mount.scad>
include <mount-shared.scad>

color("DarkGray")
  decorated_mount(x_part_short / 2, x_part_long - x_part_short / 2,
    y_foot, y_web, y_head,
    z_foot, z_web, z_head,
    y_cut, z_cut, e_cut,
    /// The original number of teeth is too small
    /// to withstand the stresses of riding hard.
    // 1, 4, x_tooth, x_step,
    /// This number of teeth has been tested to work with various
    /// features, crashes and weather conditions.
    3, 4, x_tooth, x_step,
    d_countersink / 2, d_hole / 2, d_insert_foot / 2, d_insert_head / 2,
    z_insert_foot, z_insert_head,
    x_arrow_head, y_arrow_head, x_arrow_tail, y_arrow_tail,
    z_arrow, x_arrow_dist,
    a_rails, scale_rails);
