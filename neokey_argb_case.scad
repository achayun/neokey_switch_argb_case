/*
 * NeoKey ARGB enclosure.
 * Units: mm.

 * REFERENCE DATUM / ORIENTATION (relative to the breakout top side):
 * X+ right, Y+ toward the top row of five through-holes of "OUT" header,
 * Y- toward the soldered five-way of "IN" header JST XH connector/cable exit.
 * Z+ toward the Cherry MX switch; Z- JST and Kailh socket.
 * Z - Centered around the PCB top, so the switch base is +Z from 0 and the JST is -Z includes the PCB thickness
 * Y - Centered around the MX switch center, which is the PCB center

 * Assembly:
 * - Place the JST header in breakout "IN" position
 * - Place the breakout with JST in the case base
 * - Solder the JST to the breakout board
 * - Insert the MX switch base in the Kailh socket
 * - Place the lid on top of the base, bezel retaining fingers stop 0.15 mm above the PCB top

 * Generating outputs using `part` variable:
 * = "case"      => both pieces on the print bed (lid face down)
 * = "base"      => only base (print orientation)
 * = "lid"       => only lid (face down for printing)
 * = "assembled" => base and lid assembled, no reference parts
 * = "preview"   => assembled case with transparent mock PCB, JST, MX
 * = "exploded"  => open exploded view with reference parts

 * Print orientation: base bottom down; lid outside face down.
 * Suggested FDM settings: PETG, 0.20 mm layers, 0.4 mm nozzle, 3 perimeters.
 *
 * SPDX-License-Identifier: CERN-OHL-P-2.0
 */

part = "preview";

include <neokey_breakout.scad>
include <mx_switch.scad>
include <jst.scad>

// -------- Placement of the PCB - center of design ------
pcb_top_z = 0; // Center of reference
pcb_bottom_z = -pcb_thickness;

// -------- Case geometry --------
case_wall_thickness = 3.00; // Conservative thick walls
case_corner_radius = 3.8;
case_pcb_clearance = 0.5;   // X and Y clearances for the breakout
jst_y_clearance = 1.0;  // Some freedom for the JST
jst_z_clearance = 1.0;

pcb_mount_h = jst_h + jst_z_clearance; // Vertical distance from bottom of PCB to surface. The PCB sits on the JST, with some extra clearance
pcb_cavity_w = pcb_w + case_pcb_clearance * 2;
pcb_cavity_l = pcb_l + case_pcb_clearance * 2;
cavity_corner_radius = max(0.45, case_corner_radius - case_wall_thickness);

case_x_max = pcb_w / 2 + case_pcb_clearance + case_wall_thickness;
case_x_min = -case_x_max;
case_y_min = -(pcb_l / 2 + jst_d_net + jst_y_clearance); // extended end provides room for right-angle JST
case_y_max = pcb_l / 2 + case_pcb_clearance + case_wall_thickness; // On the other side, the case extends

// ------ PCB Support cubes --------
pcb_support_overlap = 0.85;
pcb_support_wall_embed = 0.30;
pcb_support_length = 1.40;
pcb_support_end_inset = 1.90; // Gap from PCB edge to support edge
pcb_support_y = pcb_l/2
              - pcb_support_length/2
              - pcb_support_end_inset;

// -------- Base part Geometry ----------
lid_thickness = 2.20;
base_floor_thickness = 2.20;
// The base of the case with the lid should reach almost to the middle of the MX switch base, to allow the keycap to fully travel
base_z_max = mx_body_bottom_part_height - (lid_thickness + 0.2);
base_z_min = -(base_floor_thickness + pcb_mount_h + pcb_thickness);

// -------- Lid geometry -----------
mx_opening_clearance = 0.45;
mx_opening = mx_body_width + mx_opening_clearance * 2;

// Lid skirt registers in the cavity, with intentionally adjustable fit.
lid_clearance = 0.28; // horizontal per-side clearance for FDM
skirt_wall = 1.00;
skirt_drop = 2.35;
skirt_x_max = pcb_cavity_w / 2 - lid_clearance;
skirt_y_max = pcb_cavity_l / 2 - lid_clearance;

// Lid alignment squares and PCB retention
retainer_x = 8.77;
retainer_y = 8.00;
retainer_w = 1.02;
retainer_l = 1.35;
pcb_top_gap = 0.15;    // avoid compressing the PCB/solder mask

// Lid crush ribs for tight fit with base: https://www.youtube.com/watch?v=0h6dCeATkrU
// ribs are tapered rects with an entry ramp tilted downwards.
lid_rib_out = 0.32;     // maximum protrusion
lid_rib_embed = 0.30;   // inwards towards the skirt to ensure union
lid_rib_length = 2.50;  // along the skirt
lid_rib_height = 1.65;  // from the base of the skirt
lid_rib_ramp = 0.60;    // height of entry ramp
lid_rib_spacing = 8.0;  // Space between ribs

lid_rib_x_min = skirt_x_max - lid_rib_embed;    // The ribs start inside the skirt
lid_rib_x_max = skirt_x_max + lid_rib_out;
lid_rib_z_min = base_z_max - lid_rib_height;

// JST connector opening in end wall (cable exit towards -Y) and all the way to the top of the case base
jst_x_clearance = 0.5;
jst_exit_y_min = case_y_min - 0.1;
jst_exit_y_max = -pcb_l / 2;
jst_exit_z_min = base_z_min + base_floor_thickness;
jst_exit_z_max = base_z_max + 0.30; // open U-notch: no 17-mm bridging roof
jst_exit_width = jst_w + jst_x_clearance * 2;

// Tab from the lid down to above the JST to close the open hole
jst_lid_clearance = 0.25;  // Clearance on each side of the tab from the walls of the base
jst_lid_z_min = pcb_bottom_z + jst_lid_clearance;   // Tab gets all the way to the PCB bottom which is just above the JST
jst_lid_width = jst_exit_width - 2 * jst_lid_clearance;
jst_lid_y_min = case_y_min;
jst_lid_y_max = jst_exit_y_max - jst_lid_clearance;

$fn = 36;

// -------- Computed dimensions --------
case_width    = case_x_max - case_x_min; // 26.0;
case_length   = case_y_max - case_y_min;

case_x_center = (case_x_max + case_x_min) / 2;
case_y_center = (case_y_max + case_y_min) / 2;

pcb_support_width = pcb_support_overlap + case_pcb_clearance + pcb_support_wall_embed;

pcb_support_x = pcb_w/2 - pcb_support_overlap + pcb_support_width/2;

lid_top_z = base_z_max + lid_thickness;

assert(case_length > pcb_l + jst_d_net, "Board and header do not fit in length");
assert(pcb_cavity_w >= pcb_w + case_pcb_clearance, "Board will not fit case cavity");
assert(mx_opening >= mx_body_width + 0.35, "MX opening too small");
assert(base_z_max > pcb_top_z + 2, "Insufficient upper clearance");

// -------- Helpers --------
module roundrect_2d(w,h,r) {
    hull() for (a = [-1,1], b = [-1,1])
        translate([a*(w/2-r),b*(h/2-r)]) circle(r=r);
}

module case_outer_profile() {
    translate([0, case_y_center])
        roundrect_2d(case_width,case_length,case_corner_radius);
}

// Friction rib for the lid
module lid_friction_rib() {
    // The friction ribs are composed of two cubes, one on top of the other
    // the hull function creates convex shape between them,
    // creating a slope without defining a full polygon.
    hull() {
        // Lower, shallow end of the rib
        translate([lid_rib_x_min,
                   -lid_rib_length/2,
                   lid_rib_z_min])
            cube([
                lid_rib_embed + 0.02,
                lid_rib_length,
                0.05
            ]);

        // Upper, deep section
        translate([lid_rib_x_min,
                   -lid_rib_length/2,
                   lid_rib_z_min + lid_rib_ramp])
            cube([
                lid_rib_embed + lid_rib_out,
                lid_rib_length,
                lid_rib_height - lid_rib_ramp
            ]);
    }
}

// -------- Case base bottom shell --------
module case_base() {
    union() {
        difference() {
            // Outer shell: from base_z_min to base_z_max
            translate([0, 0, base_z_min])
                linear_extrude(base_z_max - base_z_min)
                case_outer_profile();

            // Inner cavity: starts above the enclosure floor
            translate([0, 0, base_z_min + base_floor_thickness])
                linear_extrude(
                        base_z_max - (base_z_min + base_floor_thickness) + 0.1
                        )
                // PCB cavity is PCB-centered; the outer case alone is JST-offset.
                roundrect_2d(pcb_cavity_w,pcb_cavity_l,cavity_corner_radius);

            // Open-top JST connector/wire clearance in the -Y end wall.
            translate([-jst_exit_width/2, jst_exit_y_min, jst_exit_z_min])
                cube([
                        jst_exit_width,
                        jst_exit_y_max - jst_exit_y_min,
                        jst_exit_z_max - jst_exit_z_min
                ]);
        }
        // PCB support cubes
        for (sx = [-1, 1], sy = [-1, 1])
            translate([
                    sx * pcb_support_x,
                    sy * pcb_support_y,
                    base_z_min + base_floor_thickness + pcb_mount_h/2
            ])
                cube([
                        pcb_support_width,
                        pcb_support_length,
                        pcb_mount_h
                ], center=true);
    }
}

// -------- Case lid --------
module case_lid() {
    union() {
        // Upper face of enclosure, with opening for the MX button body
        difference() {
            translate([0,0,base_z_max])
                linear_extrude(lid_thickness) case_outer_profile();
            translate([0,0,base_z_max-0.1])
                linear_extrude(lid_thickness+0.2)
                square([mx_opening,mx_opening],center=true);
        }

        // Full perimeter registration skirt
        translate([0,0,base_z_max-skirt_drop])
            linear_extrude(skirt_drop+0.02)
                difference() {
                    roundrect_2d(pcb_cavity_w-2*lid_clearance,
                                 pcb_cavity_l-2*lid_clearance,
                                 max(0.40,cavity_corner_radius-lid_clearance));
                    roundrect_2d(pcb_cavity_w-2*(lid_clearance+skirt_wall),
                                 pcb_cavity_l-2*(lid_clearance+skirt_wall),
                                 0.25);
                }

        // Four retention pads just above the PCB *top* corners.
        // Narrow x locations keep them clear of the 16.5-mm MX opening.
        for (sx=[-1,1], sy=[-1,1])
            translate([sx*retainer_x,sy*retainer_y,
                      (pcb_top_z+pcb_top_gap+base_z_max)/2])
                cube([retainer_w,retainer_l,
                      base_z_max-(pcb_top_z+pcb_top_gap)],center=true);

        // Crush ribs - two on each wall, around the center
        for (sx = [-1, 1], sy = [-1, 1])
            translate([0, sy * lid_rib_spacing/2, 0])
                scale([sx, 1, 1])
                    lid_friction_rib();
        for (sx = [-1, 1])
            translate([sx * lid_rib_spacing/2, skirt_y_max - skirt_x_max, 0])
                rotate([0, 0, 90])
                lid_friction_rib();

        // Tab extending down from lid into JST opening
        translate([ -jst_lid_width/2, jst_lid_y_min, jst_lid_z_min ])
            cube([
                    jst_lid_width,
                    jst_lid_y_max - jst_lid_y_min,
                    base_z_max - jst_lid_z_min
            ]);
    }
}

// -------- Non-printing reference objects for fit inspection --------
module pcb_reference() {
    color([0.06,0.17,0.10,0.87])
        translate([0,0,pcb_bottom_z])
            linear_extrude(pcb_thickness)
                difference() {
                    roundrect_2d(pcb_w,pcb_l,pcb_corner_radius);
                    // Mounting holes
                    for (hole = pcb_mount_holes)
                        translate([hole[0], hole[1]])
                            circle(d=pcb_mount_hole_d);

                    // Header through-holes
                    for (x = pcb_header_x, y = pcb_header_y)
                        translate([x, y])
                            circle(d=pcb_header_hole_d);
                }
    // Kailh hot-swap socket: bottom-side envelope, not a CAD reproduction.
    color([0.12,0.12,0.13,0.78])
        translate([0.6,3.8,pcb_bottom_z-1.60])
            cube([11.0,6.0,3.1],center=true);
    // JST S5B-XH-A right-angle, soldered to the "IN" 5-pin row, bottom side.
    color([0.91,0.90,0.76,0.75])
        translate([0,-13.4,pcb_bottom_z - jst_h/2])
            cube([jst_w,jst_d_net,jst_h],center=true);
}
module switch_reference() {
    // Base
    color([0.78,0.79,0.75,0.55])
        translate([0,0,pcb_top_z + mx_body_height/2])
            cube([mx_body_width,mx_body_width,mx_body_height],center=true);
    // Stem
    color([0.10,0.10,0.11,0.92])
        translate([0,0,pcb_top_z + mx_body_height + mx_stem_height/2])
            cube([mx_stem_width,mx_stem_width,mx_stem_height],center=true);
}

// -------- Output selection --------
if (part == "base") {
    case_base();
} else if (part == "lid") {
    // Print with the outside of the bezel on the build plate.
    translate([0,0,lid_top_z]) rotate([180,0,0]) case_lid();
} else if (part == "case") {
    case_base();
    translate([case_width+13,0,lid_top_z])
        rotate([180,0,0]) case_lid();
} else if (part == "assembled") {
    case_base();
    case_lid();
} else if (part == "exploded") {
    color([0.25,0.43,0.57,0.9]) case_base();
    pcb_reference();
    switch_reference();
    color([0.9,0.62,0.29,0.9])
        translate([0,0,10]) case_lid();
} else { // preview
    color([0.25,0.43,0.57,0.90]) case_base();
    pcb_reference();
    switch_reference();
    color([0.9,0.62,0.29,0.88]) case_lid();
}
