//fractal test
// http://www.instructables.com/id/Procedurally-Generated-Trees/

//depth of recursion (warning: each iteration will take exponentially more time to process)
number_of_iterations = 5; // [1:10]

//starting height of the first branch
height = 45; //[1:100]


//control the amount of taper on each branch segment
width_ratio_bottom = 0.25; //[0.01:0.99]
width_ratio_top = 0.20; //[0.01:0.99]

//size of the "knuckles" between segments
knuckle_size = 0.25; //[0.01:0.99]

//smaller numbers will be more bush-like, larger numbers more tree-like
rate_of_decay = 0.75; //[0.25:1.0]

//number of faces on the cylinders
level_of_smoothness = 16; // [4:100]

//number of faces on the spheres
leaf_smoothness = 16; // [4:100]

//number of faces on the base/stand
base_smoothness = 60; //[20:200]


module trunk(size, depth) {
  branch_one(size*.9, depth);
}

module branch_one(size, depth) {
  color("blue")
    cylinder(h = size, r1 = size*width_ratio_bottom, r2 = size*width_ratio_top);
  translate([0, 0, size])
    if (depth > 0) {
      union() {
        sphere(size*knuckle_size);
        rotate([0, 30, 0])
          trunk(size*.9, depth-1);
        rotate([0, 30, 180])
          trunk(size*.9, depth-1);
      }
    } else {
      color("red")
        sphere(size*.5, $fn=leaf_smoothness);
    }
}

trunk(height, number_of_iterations, $fn=level_of_smoothness);
