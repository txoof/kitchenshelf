r = 12;
h = 10;

module spacer() {
  difference() {
    circle(r = r, center = true);
    translate([h, 0, 0])
      square(r*2, center = true);
  }
}

for (i=[0:2]) {
  for (j = [0:1]) {
    translate([r*1.1*j, r*2.1*i, 0])
      spacer();
  }
}
