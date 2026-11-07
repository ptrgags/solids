// thickness of each slice in mm
THICKNESS = 3;
// How much additional width to allow for the slits
CLEARANCE = 0.3;
// height of the tallest part in inches
HEIGHT = 4;

/* [Hidden] */

INCH = 25.4; // mm

module base() {
  polygon([
    [0, 0],
    [3*INCH, 0],
    [3*INCH, INCH],
    [2*INCH, 0.5 * INCH],
    [INCH, HEIGHT * INCH],
    [0, HEIGHT * INCH],
  ]);
}

module slit() {
  square(
    [THICKNESS + CLEARANCE, 0.5 * HEIGHT * INCH], 
    center=true
  );
}

module top_slit() {
  translate([0.5 * INCH, 0.75 * HEIGHT * INCH])
  slit();
}

module bottom_slit() {
  translate([0.5 * INCH, 0.25 * HEIGHT * INCH])
  slit();
}

module side1() {
  difference() {
      base();
      top_slit();
  }
}

module side2() {
  translate([4 * INCH, 0])
  difference() {
    base();
    bottom_slit();
  }
}

linear_extrude(THICKNESS)
union() { 
  side1();
  side2();
}