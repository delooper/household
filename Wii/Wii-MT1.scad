/** Mount for Nintendo Wii Sensor Bar **/

RES=120; // resolution of objects -- make roughly 200 for prints, 10-20 for prototyping.

/* Profile variables. */

W = 8.5; // Baseplate inner width. For my application this needs to be minimally 8.5mm
TH = 3; // material thickness
Ri = 0.5; // profile inner radius, should be bigger than TH
Ro = Ri + TH; // profile outer radius, should be Ri + TH.
BW = W + 2*Ro; // outer width of profile.

H = 8; // height before rounding

cR = TH/2;

/**  remaining variables **/

BR = 5; // radius of major bend.
sL = 35; // secondary length (green)

/** CONSTRUCTION **/

//translate([20,0,0])
// main length
difference() {
    union() {
        color("red") linear_extrude(height=140) sPro();

        // main bend.
        translate([0,-H-Ri-TH-BR,0]) rotate([0,0,90]) rotate([-90,0,0])
        rotate_extrude(angle=90, $fn=RES) translate([H+Ri+TH+BR,0]) rotate([0,0,-90]) sPro();

        // secondary length
        translate([0,-H-Ri-TH-BR,-H-Ri-TH-BR]) rotate([0,180,0]) rotate([90,0,0]) color("green") linear_extrude(height=sL) sPro();

        // top cap
        translate([0,0,140]) rotate([0,0,180]) rotate([90,0,0])
            rotate_extrude(angle=180, $fn=RES) intersection() { 
                sPro();
                polygon([[0,cR], [BW/2,cR], [BW/2, -H-Ro], [0,-H-Ro]]);
            }
        // grabber
        translate([-hW/2,-H-Ri-TH-BR-oTH-sL,-hTH/2-oTH-BR]) rotate([0,0,90]) rotate([90,0,0])   
        intersection() {
            hPro();
            translate([-0.5*oTH-hD,-BR+0.15,hW/2]) rotate([0,0,180]) rotate([0,-90,0]) linear_extrude(height=(1.5)*oTH+hD) cPro();
        }

        }
      translate([0,-20,140]) rotate([0,0,180]) rotate([90,0,0]) cylinder(h=20, r1=3, r2=3, $fn=RES);
    //translate([-hW/2,-H-Ri-TH-BR-oTH-sL,-hTH/2-oTH-BR]) rotate([0,0,90]) rotate([90,0,0]) 
    //translate([00,hTH/2+oTH+0.05,hW/2]) rotate([90,0,0]) color("purple") 
    //    cylinder(h=hTH+2*oTH+0.1, r1=hW/4+0.7, r2=hW/4+0.7, $fn=RES);        
}



/* Assemble grabber */
/*
translate([-hW/2,-H-Ri-TH-BR-oTH-sL,-hTH/2-oTH-BR]) rotate([0,0,90]) rotate([90,0,0]) 
{
 difference() {
    intersection() {
    hPro();
    translate([-0.5*oTH-hD,-BR+0.15,hW/2]) rotate([0,0,180]) rotate([0,-90,0]) linear_extrude(height=(1.5)*oTH+hD) cPro();
    }
translate([00,hTH/2+oTH+0.05,hW/2]) rotate([90,0,0]) color("purple") 
    cylinder(h=hTH+2*oTH+0.1, r1=hW/4, r2=hW/4, $fn=RES);
}
}*/

oTH = 2; // thickness of grabber
hD = 24.5; // depth
hTH = 9.3; // hand thickness i.e. thickness of Wii sensor bar
hW = BW; // how wide to make the hand.  Anything bigger than BW should suffice.

// grabber hand thinggy.
module hPro(){
    STP = 7;
    DELX = hW/STP;
    DELY = hD/STP;

    difference() { 
        union() {
        linear_extrude(height=hW)
        union() {
            polygon([[-hD, hTH/2+oTH], [oTH, hTH/2+oTH], [oTH, -hTH/2-oTH], [-hD, -hTH/2-oTH],
                [-hD, -hTH/2], [0, -hTH/2], [0, hTH/2], [-hD, hTH/2]]);
            translate([-hD,hTH/2+oTH/2]) circle(r=oTH/2, $fn=RES);
            translate([-hD,-hTH/2-oTH/2]) circle(r=oTH/2, $fn=RES);
        }
    for (i=[0:STP]) if (i!=0 && i!=STP) color("orange") translate([-hD,hTH/2,DELX*i]) sphere(r=0.4, $fn=RES); 
    }
    /**
    for (i=[0:STP]) if (i!=0 && i!=STP) {
        translate([-DELY*i,hTH/2+oTH+0.1,DELX*i]) rotate([90,0,0]) color("blue") 
            cylinder(h = hTH+2*oTH+0.2, r1=1, r2=1, $fn=RES);
        translate([-DELY*i,hTH/2+oTH+0.1,hW-DELX*i]) rotate([90,0,0]) color("blue") 
            cylinder(h = hTH+2*oTH+0.2, r1=1, r2=1, $fn=RES);
    }**/
}
}


/* Build the profile */
/** Simple 2-dimensional profile ready for extrusion. **/
module sPro(){
    union() {
        // end circles.
        translate([BW/2-cR, 0]) circle(r=cR, $fn=RES);
        translate([-BW/2+cR, 0]) circle(r=cR, $fn=RES);
        
        // base rectangle.
        polygon([[-W/2, -H-Ro], [-W/2, -H-Ri],  [W/2, -H-Ri],   [W/2, -H-Ro]]);
        
        // vert rectangles
        polygon([[-BW/2+TH, 0], [-BW/2+TH, -H], [-BW/2, -H], [-BW/2, 0]]);
        polygon([[BW/2-TH, 0], [BW/2-TH, -H], [BW/2, -H], [BW/2, 0]]);
        
        // rounding
        translate([-W/2, -H])
        intersection(){
            difference() {
                circle(r=Ro, $fn=RES);
                circle(r=Ri, $fn=RES);
            }
         polygon( [[0,0], [-Ro, 0], [-Ro,-Ro], [0, -Ro]] );
        }
        translate([W/2, -H])
        intersection(){
            difference() {
                circle(r=Ro, $fn=RES);
                circle(r=Ri, $fn=RES);
            }
         polygon( [[0,0], [Ro, 0], [Ro,-Ro], [0, -Ro]] );
        }  
    }
}

module cPro(){
 sPro();
 polygon([[BW/2-cR,0], [-BW/2+cR,0], [-BW/2+cR,cR], [BW/2-cR,cR]]);
}


