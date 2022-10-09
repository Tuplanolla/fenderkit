$e = 0.1;
$fn = 64;

/// Length of the part.
x_part_short = 35;
x_part_long = 41;
/// Width of the original part (unused measurement).
y_part = 18;
/// Height of the original part (unused measurement).
z_part = 17;
/// Widths of the rail.
y_foot = 18;
y_web = 13;
y_head = 16;
/// Heights of the rail (using railway terminology).
z_foot = 2;
z_web = 2;
z_head = 2;
/// Width of the bottom cutout.
y_cut = 10;
/// Depth of the bottom cutout.
z_cut = 3;
/// Leeway for the chamfers on the rails (for avoiding sharp corners).
e_cut = 0.5;
/// Length of each tooth.
x_tooth = 2;
/// Distance between the edges of adjacent teeth.
x_step = 4;
/// Diameter of the hole.
d_hole = 5.5;
/// Inner diameter of the pillar (width of the hexagon).
d_pillar_head = 8;
/// Outer diameter of the pillar (diameter of the circle).
d_pillar_foot = 14;
/// Heights of the pillar.
z_pillar_foot = 7;
z_pillar_head = 4;
/// Arrow head length.
x_arrow_head = 4;
/// Arrow head width.
y_arrow_head = 4;
/// Arrow tail length.
x_arrow_tail = 4;
/// Arrow tail width.
y_arrow_tail = 2;
/// Arrow thickness.
z_arrow = 0.5;
/// Arrow head distance from the edge.
x_arrow_dist = 1;
/// Angle of the rails.
a_rails = 10;
/// Whether to scale the rails with respect to the angle.
scale_rails = true;

/// It just so happens!
echo(r_cut = y_cut / 2 + z_head, r_pillar_foot = d_pillar_foot / 2);
