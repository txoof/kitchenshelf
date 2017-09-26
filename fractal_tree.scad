//2D fractal Tree w/ extra paramaters

/* [Tree Paramaters] */


module trapezoid(h = 10, b1 = 10, b2 = 5) {
  points=[[-b1/2, 0], [b1/2, 0], [b2/2, h], [-b2/2, h]];
  polygon(points);
}

module trunk(size = 50, depth = 5, seed = 10,
            widthBottom = 0.25, widthTop = 0.20, joint = 0.1, 
            minGrowth = 0.85, maxGrowth = 1.2, decay = 0.85,
            leafScale = 0.5) {

    branch_two(size = size*.9, depth = depth, seed = seed+2,
              widthBottom = widthBottom, widthTop = widthTop,
              joint = joint, minGrowth = minGrowth, maxGrowth = maxGrowth,
              decay = decay, leafScale = leafScale);
}

module leaf(size, seed) {
  ratio = rands(1, 2, 1, seed)[0];
  scale([ratio, 1, 1]) {
    circle(r = size);
  }
}

module branch_two(size, depth, seed, widthBottom, widthTop, joint,
                  minGrowth, maxGrowth, decay, leafScale = 0.5,
                  leaf = false) {
  sizemod = rands(minGrowth, maxGrowth, 10, seed+1);
  entropy = rands(0.01, leafScale, seed+2)[0];
  rotations = rands(-10, 10, 10, seed+3);

  color("blue")
    trapezoid(h = size, b1 = size*widthBottom, b2 = size*widthTop);

  translate([0, size, 0])
    if (depth > 0) {
      union() {
        circle(r = size*joint);
        rotate([0, 0, 35+rotations[0]])
          trunk(size = size*.9*sizemod[0], depth = depth-1, seed = seed+2,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, decay = decay,
                leafScale = leafScale);
        rotate([0, 0, -35+rotations[1]])
          trunk(size = size*.9*sizemod[5], depth = depth-1, seed = seed+3,
                widthBottom = widthBottom, widthTop = widthTop, joint = joint,
                minGrowth = minGrowth, maxGrowth = maxGrowth, decay = decay,
                leafScale = leafScale);
      } 
    } else {
      if (leaf) {
        color("red")
          //circle(r = size*entropy);
          leaf(size*entropy, seed);
      }
    }
}

trunk(depth = 7, decay = 0.85, leafScale = 0.5, seed = 53 );
