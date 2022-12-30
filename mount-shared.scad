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
/// Number of teeth on the back.
n_teeth_back = undef;
/// Number of teeth on the front.
n_teeth_front = undef;
/// Length of each tooth.
x_tooth = 2;
/// Distance between the edges of adjacent teeth.
x_step = 4;
/// Diameter of the hole at the top.
d_hole = 5.5;
/// Diameter of the hole at the bottom.
d_countersink = y_cut;
/// Outer diameter of the insert (diameter of the circle).
d_insert_foot = 14;
/// Inner diameter of the insert (width of the hexagon).
d_insert_head = 8;
/// Heights of the insert.
z_insert_foot = 7;
z_insert_head = 4;
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
/// The original angle is flat.
// a_rails = 0;
/// This angle has been tested to work with a 2020 rigid fat bike,
/// a 2021 hard-tail jump bike and a 2022 full-suspension trail bike.
a_rails = 8;
/// Whether to scale the rails with respect to the angle.
scale_rails = true;

/// It just so happens!
echo(r_cut = d_countersink / 2 + z_head, r_insert_foot = d_insert_foot / 2);
