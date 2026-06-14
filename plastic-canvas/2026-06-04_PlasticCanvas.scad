$fs = 0.1;
$fa = 1;

COUNT = 14.0;
MM_PER_INCH = 25.4;
SPACING = 1/COUNT * MM_PER_INCH;
THICKNESS = 1;

OUTER_RADIUS = SPACING / 6.0;
INNER_RADIUS = OUTER_RADIUS * 0.5;

// number of cross stitch grid squares
// Ideally I'd like to do this with 50x70 squares...
// but that seems kinda expensive
N = 50 / 2;
M = 70 / 2;

// (UNUSED) - the actual shape used on the plastic canvas I have has
// a bit of a bevel, kinda like an hourglass
module hole() {
    union() {
        translate([0, 0, -0.001])
        cylinder(
            2 * THICKNESS,
            r1=INNER_RADIUS,     
            r2=OUTER_RADIUS);
        
        translate([0, 0, 0.001])
        mirror([0, 0, 1])
        cylinder(
            2 * THICKNESS,
            r1=INNER_RADIUS,
            r2=OUTER_RADIUS);
    }
}


module dots() {
    for (i = [0:M], j=[0:N]) {
        translate([i * SPACING, j * SPACING, 0])
        circle(INNER_RADIUS);        
    }
}

module poke_holes() {
  difference() {
    
    translate([-2 * SPACING, -2 * SPACING])
    square([(M + 4) * SPACING, (N + 4) * SPACING]);

    dots();
  }
}

linear_extrude(THICKNESS)
poke_holes();