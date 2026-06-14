// Speech bubble earrings. all dimensions are in mm

// Thickness of each layer of the oreo
LAYER_THICKNESS = 1;

// The design I want only has the ring in the middle layer
// If that is too much overhang, set STURDY=true to add another
// layer underneath
STURDY = false;

// Building Blocks ======================================

// Speech bubble shape exported from p5-sketchbook
// black outline
module bubble_outline() {
  linear_extrude(LAYER_THICKNESS, center=true)
  import("speech-bubble-outline.svg");
}
// white interior (inset from the outline a little bit)
module bubble_interior() {
  linear_extrude(LAYER_THICKNESS, center=true)
  import("speech-bubble-interior.svg");    
}
// 💬
module ellipsis() {
  linear_extrude(LAYER_THICKNESS, center=true);
  import("speech-bubble-ellipsis.svg");
}

// Ring for attaching jewelry findings
module ring_outer() {
  translate([0, 8, 0]) 
  cylinder(LAYER_THICKNESS, d=4, $fs=0.5, center=true);
}

module ring_inner() {
  translate([0, 8, 0])
  cylinder(LAYER_THICKNESS, d=2.5, $fs=0.5, center=true);
}

// Intermediate Shapes ===================================

// Combine the outline with the ring
module bubble_and_ring() {
    difference() {        
        union() {
            bubble_outline();
            ring_outer();
        }
        
        scale([1, 1, 2])
        ring_inner();
    }
}

module chomp_interior(thickness) {
    difference() {
        bubble_interior();
        ellipsis();
    }
}

// Now use the interior portion to carve a well in the outline
module carve_outline() {
    difference() {
        bubble_outline();
        scale([1, 1, 2]) chomp_interior(LAYER_THICKNESS);
    }
}

module mirrored_pair() {
    translate([0, -10, 0])
    children();
    translate([0, 10, 0])
        mirror([1, 0, 0])
        children();
}

module oreo_earring() {
    color("black")
        translate([0, 0, -LAYER_THICKNESS])
        if (STURDY) {
          bubble_and_ring();
        } else {
          bubble_outline();
        }
    color("white") 
        bubble_and_ring();
    color("black") 
        translate([0, 0, LAYER_THICKNESS])
        carve_outline();
}

// Scene ===================================================

// PRINT: this is the design I want
mirrored_pair() 
oreo_earring();
