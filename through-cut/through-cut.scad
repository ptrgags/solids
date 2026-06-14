$fs = 0.1;

module outer_circles_2d() {
  for (i = [0:7]) {
    rotate([0, 0, i * 360/8])
    translate([4, 0, 0])
    circle(1);
  }  
}

module crossbars_2d() {
  for (i = [0:3]) {
    rotate([0, 0, i * 360 / 8])
    square([8, 1], center=true);
  }
}


// looks like the complement of a
// magnetron like in a microwave
// see https://en.wikipedia.org/wiki/Cavity_magnetron#Cavity_magnetron
// for a diagram
module magnetron_2d() {
  union() {
    outer_circles_2d();
    crossbars_2d();
  }
}

module cutout() {
  linear_extrude(40, twist=180, center=true)
  magnetron_2d();
}

HALF_CLEARANCE = 0.1;

module larger_cutout() {
  linear_extrude(40, twist=180, center=true)
  offset(r=HALF_CLEARANCE)
  magnetron_2d();
}

module body() {
  cylinder(20, r1=6, r2 = 0, center=true);
}


module bottom() {
  difference() {
    body();
    larger_cutout();
  }
}

module top() {
  difference() {
    body();
    difference() {
      body();
      cutout();
    }
  }
}

top();

translate([20, 0, 0])
bottom();

translate([0, 20, 0])
cutout();
