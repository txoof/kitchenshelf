//Kitchen Shelf
//include <../libraries/voronoi.scad>
include <./fractal_tree.scad>

shelfX = 400;
shelfY = 200;
shelfZ = 80;

shelfBackZ = 300;
supportZ = shelfBackZ*.5;

finger = 10;

material = 4.2;

wall = 8;

cutouts = false;
//cutouts = true;

/* [Hidden] */

//Overage for cuts
o = .01;

//separation of parts
separation = 5;

// cuts that fall completely inside the edge
module insideCuts(length, finger, cutD, uDiv) {
  numFinger = floor(uDiv/2);
  numCuts = ceil(uDiv/2);

  myCutD = cutD+o; // add an overage to make the cut complete
  // draw rectangles to make slots
  for (i=[0:numCuts-1]) {
    translate([i*finger*2, 0, 0])
      square([finger, myCutD]);
  }
}

module outsideCuts(length, finger, cutD, uDiv) {
  numFinger = ceil(uDiv/2);
  numCuts = floor(uDiv/2);

  myCutD = cutD+o; // add an overage in to make cuts slightly larger


  // calculate the length of the extra long cut at either end
  endCut = (length-uDiv*finger)/2;
  // amount of padding to add to the itterative placement of cuts
  // this is the extra long cut at either end
  padding = endCut+finger;

  square([endCut, myCutD]);

  for (i = [0:numCuts]) {
    if (i < numCuts) {
      translate([i*(finger*2)+padding, 0, 0])
        square([finger, myCutD]);
    } else {
      translate([i*finger*2+padding, 0, 0])
        square([endCut, myCutD]);
    }
  }
}

module shelfXY() {
  maxFingerX = floor(shelfX/finger);
  maxFingerY = floor(shelfY/finger);
  // usable divisions for each face - must be odd
  uFingerX = (maxFingerX%2)==0 ? maxFingerX-3 : maxFingerX-2;
  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
  

  difference() {
    color("blue")
    square([shelfX, shelfY], center=true);

  

    // Cuts along X edges of shelf (add (o)verage to put cut completely outside edge)
    translate([-uFingerX*finger/2, (-shelfY/2)-o, 0]) 
      insideCuts(length = shelfX, finger = finger+o, cutD = material, uDiv = uFingerX);
    translate([-uFingerX*finger/2, shelfY/2-material+o, 0]) 
      insideCuts(length = shelfX, finger = finger+o, cutD = material, uDiv = uFingerX);
  
    // Cuts along the Y edge of shelf 
    translate([shelfX/2, -shelfY/2, 0])
      rotate([0, 0, 90])
      outsideCuts(length = shelfY, finger = finger, cutD = material, uDiv = uFingerY);
    translate([-shelfX/2+material, -shelfY/2, 0])
      rotate([0, 0, 90])
      outsideCuts(length = shelfY, finger = finger, cutD = material, uDiv = uFingerY);

  }
}


module shelfXZ() {
  maxFingerX = floor(shelfX/finger);
  maxFingerZ = floor(shelfZ/finger);
  // usable divisions for each face - must be odd
  uFingerX = (maxFingerX%2)==0 ? maxFingerX-3 : maxFingerX-2;
  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;
  
  difference() {
    color("green")
    square([shelfX, shelfZ], center = true);
    
    translate([-shelfX/2, -shelfZ/2-o, 0])
      outsideCuts(length = shelfX, finger = finger+o, cutD = material, uDiv = uFingerX);

    translate([shelfX/2, -shelfZ/2, 0])
      rotate([0, 0, 90])
      outsideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);
    translate([-(shelfX/2-material), -shelfZ/2, 0])
      rotate([0, 0, 90])
      outsideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);
    
    difference() {
      offset(delta = -(wall+material*2)) {
        square([shelfX, shelfZ], center = true);
      }
      if (cutouts) {
        translate([0, -shelfX/2])
          trunk(size = shelfX/4, depth = 6, seed = 322, minGrowth = 0.84);
      }
    }

  }
	
}



module shelfYZ() {
  maxFingerZ = floor(shelfZ/finger);
  maxFingerY = floor(shelfY/finger);
  // usable divisions for each face - must be odd
  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;
  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
 

  difference() {
    color("yellow")
    union() {
      square([shelfY, shelfZ], center = true);

    }

    translate([shelfY/2, -uFingerZ*finger/2, 0])
      rotate([0, 0, 90])
      insideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);

    translate([-uFingerY*finger/2, -shelfZ/2, 0])
      insideCuts(length = shelfY, finger = finger, cutD = material, uDiv = uFingerY);
  }
}


module shelfPolyYZ(seed=42) {
  //seed=rands(1,50, 1);
  edgeThick = wall+material;

  maxFingerY = floor(shelfY/finger);
  maxFingerZ = floor(shelfZ/finger);

  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;

  points = [[0,0], [shelfY, 0], [shelfY, shelfZ], [0, supportZ]];


    
    translate([-shelfY/2, -supportZ/2, 0])
      color("purple")
        

      difference() {
        polygon(points);

        difference() {
          offset(delta=-(wall+material)) {
            polygon(points);
          }
          if (cutouts) {
            translate([shelfY/2, -supportZ/2, 0])
              trunk(size = supportZ/2.5, depth = 6, seed = seed, minGrowth = 0.75);
          }
        }

        //bottom edge
        translate([(shelfY-uFingerY*finger)/2, 0, 0])
          rotate([])
          insideCuts(length = shelfY, finger = finger, cutD = material, uDiv = uFingerY);

        translate([shelfY, (shelfZ-uFingerZ*finger)/2, 0])
          rotate([0, 0, 90])
          insideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);
      }
}

module shelfXZBack(r=50) {
  //#square([shelfX, shelfBackZ], center = true);
  hull() {
    translate([0, -r/2])
      square([shelfX-2*r, shelfBackZ-r], center = true);
    for (i=[-1,1]) {
      translate([i*(shelfX/2-r), shelfBackZ/2-r])
        circle(r=r);
      translate([i*(shelfX/2-r), -(shelfBackZ/2-r)])
        square(r*2, center = true);
    }

  }
}
assembleXZBack();

//shelf2D();

module assembleXZBack() {
  maxFingerY = floor(shelfY/finger);
  maxFingerX = floor(shelfX/finger);

  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
  uFingerX = (maxFingerX%2)==0 ? maxFingerX-3 : maxFingerX-2;

  union() {
    difference() {
      shelfXZBack(r=50);

      difference() {
        offset(delta = -1*(wall+material*2)) {
          shelfXZBack(r=50);
        }
        if (cutouts) {
          translate([0, -shelfBackZ])
           trunk(size = shelfBackZ/2, depth = 7, seed = 42, minGrowth = .7);
        }
      }
      translate([-shelfX/2, -shelfBackZ/2])
        outsideCuts(length = shelfX, finger = finger, cutD = material, uDiv = uFingerX);
    }
  }
}


module shelf2D() {
  shelfXY();

  translate([0, -(shelfY/2+shelfZ/2+separation)])
    rotate([0, 0, 180])
    shelfXZ();

 
  translate([(shelfX/2+supportZ/2+separation), 0, 0])
    rotate([0, 0, -90])
    shelfPolyYZ();
  
  translate([-(shelfX/2+supportZ/2+separation), 0, 0])
    rotate([180, 0, -90])
    shelfPolyYZ();

  /*
  translate([-(shelfX/2+shelfZ/2+separation), 0, 0])
    rotate([0, 180, 90])
    shelfYZ();
  translate([(shelfX/2+shelfZ/2+separation), 0, 0])
    rotate([0, 0, -90])
    shelfYZ();
  */

}

module shelf3D() {
  color("blue")
    linear_extrude(height = material, center = true)
    shelfXY();

  color("green")
    translate([0, -(shelfY/2-material/2), shelfZ/2-material/2])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    shelfXZ();

  color("yellow")
    translate([shelfX/2-material/2, 0, shelfZ/2-material/2])
    rotate([90, 0, -90])
    linear_extrude(height = material, center = true)
    shelfYZ();

  color("Khaki")
    translate([-(shelfX/2-material/2), 0, shelfZ/2-material/2])
    rotate([90, 0, -90])
    linear_extrude(height = material, center = true)
    shelfYZ();

}

//shelf2D();

//shelf3D();
