//2D fractal Tree w/ extra paramaters

/* [Tree Paramaters] */


module trapezoid(h = 10, b1 = 10, b2 = 5) {
  points=[[-b1/2, 0], [b1/2, 0], [b2/2, h], [-b2/2, h]];
  polygon(points);
}

module trunk(size = 50, depth = 6, seed = 40,
            widthBottom = 0.25, widthTop = 0.20, joint = 0.1, 
            minGrowth = 0.8, maxGrowth = 1.2, 
            leafScale = 0.5, leaf = false) {

    entropy = rands(0.1, leafScale, seed+2)[0];

    if (size > 5) {
      branch_two(size = size*.9, depth = depth, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop,
                joint = joint, minGrowth = minGrowth, maxGrowth = maxGrowth,
                leafScale = leafScale, leaf = leaf);
    } else {
       if (leaf) {
        color("red")
          leaf(size*entropy, seed);
      }
    }
}

module leaf(size, seed) {
  ratio = rands(1, 2, 1, seed)[0];
  scale([ratio, 1, 1]) {
    circle(r = size);
  }
}

module branch_two(size, depth, seed, widthBottom, widthTop, joint,
                  minGrowth, maxGrowth, leafScale,
                  leaf) {
  sizemod = rands(minGrowth, maxGrowth, 10, seed);
  entropy = rands(0.1, leafScale, seed+2)[0];
  rotations = rands(-10, 10, 10, seed);

  color("blue")
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
                minGrowth = minGrowth, maxGrowth = maxGrowth, decay = decay,
                leafScale = leafScale, leaf = leaf);
      } 
    } else {
      if (leaf) {
        color("red")
          leaf(size*entropy, seed);
      }
    }
}

//trunk(size = 50, depth = 8, leafScale = .5, seed = 42, minGrowth = .7, leaf = true);
