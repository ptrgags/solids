// Diameter of button's main circle
D_OUTER = 15;
// Diameter of buttons' inner circle
D_INNER = 12;
// Diameter of one of the four holes
D_HOLE = 2;
// spacing between adjacent circles
SPACING = 1;
// Maximum thickness of the full button
THICKNESS = 2;
DEPTH = 1;

module klein4() {
    children();
  
    mirror([1, 0, 0])
    children();
  
    mirror([0, 1, 0])
    children();
  
    rotate([0, 0, 180])
    children();
}

module holes() {
  offset = 0.5 * SPACING + 0.5 * D_HOLE;
  klein4()
  translate([offset, offset, 0])
  circle(d=D_HOLE, $fn=100);
}

module body() {
  difference() {
    circle(d=D_OUTER, $fn=100);
    holes();
  }
}

difference() {
  linear_extrude(THICKNESS, convexity=20)
  body();
  
  translate([0, 0, THICKNESS - DEPTH])
  cylinder(d=D_INNER, h=THICKNESS, $fn=100);
}