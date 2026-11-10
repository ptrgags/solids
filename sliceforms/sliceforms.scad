// this must match the value used when exporting on my website
PIXELS_PER_INCH = 100;
// Thickness of the slices, also the width of the slits
THICKNESS_MM = 2;
// How much clearance to give. Smaller will produce a more rigid model, larger will make the slices rotate more easily.
CLEARANCE = 0.1;



MM_PER_PIXEL = 25.4 / PIXELS_PER_INCH;

linear_extrude(THICKNESS_MM - CLEARANCE)
import("sliceform-single.svg");