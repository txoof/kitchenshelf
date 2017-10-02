//2D fractal Tree w/ extra paramaters

/* [Tree Paramaters] */


module trapezoid(h = 10, b1 = 10, b2 = 5) {
  points=[[-b1/2, 0], [b1/2, 0], [b2/2, h], [-b2/2, h]];
  polygon(points);
}


module trunk(size = 100, depth = 7, seed = 7,
            widthBottom = 0.25, widthTop = 0.18, joint = 0.11, 
            minGrowth = 0.8, maxGrowth = 1.2, 
            leafScale = 0.5, leaf = false) {

    entropy = rands(0.1, leafScale, seed+2)[0];
    branchType = rands(0, 100, 1, seed+3)[0];

    //skip branches smaller than 10% of the specified size
    if (size > size*.1) {
     
      if (0 < branchType && branchType < 15) {  
        branch_one(size = size*.9, depth = depth, seed = seed+2,
                  widthBottom = widthBottom, widthTop = widthTop,
                  joint = joint, minGrowth = minGrowth, maxGrowth = maxGrowth,
                  leafScale = leafScale, leaf = leaf);
      }      if (15 < branchType && branchType < 80) {  
        branch_two(size = size*.9, depth = depth, seed = seed+2,
                  widthBottom = widthBottom, widthTop = widthTop,
                  joint = joint, minGrowth = minGrowth, maxGrowth = maxGrowth,
                  leafScale = leafScale, leaf = leaf);
      }      if (80 < branchType && branchType < 100) {  
        branch_three(size = size*.9, depth = depth, seed = seed+2,
                  widthBottom = widthBottom, widthTop = widthTop,
                  joint = joint, minGrowth = minGrowth, maxGrowth = maxGrowth,
                  leafScale = leafScale, leaf = leaf);
      }
    
      
    } else {
       if (leaf) {
        //color("red")
          leaf(size*entropy, seed);
      }
    }
}

module leaf(size, seed) {
  ratio = rands(1, 2, 1, seed+2)[0];
  scale([ratio, 1, 1]) {
    circle(r = size, $fn = 36);
  }
}

module branch_one(size, depth, seed, widthBottom, widthTop, joint,
                  minGrowth, maxGrowth, leafScale,
                  leaf) {
  sizemod = rands(minGrowth, maxGrowth, 10, seed);
  entropy = rands(0.1, leafScale, seed+2)[0];
  rotations = rands(-10, 10, 10, seed);

  //color("orange")
    trapezoid(h = size*sizemod[0], b1 = size*widthBottom, b2 = size*widthTop);

  translate([0, size*sizemod[0], 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint, $fn = 36);
        rotate([0, 0, 0+rotations[0]])
          trunk(size = size*.9*sizemod[1], depth = depth-1, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, 
                leafScale = leafScale, leaf = leaf);
      } 
    } else {
      if (leaf) {
        //color("red")
          leaf(size*entropy, seed);
      }
    }
}



module branch_two(size, depth, seed, widthBottom, widthTop, joint,
                  minGrowth, maxGrowth, leafScale,
                  leaf) {
  sizemod = rands(minGrowth, maxGrowth, 10, seed);
  entropy = rands(0.1, leafScale, seed+2)[0];
  rotations = rands(-10, 10, 10, seed);

  //color("yellow")
    trapezoid(h = size*sizemod[0], b1 = size*widthBottom, b2 = size*widthTop);

  translate([0, size*sizemod[0], 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint);
        rotate([0, 0, 30+rotations[0]])
          trunk(size = size*.9*sizemod[1], depth = depth-1, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, 
                leafScale = leafScale, leaf = leaf);
        rotate([0, 0, -30+rotations[1]])
          trunk(size = size*.9*sizemod[2], depth = depth-1, seed = seed+3,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, 
                leafScale = leafScale, leaf = leaf);
      } 
    } else {
      if (leaf) {
        //color("red")
          leaf(size*entropy, seed);
      }
    }
}

module branch_three(size, depth, seed, widthBottom, widthTop, joint,
                  minGrowth, maxGrowth, leafScale,
                  leaf) {
  sizemod = rands(minGrowth, maxGrowth, 10, seed);
  entropy = rands(0.1, leafScale, seed+2)[0];
  rotations = rands(-10, 10, 10, seed);

  //color("green")
    trapezoid(h = size*sizemod[0], b1 = size*widthBottom, b2 = size*widthTop);

  translate([0, size*sizemod[0], 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint);
        rotate([0, 0, 50+rotations[0]])
          trunk(size = size*.9*sizemod[0], depth = depth-1, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, 
                leafScale = leafScale, leaf = leaf);
        rotate([0, 0, 0+rotations[1]])
          trunk(size = size*.9*sizemod[1], depth = depth-1, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, 
                leafScale = leafScale, leaf = leaf);
        rotate([0, 0, -50+rotations[2]])
          trunk(size = size*.9*sizemod[2], depth = depth-1, seed = seed+3,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, ,
                leafScale = leafScale, leaf = leaf);
      } 
    } else {
      if (leaf) {
        //color("red")
          leaf(size*entropy, seed);
      }
    }
}


//trunk(size = 50, depth = 6, leafScale = .5, seed = 56, minGrowth = .89, 
//      maxGrowth = 1, leaf = false);

//trunk(depth = 5, seed = 55);

