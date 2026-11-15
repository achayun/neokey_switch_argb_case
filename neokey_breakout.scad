/*
   NeoKey ARGB breakout (Adafruit #4978)
   PCB geometry taken from the Adafruit Eagle file at:
    https://github.com/adafruit/Adafruit-NeoKey-Breakout-PCB

    Outline 19.05 x 21.59, R2.54 corners, MX key base center at origin.
    Two 2.54mm clearance holes for mounting.
    Two 5 through-hole headers for IN and OUT connections.

    SPDX-License-Identifier: CERN-OHL-P-2.0
*/

pcb_w = 19.05;
pcb_l = 21.59;
pcb_thickness = 1.60;
pcb_corner_radius = 2.54;

// Mounting holes for the PCB
pcb_mount_hole_d = 2.54;
pcb_mount_holes = [
    [-7.62, -5.715],
    [ 7.62,  5.715]
];

// Header through-holes: 2 rows of 5
pcb_header_hole_d = 1.0;
pcb_header_x = [-5.08, -2.54, 0, pcb_mount_hole_d, 5.08];
pcb_header_y = [-8.89, 8.89];
