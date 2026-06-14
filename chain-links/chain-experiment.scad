

module slab() {
    intersection() {
        cube([10, 5, 2], center=true);
        
        scale([5, 3, 2])
            cylinder(5, r=1, center=true, $fs=0.1);
        
    }
}

ANGLE = 25;
RADIUS = 1.7;
module link() {
    difference() {
        slab();
        
        translate([0, 0, 1])
        rotate([ANGLE, 90, 0])
        cylinder(20, r=RADIUS, center=true, $fs=0.1);

        translate([0, 0, -1])
        rotate([-ANGLE, 90, 0])
        cylinder(20, r=RADIUS, center=true, $fs=0.1);
    }
}





module pointy_link() {
    union() {
        link();
        
        translate([2.5, 0, 0])
        cube([5.001, 5, 2.001], center=true);

        translate([5, 0, 0])
        linear_extrude(2.001, center=true)
        polygon([
            [0, 2.5],
            [0, -2.5],
            [5, 0]
        ]);
    }
}

module enby_earring() {
    color("yellow");
    link();


    color("white")
    translate([6, 0, 0]) 
    link();

    color("purple")
    translate([12, 0, 0]) 
    link();

    color("black")
    translate([18, 0, 0]) 
    pointy_link();
}

translate([0, 10, 0])
enby_earring();
translate([0, -10, 0])
enby_earring();

for (i = [0:15]) {
    translate([6 * i, 0, 0])
    link();
}