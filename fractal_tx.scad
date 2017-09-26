//fractal test txoof

/*[Tree Paramaters]*/
//random seed
random_seed = 45;

//maximum size of a leaf relative to the branch
leaf_scale = .10; //[0.10:10.0]

//depth of recursion
number_of_iterations = 5; //[1:10]

//starting height of frist branch
height = 45; //[1:100]

//control the amount of taper on each branch segment
width_ratio_bottom = 0.25; //[0.01:0.99]
width_ratio_top = 0.20; //[0.01:0.99]

//minimum size ratio of a new branch to its parent
min_rate_of_growth = 0.85; //[0.05:1.0]

//maximum size ratio of a new branch to its parent
max_rate_of_growth = 1.20; //[1.0:5.0]

//joint size between segments
joint_size = 0.1; //[0.1:0.99]

//smaller numbers will be more bush-like, larger numbers more tree-like
rate_of_decay = 0.75; //[0.25:1.0]

module trapezoid(h = 10, b1 = 10, b2 = 5) {
  points=[[-b1/2, 0], [b1/2, 0], [b2/2, h], [-b2/2, h]];
  polygon(points);
}


module trunk(size, depth, seed)
{
    //create an array of random numbers
    operation = rands(1, 3, 1, seed+5);

    //automatically stop if the size gets too small so we dont waste computation time on tiny little twigs
    if (size > 5)
    {
        //choose a module based on that array
        if (operation[0] < 1)
        {
            branch_one(size*.9, depth, seed+1);          
        }
        if (operation[0] < 2)
        {
            branch_two(size*.9, depth, seed+2);          
        }
        else if (operation[0] < 3)
        {
            branch_three(size*.9, depth, seed+3);          
        }
        else if (operation[0] < 4)
        {
            branch_four(size*.9, depth, seed+4);          
        }
    }
    
}


module branch_one(size, depth, seed) {
  sizemod = rands(min_rate_of_growth, max_rate_of_growth, 10, seed+1);
  entropy = rands(0.01,leaf_scale,1, seed+2);
  rotations = rands(-20, 20, 10, seed+3);

  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
  translate([0, size, 0])
    if (depth > 0) {
      union() {
        //create a joint
        circle(r = size*joint_size, center = true);
        rotate([0, 0    , 0+rotations[0]])
          trunk(size*.9, depth-1, seed+1);
      }
    
    } else {
      color("red")
        circle(size*entropy[0]);
    }
}


module branch_two(size, depth, seed) {
  sizemod = rands(min_rate_of_growth,max_rate_of_growth,10, seed+1);
  entropy = rands(0.01,leaf_scale,1, seed+2);
  rotations = rands(-20,20,10, seed+3);

  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
  translate([0, size, 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint_size, center = true);
        rotate([0, 0, 0])
          trunk(size*.9*sizemod[0], depth-1, seed+2);
        rotate([0, 0, 180])
          trunk(size*.9*sizemod[1], depth-1, seed+3);
      }
    } else {
      color("red")
        circle(size*entropy[0]);
    }
}

module branch_three(size, depth, seed) {
  sizemod = rands(min_rate_of_growth,max_rate_of_growth,10, seed+1);
  entropy = rands(0.01,leaf_scale,1, seed+2);
  rotations = rands(-20,20,10, seed+3);

  color("blue")
    trapezoid(h = size, b1 = size*width_ratio_bottom, b2 = size*width_ratio_top);
 

  translate([0, size, 0])
    cube();
    if (depth > 0) {
      union() {
        circle(r = size*joint_size, center = true);
        rotate([0, 0, 0+rotations[0]])
          trunk(size*.9*sizemod[0], depth-1, seed+4); 
        rotate([0, 0, 120+rotations[1]])
          trunk(size*.9*sizemod[1], depth-1, seed+5);
        rotate([0, 0, 240+rotations[2]])
          trunk(size*.9*sizemod[2], depth-1, seed+5);
      }
    } else {
      color("red")
        circle(size*entropy[0]);
    } 
}


trunk(height, number_of_iterations, random_seed);
