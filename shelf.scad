//Kitchen Shelf
//include <../libraries/voronoi.scad>
use <./fractal_tree.scad>

/*[Shelf Dimensions]*/
//X dimension (width)
shelfX = 350;
//Y dimension (depth)
shelfY = 140;
//Z dimension (height front)
shelfZ = 45;
//Z dimeiosn (height back)
shelfBackZ = 180;
//height of support (percentage of back height)
pctHeight = 60; //[30:80]

/*[material and assembly]*/
//width of finger joints
finger = 10;

//thickness of material
material = 3.3;

//wall thickness (border for cutouts)
wall = 10;

//add stylish cutouts
//cutouts = false;
cutouts = true;

//add appliances to 3D layout
appliances = true;

/*[hanger dimensions]*/
//width of hanger hole
hangerX = 20;
//height of hanger hole
hangerZ = 38;
//radius of curve at bottom of hanger hole
hangerRad = 10;

/* [Hidden] */
//support height
supportZ = shelfBackZ*pctHeight/100;

//Overage for cuts
o = .01;

//separation of parts in 2d layout
separation = 5;

//Appliance Dimensions
speakerDim = [93, 95, 156];
rpiDim = [235, 110, 135];

//shim dimensions
shimDim = [wall+material*2, shelfBackZ*.2];

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

    //left and right sides
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
          trunk(size = shelfX/4, depth = 6, seed = 7, minGrowth = 0.84);
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
    color("purple")
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

module keyhole(border = false) {
  r= border==true ? wall : 0;

  difference() {
    if (border==false) {
      keyhole(true);
    }    
    offset(r = r) {
      hull() {
        translate([0, hangerRad/2])
          square([hangerX, hangerZ-hangerRad], center = true);
        translate([0, -(hangerZ/2-hangerRad)])
          circle(r=hangerRad);
        
      }
    }

  }
}


module shelfPolyYZ(seed=42) {
  //seed=rands(1,50, 1);
  edgeThick = wall+material;

  maxFingerY = floor(shelfY/finger);
  maxFingerZ = floor(shelfZ/finger);
  maxSupportZ = floor(supportZ/finger);

  uFingerY = (maxFingerY%2)==0 ? maxFingerY-3 : maxFingerY-2;
  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;
  uFingerSupportZ = (maxSupportZ%2)==0 ? maxSupportZ-3 : maxSupportZ-2;

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

        //front edge
        translate([shelfY, (shelfZ-uFingerZ*finger)/2, 0])
          rotate([0, 0, 90])
          insideCuts(length = shelfZ, finger = finger, cutD = material, uDiv = uFingerZ);
      
        //back edge
        translate([material, (supportZ-uFingerSupportZ*finger)/2, 0])
          rotate([0, 0, 90])
          insideCuts(length = supportZ, finger = finger, cutD = material,
                    uDiv = uFingerSupportZ);
//          insideCuts(length = supportZ, finger = finger, cutD = material,
//                    uDiv = uFingerSupportZ);
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


//back portion of the shelf
module assembleXZBack(seed=74) {
  maxFingerZ = floor(supportZ/finger);
  maxFingerX = floor(shelfX/finger);

  uFingerZ = (maxFingerZ%2)==0 ? maxFingerZ-3 : maxFingerZ-2;
  uFingerX = (maxFingerX%2)==0 ? maxFingerX-3 : maxFingerX-2;

  //positions for hanger keyholes
  keyholeX = shelfX/2-wall*3-hangerX/2;
  keyholeZ = shelfBackZ/2-hangerZ/2-2*wall;

  color("orange")
  union() {
    difference() {
      //main body
      shelfXZBack(r=50);

      //cutter for the inside negative area
      difference() {
        offset(delta = -1*(wall+material*2)) {
          shelfXZBack(r = 50);
        }
        //add a fractal tree cutout to the inside
        if (cutouts) {
          translate([0, -shelfBackZ])
           trunk(size = shelfBackZ/2, depth = 7, seed = seed, joint = 0.11, 
                minGrowth = .755);
        }
      }
        //made space in tree design for keyholes
      for (i=[-1, 1]) {
        translate([i*keyholeX, keyholeZ])
          keyhole(true);
      }
      //bottom edge fingers
      translate([-shelfX/2, -shelfBackZ/2])
        outsideCuts(length = shelfX, finger = finger, cutD = material, uDiv = uFingerX);

      //left and right edge
      translate([-shelfX/2+material, -shelfBackZ/2, 0])
        rotate([0, 0, 90])
        outsideCuts(length = supportZ, finger = finger, cutD = material, uDiv = uFingerZ);
      translate([shelfX/2, -shelfBackZ/2, 0])
        rotate([0, 0, 90])
        outsideCuts(length = supportZ, finger = finger, cutD = material, uDiv = uFingerZ);
    } 

    //add hanger keyholes

    //difference a larger shelfback to remove any portion of the keyhole 
    //that extends past the main shelf back
    difference() {
      for (i=[-1, 1]) {
        translate([i*keyholeX, keyholeZ])
          keyhole();
      }
      //create a shelfback cutter that has a hole cut out in the center
      difference() {
        offset(delta = 2*wall) {
          shelfXZBack(r=50);
        }
        shelfXZBack(r=50);
      }
    }
  }
}

//3d shim module for layout
module shim3d() {
  color("red")
    linear_extrude(height = material) {
      shim(center = true);
    }
}

module shim(radius = 2, center = false) {

  $fn = 36;
  trans = center==true ? [-shimDim[0]/2, -shimDim[1]/2, 0] : 
                          [radius, radius, 0];

  translate(trans)
  difference() {
    minkowski() {
      square([shimDim[0]-2*radius, shimDim[1]-2*radius], center = false);
      translate([])
        circle(r = radius);
    }
    #text("S", size = shimDim[1]*.1); 
  }
}


//shims to take up space behind the shelf
module shimLayout(sets = 4) {
  for (i=[0:sets-1]) {
    for (j=[0, 2]) {
      translate([i*shimDim[0]*1.2, j*shimDim[1]*.6]){
        difference() {
          shim(center = false);
          //square(shimDim);
        }
      }
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

  translate([0, shelfBackZ/2+shelfY/2+separation, 0])
    assembleXZBack();
 
}


module shelf2D_cutlayout() {
  shelfXY();

  benchmark = [10, 20];

  translate([0, -(shelfY/2+shelfZ/2+separation)])
    rotate([0, 0, 180])
    shelfXZ();
 
  translate([(shelfX/2+supportZ/2+separation), 0, 0])
    rotate([0, 0, -90])
    shelfPolyYZ(42);
  
  translate([(shelfX/2+supportZ/2+separation*2+shelfZ), 0, 0])
    rotate([0, 0, 90])
    shelfPolyYZ(10);

  translate([0, shelfBackZ/2+shelfY/2+separation, 0])
    assembleXZBack();
  
  translate([shelfX/2+separation, shelfY/2+ separation])
    shimLayout(5);

  // add benchmark
  translate([shelfX/2+benchmark[0], -(shelfY/2+benchmark[1]/2+separation)])
    square(benchmark, center = true);
}


module speaker() {
  color("yellow")
    translate([0, 0, speakerDim[2]/2])
    cube(speakerDim, center = true);
}


module rpi() {
  color("gray")
    translate([0, 0, rpiDim[2]/2])
    cube(rpiDim, true);
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

  color("purple")
    translate([shelfX/2-material/2, 0, supportZ/2-material/2])
    rotate([90, 0, -90])
    linear_extrude(height = material, center = true)
    shelfPolyYZ();

  color("purple")
    translate([-(shelfX/2-material/2), 0, supportZ/2-material/2])
    rotate([90, 0, -90])
    linear_extrude(height = material, center = true)
    shelfPolyYZ();

  color("orange")
    translate([0, shelfY/2-material/2, shelfBackZ/2-material/2])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    assembleXZBack();
  
  if (appliances) {
    translate([shelfX/2-speakerDim[0]/2-material, -shelfY/2+speakerDim[1]/2+material, 
              material/2])
      speaker();

    translate([-shelfX/2+rpiDim[0]/2+material, -shelfY/2+rpiDim[1]/2+material, material/2])
      rpi();
  }

  for(i=[-1,1]) {
    translate([i*(shelfX/2-shimDim[0]/2+i*material/2), shelfY/2+material, 
              shimDim[1]/2])
      rotate([90, 0, 0])
      shim3d();
  }
}


//shelf2D();
shelf2D_cutlayout();

//assembleXZBack();
//shelf3D();
