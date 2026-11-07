//Diameter of one of the holes
D_HOLE = 2;
// Spacing between holes
SPACING = 1;
// Diameter of the pupil
D_PUPIL = 14;
// Diameter of the sclera (white of the eye)
D_SCLERA = 20;

// Thickness of the sclera
THICKNESS_SCLERA = 1;
// Thickness of the pupil above the sclera
THICKNESS_PUPIL = 0.5;


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
  klein4()
  translate([0.5 * (SPACING + D_HOLE), 0.5 * (SPACING + D_HOLE), 0])
  cylinder(h=3 * (THICKNESS_SCLERA + THICKNESS_PUPIL), d=D_HOLE, $fn=100, center=true);
}

module eye() {
  offset = (D_SCLERA - D_PUPIL) * sqrt(2) / 4;
  cylinder(h=THICKNESS_PUPIL + THICKNESS_SCLERA, d=D_PUPIL, $fn=100);


  translate([offset, offset, 0])
  cylinder(h=THICKNESS_SCLERA, d=D_SCLERA, $fn=100);
}


difference() {
  eye();
  holes();
}