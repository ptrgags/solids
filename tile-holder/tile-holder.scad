// Extra width of the plate slots to allow the plates to fit loosely. Tweak as needed
CLEARANCE=0.4;
// How many tiles in the x-direction
TILES_X=4;
// How many tiles in the y-direction
TILES_Y=4;

/* [Hidden] */

// dimensions of a 4x4 plate
WIDTH_PLATE = 32;
// This is the thickness of the plate itself
// not including the raised studs
THICKNESS_PLATE = 3.2;

// make the cutouts a liiitle wider
WIDTH_PLATE_CUTOUT = WIDTH_PLATE + CLEARANCE;

// Add a little spacing between cutouts. This way each
// tile stays in place even as neighbors are swapped
// in/out
SPACING = 2;
CUTOUT_STRIDE = SPACING + WIDTH_PLATE_CUTOUT;

OVERALL_WIDTH_X = 
  TILES_X * WIDTH_PLATE_CUTOUT + (TILES_X - 1) * SPACING;
OVERALL_WIDTH_Y = 
  TILES_Y * WIDTH_PLATE_CUTOUT + (TILES_Y - 1) * SPACING;

MARGIN = 4;
FRUSTUM_TOP_WIDTH_X = OVERALL_WIDTH_X + 2 * MARGIN;
FRUSTUM_TOP_WIDTH_Y = OVERALL_WIDTH_Y + 2 * MARGIN;

module cutouts() {
  translate([-0.5 * OVERALL_WIDTH_X, -0.5 * OVERALL_WIDTH_Y])
  for (i=[0:TILES_X - 1], j=[0:TILES_Y - 1]) {
    translate(CUTOUT_STRIDE * [i, j])
    linear_extrude(THICKNESS_PLATE)
    square(WIDTH_PLATE_CUTOUT);
  }  
}

module shallow_cut() {
  translate([
    -0.5 * OVERALL_WIDTH_X,
    -0.5 * OVERALL_WIDTH_Y, 
    0.5 * THICKNESS_PLATE
  ])
  linear_extrude(0.5 * THICKNESS_PLATE)
  square([OVERALL_WIDTH_X, OVERALL_WIDTH_Y]);
}

module base() {
  translate([0, 0, THICKNESS_PLATE])
  mirror([0, 0, 1])
  linear_extrude(2 * THICKNESS_PLATE, scale=1.1)
  square([FRUSTUM_TOP_WIDTH_X, FRUSTUM_TOP_WIDTH_Y], center=true);
}

difference() {
  base();
  shallow_cut();
  cutouts();
}