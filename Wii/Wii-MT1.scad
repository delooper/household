/** Mount for Nintendo Wii Sensor Bar **/

RES=128; // resolution of objects -- make roughly 200 for prints, 10-20 for prototyping.

/* Profile variables. */

W = 8.5; // Baseplate inner width. For my application this needs to be minimally 8.5mm
TH = 3; // material thickness
Ri = 0.5; // profile inner radius, should be bigger than TH
Ro = Ri + TH; // profile outer radius, should be Ri + TH.
BW = W + 2*Ro; // outer width of profile.

H = 10; // height before rounding

cR = TH/2;

/**  remaining variables **/

BR = 5; // radius of major bend.
sL = 35; // secondary length (green)
pL = 150; // primary length (red)

/** CONSTRUCTION **/

// main length
module mainLen() {
  difference() {
    union() {
        // top cap
        translate([0,0,pL]) rotate([0,0,180]) rotate([90,0,0])
            rotate_extrude(angle=180, $fn=RES) intersection() { 
                sPro();
                polygon([[0,cR], [BW/2,cR], [BW/2, -H-Ro], [0,-H-Ro]]);
            }

        // main vertical length, in red.
        color("red") linear_extrude(height=pL) sPro();

        // main bend.
        translate([0,-H-Ri-TH-BR,0]) rotate([0,0,90]) rotate([-90,0,0])
        rotate_extrude(angle=90, $fn=RES) translate([H+Ri+TH+BR,0]) rotate([0,0,-90]) sPro();

        // secondary length, in green.
        translate([0,-H-Ri-TH-BR,-H-Ri-TH-BR]) rotate([0,180,0]) rotate([90,0,0]) 
             color("green") linear_extrude(height=sL) sPro();

        intersection() {
            // additional segment, for intersection
            translate([0,-H-Ri-TH-BR,-H-Ri-TH-BR]) rotate([0,180,0]) rotate([90,0,0]) 
                color("orange") translate([0,0,sL]) linear_extrude(height=sL) hull() sPro();
            
            // grabber
            translate([-hW/2,-H-Ri-TH-BR-oTH-sL,-hTH/2-oTH-BR]) rotate([0,0,90]) rotate([90,0,0])   
                hPro();
           }
        
        }
      translate([0,-20,pL]) rotate([0,0,180]) rotate([90,0,0]) cylinder(h=20, r1=3, r2=3, $fn=RES);
      } 
   }

mainLen();

/** items specific to the grabber **/
oTH = 2.8; // thickness of grabber
hD = 25.5; // depth
hTH = 9.37; // hand thickness i.e. thickness of Wii sensor bar
hW = BW; // how wide to make the hand.  Anything bigger than BW should suffice.
dotR = 0.8; // dot radius on grabber. 
   
// grabber hand thinggy. Is pre-extruded.
module hPro(){
    STP = 7;
    DELX = hW/STP;
    DELY = hD/STP;

        union() {
        linear_extrude(height=hW) grabPoly();
        for (i=[0:STP]) if (i!=0 && i!=STP) color("blue") translate([-hD,hTH/2,DELX*i]) sphere(r=dotR, $fn=RES); 
        for (i=[0:STP]) if (i!=0 && i!=STP) color("blue") translate([-hD,-hTH/2,DELX*i]) sphere(r=dotR, $fn=RES); 
        }
}

module grabPoly() {
    union() {
   polygon([[-hD, hTH/2+oTH], [oTH, hTH/2+oTH], [oTH, -hTH/2-oTH], [-hD, -hTH/2-oTH],
                [-hD, -hTH/2], [0, -hTH/2], [0, hTH/2], [-hD, hTH/2]]);
   translate([-hD,hTH/2+oTH/2]) circle(r=oTH/2, $fn=RES);
   translate([-hD,-hTH/2-oTH/2]) circle(r=oTH/2, $fn=RES);
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



