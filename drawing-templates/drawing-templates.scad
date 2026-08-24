// Convert 
INCH = 25.4;
ATC = [2.5, 3.5] * INCH;
BOOKMARK = [2, 6] * INCH;

// Select one of these!
SHAPE = ATC;
//SHAPE = BOOKMARK;

// 1 cm margin around the shape
MARGIN = 20 * [1, 1];

THICKNESS = 5;

linear_extrude(THICKNESS, center=true)
difference() {
  square(SHAPE + MARGIN, center=true);
  square(SHAPE, center=true);
}