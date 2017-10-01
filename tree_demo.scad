//fractal tree demo
include <./fractal_tree.scad>

rows = 10;
columns = 10;
box = [300, 250];

module array() {
  for (i = [0:columns-1]) {
    for (j = [0:rows-1]) {
      translate([i*box[0], j*box[1]])
        trunk(seed = j*10+i);
      
      translate([i*box[0], j*box[1]-40])
        color("red")
        text(str(j*10+i), size = 40, halign = "center");
    }
  }

}

array();

