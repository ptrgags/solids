N = 3;
STRIDE = 3;
module cylinders() {
    for (i = [-N:N]) {
        translate([STRIDE * i, 0, 0])
        cylinder(20, r=1, center=true, $fs=0.1);
    }
}


ANGLE = 70;
module waffle_cut() {
    difference() {
        scale([10, 5, 1])
        cylinder(2, $fs=0.1, center=true);
        
        
        translate([0, 0, -0.5])
        rotate([90, 0, ANGLE])
        cylinders();

        translate([0, 0, 0.5])
        rotate([90, 0, -ANGLE])
        cylinders();

    }
}

waffle_cut();

translate([13, 0, 0])
waffle_cut();