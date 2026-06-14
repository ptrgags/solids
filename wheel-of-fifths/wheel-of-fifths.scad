$fs = 0.01;
$fa = 4;

// Which print color to use. One of
// "all", "white", "black", "purple"
COLOR = "all";

// This module applies a color to the children, and also
// sets up the logic for the COLOR variable above
module color_layer(color) {
  if (COLOR == "all" || COLOR == color)
  color(color)
  children();
}

HEPTATONIC = 7;
CHROMATIC = 12;

INCH = 25.4;
DIAMETER_OUTER = 7 * INCH;
DIAMETER_INNER = 1 * INCH;
RADIUS_OUTER = DIAMETER_OUTER * 0.5;
RADIUS_INNER = DIAMETER_INNER * 0.5;

SECTOR_R = (RADIUS_OUTER - RADIUS_INNER) / HEPTATONIC;
SECTOR_ANGLE = 360 / CHROMATIC;

// Size is based on a CD
module disc() {
  difference() {
    circle(d=DIAMETER_OUTER);
    circle(d=DIAMETER_INNER);
  }
}

module spindle() {
  union() {
    cylinder(h=1, d=DIAMETER_OUTER, center=true);
    cylinder(h=8, d=DIAMETER_INNER);
  }
}

KEYS = [
  ["F", "C", "G", "D", "A", "E", "B"],
  ["C", "G", "D", "A", "E", "B", "F#"],
  ["G", "D", "A", "E", "B", "F#", "C#"],
  ["D", "A", "E", "B", "F#", "C#", "G#"],
  ["A", "E", "B", "F#", "C#", "G#", "D#"],
  ["E", "B", "F#", "C#", "G#", "D#", "A#"],
  ["B", "Gb", "Db", "Ab", "Eb", "Bb", "F"],
  ["Gb", "Db", "Ab", "Eb", "Bb", "F", "C"],
  ["Db", "Ab", "Eb", "Bb", "F", "C", "G"],
  ["Ab", "Eb", "Bb", "F", "C", "G", "D"],
  ["Eb", "Bb", "F", "C", "G", "D", "A"],
  ["Bb", "F", "C", "G", "D", "A", "E"],
];

MODE_LABELS = ["Lyd", "Ion", "Mix", "Dor", "Aeo", "Phr", "Loc"];

DEGREE_LABELS = ["IV", "I", "V", "ii", "vi", "iii", "vii"];
TRIAD_LABELS = ["M", "M", "M", "m", "m", "m", "o"];
SEVENTH_LABELS = ["M7", "M7", "7", "m7", "m7", "m7", "ø7"];

TEXT_SIZE = 0.5;
SECTOR_THICKNESS = 0.6;

module note_labels() {
  for (i = [0:12], j=[0:6]) {
    rotate([0, 0, i * -SECTOR_ANGLE])
    translate([0, RADIUS_OUTER - SECTOR_R/2 - j * SECTOR_R, 0])
    
    scale([TEXT_SIZE, TEXT_SIZE])
    text(KEYS[i][j], halign="center", valign="center");
  }
}

module make_sector(key_index, note_index, thickness) {
  rotate([0, 0, 2.5 * SECTOR_ANGLE - key_index * SECTOR_ANGLE])
  rotate_extrude(angle=SECTOR_ANGLE)
  translate([RADIUS_OUTER - SECTOR_R / 2 - note_index * SECTOR_R, 0])
  square(thickness * SECTOR_R, center=true);
}

module wheel_cutout() {
  difference() {
    disc();
    
    for (i = [0:6]) {
      make_sector(0, i, SECTOR_THICKNESS);
    }
  }
}

module wheel_labels(labels) {
  rotate([0, 0, -18])
  for(i=[0:6]) {
    translate([0, RADIUS_OUTER - SECTOR_R / 2 - i * SECTOR_R])
    scale([TEXT_SIZE, TEXT_SIZE])
    text(labels[i], halign="left", valign="center");
  }
}

module base() {
  color("black")
  spindle();

  color("white")
  note_labels();  
}

module base_cutout() {
  difference() {
    circle(d=DIAMETER_OUTER);
    note_labels();
  }
}

module make_wheel(title, labels) {
  color_layer("purple")
  wheel_cutout();
  
  color_layer("white") {
    translate([0, 0, 1])
    wheel_labels(labels);
    
    translate([0, -25, 1])
    text(title, halign="center", valign="center");
  }
}
  
module note_disk() {
  color_layer("black")
  union() {
    base_cutout();
    
    translate([0, 0, -1])
    circle(d=DIAMETER_OUTER);
  }

  color_layer("white")
  note_labels();
}

// Scene =======================================================

// Note disk, printed face down
rotate([180, 0, 0])
note_disk();

translate([200, 0, 0])
make_wheel("Scale Degrees", DEGREE_LABELS);

translate([0, 200, 0]) 
make_wheel("Relative Modes", MODE_LABELS);

translate([0, -200, 0]) 
make_wheel("Seventh Chords", SEVENTH_LABELS);
