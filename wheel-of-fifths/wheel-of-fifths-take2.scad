include <../common/units.scad>
include <../common/color_layer.scad>

$fa = 1;
$fs = 0.1;

DISC_DIAMETER = 7 * INCH;
DISC_RADIUS = 0.5 * DISC_DIAMETER;
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
    cube([BASE_WIDTH, BASE_HEIGHT, BASE_THICKNESS], center=true);
    
    z_offset = 0.5 * (BASE_THICKNESS + BASE_DISC_THICKNESS);
    translate([-1 * INCH, 0, z_offset])
    cylinder(
      BASE_DISC_THICKNESS, DISC_RADIUS, DISC_RADIUS, center=true);
    
    translate([3.5 * INCH, 0, BASE_THICKNESS])
    turntable_arm();
  }
}

turntable();

