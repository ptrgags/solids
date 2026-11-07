// Cyclic group C_n. It always rotates around the z axis
module cyclic(n) {
    for (i=[0:(n - 1)]) {
        angle = i * 360 / n;
        rotate([0, 0, angle])
        children();
    }
}
