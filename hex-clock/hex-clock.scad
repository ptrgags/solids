include <../common/point_groups.scad>

module ticks() {
  linear_extrude(10)
  cyclic(12)
  translate([80, 0])
  square([50, 5], center=true);
}

module bestagon() {
  linear_extrude(10)
  circle(r=100, $fn=6);
}

difference() {
  bestagon();
  
  translate([0, 0, 5])
  ticks();
}