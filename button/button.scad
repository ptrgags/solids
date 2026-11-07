
module holes() {
  translate([-1.5, -1.5, 0])
  circle(d=2, $fn=100);

  translate([-1.5, 1.5, 0])
  circle(d=2, $fn=100);

  translate([1.5, -1.5, 0])
  circle(d=2, $fn=100);

  translate([1.5, 1.5, 0])
  circle(d=2, $fn=100);
}

module body() {
  difference() {
    circle(d=15, $fn=100);
    holes();
  }
}

difference() {
  linear_extrude(2, convexity=10)
  body();
  
  translate([0, 0, 1])
  cylinder(d=12, h=2, $fn=100);
}