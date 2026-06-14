// Speech bubble earrings. all dimensions are in mm

// Which color(s) to render. For printing, each color must be rendered separately. -LM
// PC = false; //renders all colors for design purposes
// PC = "gray"; //I'll actually print it in black, but gray forms are easier to see in OpenSCAD since shadows are visible
PC = false; //"gray"; //"white";

// Thickness of each layer of the oreo
// Made each layer height specified separately so I could try having a thicker core. -LM
LAYER_THICKNESS_BACK = 0.5;
LAYER_THICKNESS_CORE = 2;
LAYER_THICKNESS_FRONT = 0.5;

// LAYER_THICKNESS_BACK = 1;
// LAYER_THICKNESS_CORE = 1;
// LAYER_THICKNESS_FRONT = 1;

// The design I want only has the ring in the middle layer
// If that is too much overhang, set STURDY=true to add another
// layer underneath
STURDY = false;

// Alternative ring-generating approach that doesn't depend on the height of the other layers. -LM
ALT_RING = true;
ALT_RING_HT = 1.5;
ALT_RING_COLOR = "gray";
ALT_RING_Z = 0; //if >0, will need to print with supports or update design to support bridging

// Building Blocks ======================================

// Speech bubble shape exported from p5-sketchbook

// 2D versions, so we can do boolean operations before 3D extrusion for cleaner rendering -LM
module bubble_outline_2D() {
  import("speech-bubble-outline.svg", $fn=120);
}
// white interior (inset from the outline a little bit)
module bubble_interior_2D() {
  import("speech-bubble-interior.svg", $fn=120);    
}
// 💬
module ellipsis_2D() {
  import("speech-bubble-ellipsis.svg", $fn=30);
}
module ring_outer_2D() {
  translate([0,8,0]) circle(d=4, $fn=30);
}
module ring_inner_2D() {
  translate([0,8,0]) circle(d=2.5, $fn=30);
}

// Intermediate Shapes ===================================

// Combine the outline with the ring
module bubble_and_ring_2D() {
    difference() {        
        union() {
            bubble_outline_2D();
            ring_outer_2D();
        }
        
        //Since we're working in 2D, no need for the Z scale here
        ring_inner_2D();
    }
}

module bubble_front_2D() {
  //Combines former chomp_interior and carve_outline
  difference() {
    bubble_outline_2D();
    difference() {
      bubble_interior_2D();
      ellipsis_2D();
    }
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
  //Extrudes 2D designs into 3D layers
  if(!PC || PC=="gray")
    color("gray") //Using gray instead of black just so the form is a little more visible
      translate([0, 0, 0])
        linear_extrude(LAYER_THICKNESS_BACK, convexity=5)
          if (ALT_RING) {
            bubble_outline_2D();
          } else {
            if (STURDY) {
              bubble_and_ring_2D();
            } else {
              bubble_outline_2D();
            }
          }

  if(!PC || PC=="white")
    color("white") 
      translate([0, 0, LAYER_THICKNESS_BACK])
        linear_extrude(LAYER_THICKNESS_CORE, convexity=5)
          if (ALT_RING) {
            bubble_outline_2D();
          } else {
            bubble_and_ring_2D();
          }

  if(!PC || PC=="gray")
    color("gray") 
      translate([0, 0, LAYER_THICKNESS_BACK + LAYER_THICKNESS_CORE])
        linear_extrude(LAYER_THICKNESS_FRONT, convexity=5)
          bubble_front_2D();
  
  //Alternative approach to extruding the ring
  //independently of the bubble art layers
  if(ALT_RING) {
    if(!PC || PC==ALT_RING_COLOR)
      color(ALT_RING_COLOR) 
        linear_extrude(ALT_RING_HT, convexity=5)
          difference() {
            ring_outer_2D();
            ring_inner_2D();
            //Remove the bubble outline - the ring will sit just outside it. TODO what happens in slicer if I don't do this?
            bubble_outline_2D();
          }
  }
}

// Scene ===================================================

// PRINT: this is the design I want
// mirrored_pair() 
oreo_earring();
