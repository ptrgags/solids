include <../common/units.scad>
include <../common/color_layer.scad>

COLOR = "gray";

$fa = 1;
$fs = 0.1;

// Dimensions based on the dimensions of a CD
DISC_OUTER_DIAMETER = 7 * INCH;
DISC_OUTER_RADIUS = 0.5 * DISC_OUTER_DIAMETER;
DISC_INNER_DIAMETER = 1 * INCH;
DISC_INNER_RADIUS = 0.5 * DISC_INNER_DIAMETER;
DISC_CLEARANCE = 0.3 * MM;
BASE_WIDTH = 9 * INCH;
BASE_HEIGHT = 8 * INCH;
BASE_THICKNESS = 1 * CM;
BASE_DISC_THICKNESS = 0.5 * BASE_THICKNESS;
ARM_THICKNESS = BASE_THICKNESS;

module turntable_arm() {
  linear_extrude(ARM_THICKNESS, center=true)
  union() {
    translate([0, 3] * INCH)
    square([1.5, 2] * INCH, center=true);
    
    translate([0, -3 * INCH])
    square(1 * INCH, center=true);

    square([0.5, 6] * INCH, center=true);
  }
}

module turntable() {
  union() {
    // rectangle for the base
    cube([BASE_WIDTH, BASE_HEIGHT, BASE_THICKNESS], center=true);
    
    disc_center = -1 * INCH;
    
    // shallow cylinder for the base where the "record" goes
    z_offset = 0.5 * (BASE_THICKNESS + BASE_DISC_THICKNESS);
    translate([disc_center, 0, z_offset])
    cylinder(
      BASE_DISC_THICKNESS,
      DISC_OUTER_RADIUS,
      DISC_OUTER_RADIUS,
      center=true
    );
    
    // taller cylinder for the spindle where records go
    spindle_radius = DISC_INNER_RADIUS - DISC_CLEARANCE;
    translate([disc_center, 0, 0])
    cylinder(3 * CM, spindle_radius, spindle_radius);
    
    translate([3.5 * INCH, 0, BASE_THICKNESS])
    turntable_arm();
  }
}

// SCENE ==========================================

color_layer("gray")
turntable();

