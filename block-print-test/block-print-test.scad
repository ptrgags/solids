// filename of PNG file to make into a printing block
IMAGE = "tile16_x2.png";
// Pixel art dimensions before scaling by 2x
PIXEL_W = 16;
PIXEL_H = 16;

// surface() maps pixels to vertices, so I export the PNG from Aseprite
// at 2x the size. The width is the number of _faces_ which is one less
// than the number of vertices.
W = 2 * PIXEL_W - 1;
H = 2 * PIXEL_H - 1;

// Desired size of the block print
INCH = 25.4;
BLOCK_W = 2 * INCH;
BLOCK_H = 2 * INCH;
BLOCK_THICKNESS = 3;

module normalized_heightmap() {
  // surface(invert=true) produces a mesh that's [0, 1] above the xy-plane
  // and [0, -100] below it. so divide it by 100 to normalize it so the height
  // is between [-1, 1/100].
  // also scale the width and height so they are 1
  scale([1/W, 1/H, 1/100])
  surface(IMAGE, invert=true);
}

// scale up the print to be the size we want
scale([BLOCK_W, BLOCK_H, BLOCK_THICKNESS])
normalized_heightmap();
