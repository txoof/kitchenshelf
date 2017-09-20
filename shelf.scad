//Kitchen Shelf
include <../libraries/voronoi.scad>

shelfX = 400;
shelfY = 200;
shelfZ = 80;

shelfBack = 180;
supportZ = shelfBack*.8;

finger = 10;

material = 4.2;

wall = 5;

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

function randVect(min=0, max=100) = rands(min, max, 2);


module shelfPolyYZ(seed=[25]) {
  //seed=rands(1,50, 1);
  edgeThick = wall+material;

  maxFingerY = floor(shelfY/finger);
  maxFingerZ = floor(shelfZ/finger);

  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;

  points = [[0,0], [shelfY, 0], [shelfY, shelfZ], [0, supportZ]];
  angle = atan((supportZ-shelfZ)/shelfY);

  /*
  pointsSM = [[wall, wall], //lower left
              [shelfY-wall, wall], //lower right
              [shelfY-wall, shelfZ-(wall/4)],
              [wall, (shelfZ-wall/2)+(shelfY-2*wall/2)*tan(angle)]];
  */
  pointsSM = [[edgeThick, edgeThick], //lower left corner
              [shelfY-edgeThick, edgeThick], //lower right corner
              [shelfY-edgeThick, shelfZ-edgeThick/2],
              [edgeThick, shelfZ-edgeThick/2+(shelfY-2*edgeThick)*tan(angle)]];

    translate([-shelfY/2, -supportZ/2, 0])
    union() {
      difference() {
        polygon(pointsSM);
        translate([-shelfY/3, -shelfY/2, 0])
        resize([shelfY*1.5, shelfY*1.5, 0])
          random_voronoi(nuclei=false, n=64, round=13, min=0, max=400, seed=round(seed[0]));
      
      }
      
      difference() {
        polygon(points);
        polygon(pointsSM);
        //bottom edge
        translate([(shelfY-uFingerY*finger)/2, 0, 0])
          rotate([])
          insideCuts(length = shelfY, finger = finger, cutD = material, uDiv = uFingerY);

        translate([shelfY, (shelfZ-uFingerZ*finger)/2, 0])
          rotate([0, 0, 90])
          insideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);
      }
    }
}

//!shelfPolyYZ();
module shelfBack() {
  
}


module shelf2D() {
  shelfXY();

  translate([0, -(shelfY/2+shelfZ/2+separation)])
    rotate([0, 0, 180])
    shelfXZ();

  translate([(shelfX/2+supportZ/2+separation), 0, 0])
    rotate([0, 0, -90])
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

shelf2D();

//shelf3D();




