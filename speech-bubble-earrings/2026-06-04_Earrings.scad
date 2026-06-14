// Speech bubble earrings. all dimensions are in mm

// Thickness of the print in mm
THICKNESS = 4;
THICKNESS_INTERIOR = 1.5;

// Building Blocks ======================================

// Speech bubble shape exported from p5-sketchbook
// black outline
module bubble_outline() {
    import("speech-bubble-outline.svg");
}
// white interior (inset from the outline a little bit)
module bubble_interior() {
    import("speech-bubble-interior.svg");    
}
// 💬
module ellipsis() {
    import("speech-bubble-ellipsis.svg");
}

// Ring for attaching jewelry findings
module ring_outer() {
    translate([0, 8, 0]) circle(d=4, $fs=0.5);
}
module ring_inner() {
    translate([0, 8, 0]) circle(d=2.5, $fs=0.5);
}

// Intermediate Shapes ===================================

// Combine the outline with the ring
module bubble_and_ring() {
    difference() {
        linear_extrude(THICKNESS, center=true) {
            union() {
                bubble_outline();
                ring_outer();
            }
        }
        
        linear_extrude(2 * THICKNESS, center=true) 
            ring_inner();
    }
}

// The jewelry ring and ellipsis each take a bite out of the
// interior of the bubble
module chomp_interior(thickness) {
    difference() {
        linear_extrude(thickness, center=true) bubble_interior();
        
        linear_extrude(2 * thickness, center=true) ring_outer();
        linear_extrude(2 * thickness, center=true) ellipsis();
    }
}

// Now use the interior portion to carve a well in the outline
module carve_outline() {
    difference() {
        bubble_and_ring();
        translate([0, 0, 2]) chomp_interior(THICKNESS);
    }
}

// Full earring. Two parts here
module earring() {
    color("#000000") carve_outline();
    color("#ffffff") 
        translate([0, 0, THICKNESS_INTERIOR / 2]) 
        // scale it a tiny bit bigger horizontally 
        // so it intersects the outline
        // (not sure if this is needed, the tutorial mentioned
        // needing to overlap shapes)
        scale([1.001, 1.001, 1.001]) 
        chomp_interior(THICKNESS_INTERIOR);
}

// Pair of Earrings ======================================

module mirrored_pair() {
    translate([0, -10, 0])
    children();
    translate([0, 10, 0])
        mirror([1, 0, 0])
        children();
}

// "Oreo" Version =======================================

module carve_outline_through() {
    difference() {
        bubble_and_ring();
        scale([1, 1, 2]) chomp_interior(THICKNESS);
    }
}

module oreo_earring_preview() {
    color("black")
        translate([0, 0, -1 - 0.2])
        scale([1, 1, 0.25]) 
        bubble_and_ring();
    color("white") 
        scale([1, 1, 0.25]) 
        bubble_and_ring();
    color("black") 
        translate([0, 0, 1 + 0.2])
        scale([1, 1, 0.25])
        carve_outline_through();    
}

module oreo_earring() {
    union() {
        scale([1, 1, 0.5])
        bubble_and_ring();
    
        translate([0, 0, 1.5 - 0.001])
        scale([1, 1, 0.25])
        carve_outline_through();
    }
}

// Scene ===================================================

// LEFT (DO NOT PRINT)
// Original attempt - the speech bubble is two objects that
// intersect in space. I don't know if that's possible to print...
translate([50, 0, 0])
    mirrored_pair() 
    oreo_earring_preview();

// ... so instead of that, here's an alternative version where
// each layer is a single color.
// this first 

// CENTER (PRINT) 
// the actual thing to print. 3mm thick, print the bottom
// 1mm in black, middle mm in white, top mm in black again
// (though... is that a pain to switch colors twice?)
mirrored_pair() 
    oreo_earring();

// RIGHT (DO NOT PRINT) 
// Colored preview of the oreo print for desired results
// I like this better than the original attempt!
// note that the layers do not overlap
translate([-50, 0, 0])
    mirrored_pair() earring();
