//2D Fractal Tree

/* [Tree Parameters] */
//Random Seed
random_seed = 46; 

//depth of recursion
number_of_iterations = 9;

//starting height
height = 45; //[1:10]

//maximum size of leaf realative to the branch
leaf_scale=.6; //[0.1:10]

/* [Advanced Parameters] */
//control the amount of taper on each branch segment
width_ratio_bottom = 0.25; //[0.01:0.99]
width_ratio_top = 0.20; //[0.01:0.99]

//joint size
joint_size = 0.1; //[0.01:0.99]

//minimum size ratio of a new branch to its parent
min_rate_of_growth = 0.85; //[0.05:1.0]

//maximum size ratio of a new branch to its parent
max_rate_of_growth = 1.2; //[1.0:5.0]

//smaller numbers will be more bush-like, larger numbers more tree-like
rate_of_decay = 0.85; //[0.25:1.0]

module trapezoid(h = 10, b1 = 10, b2 = 5) {
  points=[[-b1/2, 0], [b1/2, 0], [b2/2, h], [-b2/2, h]];
    polygon(points);
    }

module leaf(r=10) {
  stretch=rands(r, r*3, 1)[0];
  resize([stretch, 0, 0])
    circle(r=r);
}


module trunk(size, depth, seed) {
  //create an array of random numbers to choose the branch type
  //operation = rands(1, 2, 1, seed+5);

  
  if (size > 5) {
    branch_two(size*.9, depth, seed+2);
  }
  /*
  //only proceed if the branch size is larger than 5
  if (size > 5) {
    //echo("size:", size, "op:", floor(operation[0]));
    if (floor(operation[0]) == 0) {
      branch_one(size*.9, depth, seed+1);
    }

    if (floor(operation[0]) == 1) {
      branch_two(size*.9, depth, seed+2);
    }

    if (floor(operation[0]) == 2) {
      branch_three(size*.9, depth, seed+3);
    }

  }
  */
}

module branch_one(size, depth, seed=1) {
  //sizemod = rands(rate_of_decay, 1.15, seed+1);
  sizemod = rands(min_rate_of_growth, max_rate_of_growth, 10, seed+1);
  entropy = rands(0.5, leaf_scale, seed+2)[0];
  rotations = rands(-20, 20, 10, seed+3);

  
  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
  //move to the tip of the branch
  translate([0, size, 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint_size);
        rotate([0, 0, 0+rotations[0]])
          trunk(size*.9, depth-1, seed+1);
        /*
        rotate([0, 0, -40+rotations[1]])
          trunk(size*.9, depth-1, seed+2);
        */

      }
    } else {
      color("red")
        circle(size*entropy[0]);
    }
}

module branch_two(size, depth, seed=1) {
  //sizemod = rands(rate_of_decay, 1.15, 10);
  sizemod = rands(min_rate_of_growth, max_rate_of_growth, 10, seed+1);
  entropy = rands(0.01, leaf_scale, seed+2)[0];
  rotations = rands(-25, 25, seed+3);

  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
  
  translate([0, size, 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint_size);
        rotate([0, 0, 30+rotations[0]])
          trunk(size*.9*sizemod[0], depth-1, seed+2);
        rotate([0, 0, -30+rotations[1]])
          trunk(size*.9*sizemod[1], depth-1, seed+3);
      }

    } else {
      color("red")
        leaf(r=size*entropy);
        //circle(r = size*entropy);
    }
}

module branch_three(size, depth, seed=1) { 
  sizemod = rands(rate_of_decay, 1.15, 10);
  entropy = rands(0.5, leaf_scale, 1)[0];
  rotations = rands(-40, 40, 10);

  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
  
  translate([0, size, 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint_size);
        rotate([0, 0, 0+rotations[0]])
          trunk(size*.9*sizemod[0], depth-1, seed+2);
        rotate([0, 0, 10+rotations[1]])
          trunk(size*.9*sizemod[1], depth-1, seed+3);
        rotate([0, 0, -10+rotations[2]])
          trunk(size*.9*sizemod[2], depth-1, seed+3);
      
      }
    }
}
 

trunk(height, number_of_iterations, random_seed);



