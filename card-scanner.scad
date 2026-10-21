// Card scanner — honeycomb funnel box, two pinned pillars, flat phone plate,
// LED mount.
//
// Toss a card into the open end of the box. It slides down a shallow ramp,
// over a rounded lip, into a card-sized pocket. Hex windows through the long
// walls let room light reach the card. Two identical pillars drop into plain sockets on the
// front and back walls. A cross-pin pushed through each socket boss and one
// of the holes in the post sets the height in fixed steps. Each pillar ends
// in a small square cradle with walls on three sides. The flat phone plate
// drops onto the two cradles with a tongue at each end, and the camera hole
// in the plate sits over the pocket. A block on the plate holds a CR2032
// coin cell with a 5 mm LED pushed up through the plate from below, legs
// straddling the cell, pointing down at the pocket.
//
// Print: one base, two pillars (pad down), one plate, two pins. Every part
// fits a 180 x 180 bed. Defaults suit PLA: 45 deg entry ramp, loose fits.
// Render each with
//   openscad -D 'part="base"' -o base.3mf card-scanner.scad

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Part] */
// Which part to show. "print_pillar" flips the pillar pad-down for printing.
part = "assembly"; // [assembly, base, pillar, print_pillar, plate, pin]

/* [Card] */
// Size the pocket for sleeved cards (off = un-sleeved only, a tighter pocket)
sleeved = true;
// Card width (MTG / Pokémon: 63.5)
card_w = 63.5;          // [50:0.5:90]
// Card length (MTG / Pokémon: 88.9)
card_l = 88.9;          // [70:0.5:130]
// Extra per side that a sleeve adds (standard 1.5, thick or double 2.5)
sleeve_allowance = 2.5; // [0.5:0.25:4]
// Gap per side between the card and the pocket wall
card_clearance = 1.0;   // [0.5:0.1:2]
// Depth of the card pocket (150 sleeved cards need about 50)
pocket_depth = 50;      // [30:5:80]

/* [Base] */
// Wall thickness
wall = 3;               // [2:0.5:6]
// Height of the funnel above the pocket
funnel_h = 25;          // [15:5:80]
// Horizontal run of the long entry ramp
ramp_run_end = 70;      // [20:5:120]
// Rounding of the lip where the entry ramp drops into the pocket (0 = sharp)
mouth_r = 6;            // [0:1:12]
// Horizontal run of each side ramp
ramp_run_side = 12;     // [0:1:40]
// Rounding on the outer vertical corners
corner_r = 3;           // [0:0.5:8]
// Push-out hole in the pocket floor (0 = none)
floor_hole_d = 30;      // [0:5:50]

/* [Honeycomb] */
// Hollow the block beside and below the pocket with hex cells open from the
// bottom. Cells stop flat just below the pocket top; the ramp wedge above
// stays solid for the slicer's infill.
honeycomb = true;
// Hex cell size across flats
hex_cell = 10;          // [6:1:20]
// Wall between cells
hex_wall = 1.6;         // [0.8:0.4:3]
// Solid skin kept around the pocket and below the ramps
shell = 2.4;            // [1.6:0.4:4]

/* [Wall windows] */
// Hex windows through both long walls, over the pocket, to let light in
wall_windows = true;
// Window size across flats
win_hex = 10;           // [6:1:16]
// Bar left between windows
win_bar = 3;            // [2:0.5:6]

/* [Pillar] */
// Post width (along the long axis of the base)
post_w = 32;            // [20:1:50]
// Post thickness (across the wall)
post_t = 10;            // [6:1:16]
// Post length from bottom to the start of the cradle taper
post_len = 120;         // [80:5:220]
// Depth of the socket in the base
socket_depth = 60;      // [30:5:90]
// Wall around the socket slot
socket_wall = 4;        // [2:0.5:6]
// Gap per side between the post and the socket
socket_fit = 0.4;       // [0:0.05:0.8]
// Cradle pad size (square)
pad = 40;               // [30:2:60]
// Cradle pad thickness
pad_t = 3;              // [2:0.5:5]
// Cradle wall thickness
cradle_wall = 2;        // [1.2:0.4:4]
// Gap per side between the plate tongue and the cradle walls
cradle_fit = 0.3;       // [0:0.1:0.8]

/* [Cross-pin] */
// Pin shaft diameter (also fits an M4 bolt)
pin_d = 4;              // [3:0.5:6]
// Gap per side between the pin and the boss hole
pin_fit = 0.15;         // [0:0.05:0.5]
// Pin head diameter
pin_head_d = 10;        // [6:1:16]
// Pin head thickness
pin_head_t = 3;         // [2:0.5:5]
// Number of height positions
pin_holes = 4;          // [2:1:8]
// Height step between positions
pin_pitch = 10;         // [5:1:20]
// Lowest post hole, measured from the post bottom
pin_z = 15;             // [8:1:30]
// Boss hole, measured down from the top of the base
pin_depth = 15;         // [8:1:30]

/* [Plate] */
// Plate width (along the long axis of the base)
plate_w = 110;          // [80:5:140]
// Plate thickness
plate_t = 6;            // [4:0.5:10]
// Plate corner radius
plate_corner_r = 8;     // [0:1:20]
// Camera hole size [along base length, across]
window = [70, 60];
// Camera hole corner radius
window_r = 5;           // [0:1:15]

/* [LED] */
// Add the LED and coin cell mount
led_mount = true;
// LED body diameter (5 mm LED: 5.4 with clearance)
led_d = 5.4;            // [3:0.1:11]
// Coin cell diameter (CR2032: 20)
cell_d = 20;            // [12:0.5:25]
// Coin cell thickness plus the two LED legs (CR2032: 3.2 + legs)
cell_slot = 4.6;        // [3:0.2:7]
// Which side of the plate carries the LED: -1 = entry end, 1 = far end
led_side = -1;          // [-1, 1]

/* [Label] */
// Engrave a label on the entry end of the box
label = true;
// First line
label_line1 = "Card Scanner";
// Second line
label_line2 = "by madelyn.sh";
// Font family, as fontconfig names it
label_font = "Monofur Nerd Font";
// Letter height
label_size = 7;         // [4:0.5:12]
// Engraving depth into the wall
label_depth = 0.8;      // [0.4:0.2:2]

/* [Print] */
// Bed size to check parts against
bed = [180, 180];

/* [Assembly preview] */
// Which pin hole is in use, 0 = lowest plate
height_step = 2;        // [0:1:7]

/* [Hidden] */
$fn = 256;
epsilon = 0.01;
layer_height = 0.2;     // general utility part

floor_t = 15 * layer_height;        // 3.0 mm
chamfer = 0.5;                      // break on exposed edges
cradle_h = plate_t;                 // walls end flush with the plate top
led_block_h = 14;                   // coin cell slot depth

// ---- derived sizes ---------------------------------------------------------

// Card length runs along X (the long axis of the base).
per_side = card_clearance + (sleeved ? sleeve_allowance : 0);
pocket   = [card_l, card_w] + 2 * per_side * [1, 1];

socket_blk = [post_w + 2 * socket_wall, post_t + 2 * socket_wall];

inner = [pocket.x + ramp_run_end, pocket.y + 2 * ramp_run_side];
BASE  = [inner.x + 2 * wall, inner.y + 2 * wall, floor_t + pocket_depth + funnel_h];

// Pocket sits against the far end wall, centered between the side walls.
pocket_min = [wall + ramp_run_end, wall + ramp_run_side];
pocket_c   = pocket_min + pocket / 2;

ramp_end_deg  = atan2(funnel_h, ramp_run_end);
ramp_side_deg = ramp_run_side > 0 ? atan2(funnel_h, ramp_run_side) : 90;
hex_pitch = hex_cell + hex_wall;
hex_top   = floor_t + pocket_depth - shell;   // flat ceiling of the cells
win_pitch = win_hex + win_bar;
win_depth = wall + ramp_run_side + 1;         // through the wall into the cavity
// Lip fillet: circle tangent to the pocket wall and the entry ramp
lip_c  = [pocket_min.x - mouth_r,
          floor_t + pocket_depth - mouth_r * (1 - sin(ramp_end_deg)) / cos(ramp_end_deg)];
lip_t  = lip_c + mouth_r * [sin(ramp_end_deg), cos(ramp_end_deg)];   // tangent point on the ramp

// Pillars sit in the socket bosses on the front and back walls.
pillar_spacing = BASE.y + socket_blk.y;
frustum_h = (pad - post_t) / 2;               // 45 deg taper on the widest side
pillar_h  = post_len + frustum_h + pad_t;     // post bottom to pad top

// Cross-pin: through the outer boss wall and the post, blind into the inner
// wall, stopping 1 mm short of the base wall.
boss_hole_l = socket_blk.y - 1;
pin_l       = boss_hole_l - 0.5;
post_hole_d = pin_d + 2 * (pin_fit + 0.15);   // post slides past the pin freely
boss_hole_d = pin_d + 2 * pin_fit;
step        = min(height_step, pin_holes - 1);
insertion   = pin_depth + pin_z + step * pin_pitch;

// Plate: a body between the two cradles plus a tongue into each cradle.
tongue_w = pad - 2 * cradle_wall - 2 * cradle_fit;
tongue_l = pad - cradle_wall - cradle_fit;
body_l   = pillar_spacing - pad;
plate_l  = body_l + 2 * tongue_l;
led_block = [cell_slot + 2 * 3, cell_d + 8, led_block_h];
led_pos   = [led_side * (plate_w / 2 - led_block.x / 2 - 2), 0];

base_print  = [BASE.x, BASE.y + 2 * socket_blk.y];
plate_print = [plate_w, plate_l];

echo(str("Pocket (", sleeved ? "sleeved" : "un-sleeved", "): ",
         pocket.x, " x ", pocket.y, " x ", pocket_depth, " mm"));
echo(str("Base: ", BASE.x, " x ", BASE.y, " x ", BASE.z, " mm, footprint with sockets ",
         base_print.x, " x ", base_print.y, " mm"));
echo(str("Ramp angles: entry ", ramp_end_deg, " deg, sides ", ramp_side_deg, " deg"));
echo(str("Pillar: ", pad, " x ", pad, " x ", pillar_h + cradle_h, " mm tall"));
echo(str("Pin: ", pin_d, " x ", pin_l, " mm shaft, ", pin_head_d, " mm head"));
echo(str("Plate: ", plate_w, " x ", plate_l, " mm, tongues ", tongue_w, " x ", tongue_l, " mm"));
echo(str("Plate underside above table: ",
         [for (k = [0 : pin_holes - 1])
             BASE.z - (pin_depth + pin_z + k * pin_pitch) + pillar_h],
         " mm, one per pin hole"));
if (pin_depth + pin_z + (pin_holes - 1) * pin_pitch > socket_depth)
    echo("WARNING: the highest pin hole needs more insertion than the socket depth");
if (base_print.x > bed.x || base_print.y > bed.y)
    echo(str("WARNING: base footprint exceeds the ", bed.x, " x ", bed.y, " bed"));
if (plate_print.x > bed.x || plate_print.y > bed.y)
    echo(str("WARNING: plate exceeds the ", bed.x, " x ", bed.y, " bed"));
if (pillar_h + cradle_h > bed.x)
    echo(str("WARNING: pillar is taller than ", bed.x, " mm"));

// ---- base ------------------------------------------------------------------

// Pocket and funnel, as cut from the solid block.
module cavity() {
    translate([pocket_min.x, pocket_min.y, floor_t])
        cuboid([pocket.x, pocket.y, pocket_depth + epsilon],
               anchor=BOTTOM+LEFT+FRONT);
    hull() {
        translate([pocket_min.x, pocket_min.y, floor_t + pocket_depth])
            cuboid([pocket.x, pocket.y, epsilon], anchor=BOTTOM+LEFT+FRONT);
        translate([wall, wall, BASE.z])
            cuboid([inner.x, inner.y, epsilon], anchor=BOTTOM+LEFT+FRONT);
    }
    // rounded lip: the corner between the ramp and the pocket wall, less the
    // tangent circle, swept across the pocket width
    if (mouth_r > 0)
        translate([0, pocket_min.y + pocket.y + epsilon, 0]) xrot(90)
            linear_extrude(pocket.y + 2 * epsilon)
                difference() {
                    polygon([[pocket_min.x + epsilon, floor_t + pocket_depth + epsilon],
                             [pocket_min.x + epsilon, lip_c.y],
                             [lip_t.x, lip_t.y]]);
                    translate(lip_c) circle(r=mouth_r);
                }
}

// The pocket grown by `shell`: material inside this stays solid, floor too.
module pocket_grown() {
    translate([pocket_min.x - shell, pocket_min.y - shell, -epsilon])
        cuboid([pocket.x + 2 * shell, pocket.y + 2 * shell,
                floor_t + pocket_depth + epsilon],
               anchor=BOTTOM+LEFT+FRONT);
}

// Hex cells, open from the bottom, inside the walls, outside the pocket
// shell, capped flat below the pocket top.
module honeycomb_cut() {
    intersection() {
        difference() {
            translate([wall, wall, -epsilon])
                cuboid([inner.x, inner.y, hex_top + epsilon],
                       anchor=BOTTOM+LEFT+FRONT);
            pocket_grown();
        }
        translate([wall + inner.x / 2, wall + inner.y / 2, -epsilon])
            grid_copies(spacing=[hex_pitch, hex_pitch * sqrt(3) / 2],
                        size=[inner.x + 2 * hex_pitch, inner.y + 2 * hex_pitch],
                        stagger=true)
                linear_extrude(hex_top + 2 * epsilon)
                    hexagon(id=hex_cell, spin=30);
    }
}

// Hex windows through a long wall into the pocket and funnel, skipping the
// socket boss. Flat-topped so each window bridges cleanly. `side` is -1 for
// the front wall, 1 for the back.
module wall_windows_cut(side) {
    y_face = side < 0 ? 0 : BASE.y;
    z_lo = floor_t + 5 + win_hex / 2;
    z_hi = BASE.z - 5 - win_hex / 2;
    x_max = pocket.x / 2 - win_hex / 2;
    x_min = socket_blk.x / 2 + win_bar + win_hex / 2;
    row_h = win_pitch * sqrt(3) / 2;
    n_rows = floor((z_hi - z_lo) / row_h);
    for (j = [0 : n_rows], i = [-8 : 8]) {
        x = (i + (j % 2) / 2) * win_pitch;
        z = z_lo + j * row_h;
        if (abs(x) >= x_min && abs(x) <= x_max)
            translate([pocket_c.x + x, y_face - side * epsilon, z])
                xrot(-side * 90) linear_extrude(win_depth) hexagon(id=win_hex);
    }
}

// Socket boss on one wall with its slot and pin hole. `side` is -1 for the
// front wall, 1 for the back. Modeled at the origin on the wall's outer face.
module socket_boss(side, cut=false) {
    outer = side < 0 ? FRONT : BACK;      // face away from the box
    sides = side < 0 ? [FRONT+LEFT, FRONT+RIGHT, TOP+FRONT, TOP+LEFT, TOP+RIGHT]
                     : [BACK+LEFT, BACK+RIGHT, TOP+BACK, TOP+LEFT, TOP+RIGHT];
    if (!cut) {
        cuboid([socket_blk.x, socket_blk.y, BASE.z],
               anchor=BOTTOM - outer, chamfer=1, edges=sides);
    } else {
        // slot for the post
        translate([0, side * socket_blk.y / 2, BASE.z - socket_depth])
            cuboid([post_w + 2 * socket_fit, post_t + 2 * socket_fit,
                    socket_depth + epsilon], anchor=BOTTOM);
        // pin hole from the outer face, teardrop so it prints without support
        translate([0, side * (socket_blk.y + epsilon), BASE.z - pin_depth])
            teardrop(d=boss_hole_d, l=boss_hole_l + epsilon, anchor=outer);
    }
}

// Two lines of text engraved into the entry end wall, read from outside.
module label_cut() {
    gap = label_size * 0.9;
    translate([label_depth, BASE.y / 2, BASE.z / 2]) zrot(-90) xrot(90)
        linear_extrude(label_depth + epsilon) {
            back(gap) text(label_line1, size=label_size, font=label_font,
                         halign="center", valign="center");
            fwd(gap) text(label_line2, size=label_size, font=label_font,
                           halign="center", valign="center");
        }
}

module base() {
    difference() {
        union() {
            difference() {
                offset_sweep(rect([BASE.x, BASE.y], rounding=corner_r,
                                  anchor=FRONT+LEFT),
                             height=BASE.z, top=os_chamfer(width=chamfer));
                cavity();
                if (honeycomb) honeycomb_cut();
                if (wall_windows) for (side = [-1, 1]) wall_windows_cut(side);
                if (label) label_cut();
                if (floor_hole_d > 0)
                    translate([pocket_c.x, pocket_c.y, -epsilon])
                        cyl(d=floor_hole_d, h=floor_t + 2 * epsilon, anchor=BOTTOM);
            }
            translate([pocket_c.x, 0, 0])      socket_boss(-1);
            translate([pocket_c.x, BASE.y, 0]) socket_boss(1);
        }
        translate([pocket_c.x, 0, 0])      socket_boss(-1, cut=true);
        translate([pocket_c.x, BASE.y, 0]) socket_boss(1, cut=true);
    }
}

// ---- pillar ----------------------------------------------------------------

// Post centered on the origin, bottom at z=0. The cradle on top is open
// toward +Y (the box) and walled on the other three sides. Pin holes run
// along Y; their teardrop points face down so they print pad-down.
module pillar() {
    difference() {
        union() {
            cuboid([post_w, post_t, post_len + epsilon], anchor=BOTTOM,
                   chamfer=1, except=TOP);
            // taper out to the pad, no steeper than 45 deg
            up(post_len)
                prismoid(size1=[post_w, post_t], size2=[pad, pad], h=frustum_h + epsilon);
            // pad and cradle walls
            up(post_len + frustum_h) difference() {
                cuboid([pad, pad, pad_t + cradle_h], anchor=BOTTOM,
                       chamfer=chamfer, except=BOTTOM);
                up(pad_t)
                    translate([0, cradle_wall / 2, 0])
                        cuboid([pad - 2 * cradle_wall, pad - cradle_wall + epsilon,
                                cradle_h + epsilon],
                               anchor=BOTTOM);
            }
        }
        for (k = [0 : pin_holes - 1])
            up(pin_z + k * pin_pitch)
                yrot(180) teardrop(d=post_hole_d, l=post_t + 2 * epsilon);
    }
}

// Pad down for printing: big footprint, the taper narrows as it rises, and
// the pad bridges between the two cradle walls.
module print_pillar() {
    up(pillar_h + cradle_h) xrot(180) pillar();
}

// ---- pin -------------------------------------------------------------------

// Head on the bed, shaft up. Print two, plus a spare.
module pin() {
    union() {
        cyl(d=pin_head_d, h=pin_head_t, anchor=BOTTOM, chamfer=chamfer);
        up(pin_head_t - epsilon)
            cyl(d=pin_d, h=pin_l + epsilon, anchor=BOTTOM, chamfer2=0.8);
    }
}

// ---- plate -----------------------------------------------------------------

// Camera hole centered on the origin, underside at z=0, long axis along Y
// across the box. A tongue at each end drops into a pillar cradle.
module plate() {
    difference() {
        union() {
            offset_sweep(rect([plate_w, body_l], rounding=plate_corner_r),
                         height=plate_t,
                         bottom=os_chamfer(width=1), top=os_chamfer(width=1));
            for (s = [-1, 1])
                translate([0, s * (body_l / 2 - epsilon), 0])
                    cuboid([tongue_w, tongue_l + epsilon, plate_t],
                           anchor=BOTTOM + (s > 0 ? FRONT : BACK),
                           chamfer=chamfer, edges=[TOP, BOTTOM, "Z"], except=(s > 0 ? FRONT : BACK));
            if (led_mount)
                translate([led_pos.x, led_pos.y, plate_t - epsilon])
                    cuboid([led_block.x, led_block.y, led_block.z + epsilon],
                           anchor=BOTTOM, chamfer=1, except=BOTTOM);
        }
        // camera hole
        down(epsilon)
            cuboid([window.x, window.y, plate_t + 2 * epsilon],
                   rounding=window_r, edges="Z", anchor=BOTTOM);
        if (led_mount) {
            // LED body from below; the flange stops on the underside
            translate([led_pos.x, led_pos.y, -epsilon])
                cyl(d=led_d, h=plate_t + 2 * epsilon, anchor=BOTTOM);
            // coin cell slot, open at the top, legs come up through the LED hole
            translate([led_pos.x, led_pos.y, plate_t])
                cuboid([cell_slot, cell_d + 1, led_block_h + epsilon], anchor=BOTTOM);
        }
    }
}

// ---- assembly --------------------------------------------------------------

module assembly() {
    z_post = BASE.z - insertion;
    z_pin  = BASE.z - pin_depth;
    color("gainsboro") base();
    color("silver") {
        translate([pocket_c.x, -socket_blk.y / 2, z_post]) pillar();
        translate([pocket_c.x, BASE.y + socket_blk.y / 2, z_post]) zrot(180) pillar();
    }
    color("darkgray") {
        translate([pocket_c.x, -socket_blk.y, z_pin]) xrot(-90) down(pin_head_t) pin();
        translate([pocket_c.x, BASE.y + socket_blk.y, z_pin]) xrot(90) down(pin_head_t) pin();
    }
    color("lightsteelblue")
        translate([pocket_c.x, BASE.y / 2, z_post + pillar_h]) plate();
}

if (part == "assembly")          assembly();
else if (part == "base")         base();
else if (part == "pillar")       pillar();
else if (part == "print_pillar") print_pillar();
else if (part == "plate")        plate();
else if (part == "pin")          pin();
