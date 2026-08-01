// dimensions of a 4x4 plate
WIDTH_PLATE = 32;
// This is the thickness of the plate itself
// not including the raised studs
THICKNESS_PLATE = 3.2;

SPACING = 2;
STRIDE = SPACING + WIDTH_PLATE;

OVERALL_WIDTH = 4 * WIDTH_PLATE + 3 * SPACING;

MARGIN = 4;
FRUSTUM_TOP_WIDTH = OVERALL_WIDTH + 2 * MARGIN;

module cutouts() {
  translate([-0.5 * OVERALL_WIDTH, -0.5 * OVERALL_WIDTH])
  for (i=[0:3], j=[0:3]) {
    translate(STRIDE * [i, j])
    linear_extrude(THICKNESS_PLATE)
    square(WIDTH_PLATE);
  }  
}

module shallow_cut() {
  translate([
    -0.5 * OVERALL_WIDTH,
    -0.5 * OVERALL_WIDTH, 
    0.5 * THICKNESS_PLATE
  ])
  linear_extrude(0.5 * THICKNESS_PLATE)
  square(OVERALL_WIDTH);  
}

module base() {
  translate([0, 0, THICKNESS_PLATE])
  mirror([0, 0, 1])
  linear_extrude(2 * THICKNESS_PLATE, scale=1.1)
  square(FRUSTUM_TOP_WIDTH, center=true);
}

difference() {
  base();
  shallow_cut();
  cutouts();
}