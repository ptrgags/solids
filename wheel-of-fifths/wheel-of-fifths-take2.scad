include <../common/units.scad>
include <../common/color_layer.scad>
include <./data.scad>

// Which color to view
COLOR = "all"; // [all, gray, white, purple]

$fa = 1;
$fs = 0.1;
CONVEXITY = 5;

PREVIEW = false;
PREVIEW_INDEX = 3;

// Dimensions based on the dimensions of a CD
DISC_OUTER_DIAMETER = 7 * INCH;
DISC_OUTER_RADIUS = 0.5 * DISC_OUTER_DIAMETER;
DISC_INNER_DIAMETER = 1 * INCH;
DISC_INNER_RADIUS = 0.5 * DISC_INNER_DIAMETER;
DISC_THICKNESS = 3 * MM;
DISC_CLEARANCE = 0.3 * MM;
DISC_LABEL_THICKNESS = 1 * MM;
BASE_WIDTH = 9 * INCH;
BASE_HEIGHT = 8 * INCH;
BASE_THICKNESS = 1 * CM;
BASE_DISC_THICKNESS = 0.5 * BASE_THICKNESS;
NOTE_DISC_THICKNESS = 1 * MM;
NOTE_DISC_Z = 0.5 * BASE_THICKNESS + BASE_DISC_THICKNESS;
ARM_THICKNESS = BASE_THICKNESS;

X_DISC = -1 * INCH;

module turntable_arm() {
  linear_extrude(ARM_THICKNESS, center=true, convexity=CONVEXITY)
  union() {
    translate([0, 3] * INCH)
    square([1.5, 2] * INCH, center=true);
    
    translate([0, -3 * INCH])
    square(1 * INCH, center=true);

    square([0.5, 6] * INCH, center=true);
  }
}

module note_wheel() {
  linear_extrude(1 * MM, convexity=CONVEXITY)
  difference() {
    circle(DISC_OUTER_RADIUS);
    note_labels();
  }
}

module turntable() {
  union() {
    // rectangle for the base
    cube([BASE_WIDTH, BASE_HEIGHT, BASE_THICKNESS], center=true);
    
    // shallow cylinder for the base where the "record" goes
    z_offset = 0.5 * (BASE_THICKNESS + BASE_DISC_THICKNESS);
    translate([X_DISC, 0, z_offset])
    cylinder(
      BASE_DISC_THICKNESS,
      DISC_OUTER_RADIUS,
      DISC_OUTER_RADIUS,
      center=true
    );
    
    translate([X_DISC, 0, NOTE_DISC_Z])
    note_wheel();
    
    // taller cylinder for the spindle where records go
    spindle_radius = DISC_INNER_RADIUS - DISC_CLEARANCE;
    translate([X_DISC, 0, 0])
    cylinder(3 * CM, spindle_radius, spindle_radius);
    
    translate([3.5 * INCH, 0, BASE_THICKNESS])
    turntable_arm();
  }
}

module disc() {
  difference() {
    circle(DISC_OUTER_RADIUS);
    circle(DISC_INNER_RADIUS);
  }
}

HEPTATONIC = 7;
CHROMATIC = 12;

// Translate an object to the center of one of the sectors for
// a note
SECTOR_R = (DISC_OUTER_RADIUS - DISC_INNER_RADIUS) / HEPTATONIC;
SECTOR_THETA = 360 / CHROMATIC;
module to_sector(r_index, theta_index) {
  x = DISC_INNER_RADIUS + 0.5 * SECTOR_R + r_index * SECTOR_R;
  
  rotate([0, 0, theta_index * SECTOR_THETA])
  translate([x, 0, 0])
  children();
}

module note_label(label) {
  LABEL_SIZE = 0.6;
  rotate([0, 0, -90])
  scale([LABEL_SIZE, LABEL_SIZE, 1])
  text(label, halign="center", valign="center");
}

module note_labels() {
  for (i = [0:6], j=[0:11]) {
    label = NOTES[j][i];
    
    to_sector(i, j)
    note_label(label);
  }
}

module make_sector(r_index, theta_index, thickness) {
  x = DISC_INNER_RADIUS + 0.5 * SECTOR_R + r_index * SECTOR_R;
  start_angle = -0.5 * SECTOR_THETA + theta_index * SECTOR_THETA;
  
  rotate([0, 0, start_angle])
  rotate_extrude(angle=SECTOR_THETA, convexity=CONVEXITY)
  translate([x, 0])
  square(thickness * SECTOR_R, center=true);
}

SECTOR_THICKNESS = 0.6;
module disc_cutout() {
  difference() {
    linear_extrude(DISC_THICKNESS, convexity=CONVEXITY)
    disc();
    
    for(i=[0:6])
    make_sector(i, 0, SECTOR_THICKNESS);
  }
}

module wheel_labels(labels) {  
  LABEL_SIZE = 0.5;
  rotate([0, 0, - 0.75 * SECTOR_THETA]) 
  for(i=[0:6]) {
    to_sector(i, 0)
    rotate([0, 0, -90])
    scale([LABEL_SIZE, LABEL_SIZE])
    text(labels[i], halign="left", valign="center")
    note_label(labels[i]);
  }
}

module wheel_title(title) {
  rotate([0, 0, -90])
  translate([0, -1.5 * INCH, 0])
  text(title, halign="center", valign="center");
}

module label_disc(title, labels) {
  z = DISC_THICKNESS;
  
  color_layer("purple")
  disc_cutout();
  
  color_layer("white")
  translate([0, 0, z])
  linear_extrude(DISC_LABEL_THICKNESS, convexity=CONVEXITY) {
    wheel_title(title);
    wheel_labels(labels);
  }
}

// SCENE ==========================================

color_layer("gray")
turntable();

color_layer("white")
translate([X_DISC, 0, NOTE_DISC_Z])
linear_extrude(1 * MM)
note_labels();

if (PREVIEW) {
  translate([X_DISC, 0, 0.5 * INCH])
  rotate([0, 0, PREVIEW_INDEX * SECTOR_THETA])
  label_disc("Parallel Modes", MODE_LABELS);
}