/** Simple Parametric t-nut **/

//$fn=100;

LEN = 20; // total length of the nut
WIDTH = 19;  // total width of the nut
THK = 3; // thickness above track.

tDEPTH = 2; // Depth into track
tWIDTH = 8; // track width

round_rad = 1.6; // rounding-the-corners radius
hole_diam = 5; // diameter of drilled-out hole

/** RECESS for metal nut **/
recess_depth = 0; // depth of recess for metal nut, if you need. Set to zero if no recess.
recess_sides = 6; // how many sides should the recess have? Must be even. Typically 6 or 4.
recess_width = 10; // width of the recess head, i.e. size of wrench that fits the nut.

RCT = 80; // number of points used in quarter-circle rounding
PI2 = 90;  // pi over 2.

if (recess_sides % 2 != 0) echo("recess_sides not even.");

difference() {
    intersection() {
        // primary profile to extrude
        PRO = [ for (i = [0:RCT]) [-WIDTH/2 + round_rad*(1- sin(PI2*i/RCT)), THK-round_rad*(1-cos(PI2*i/RCT))],
                    [-WIDTH/2,0], [-tWIDTH/2,0], [-tWIDTH/2,-tDEPTH], [tWIDTH/2, -tDEPTH], [tWIDTH/2, 0],
                    [WIDTH/2, 0], for (i =[0:RCT]) [WIDTH/2 +round_rad*(-1 + cos(PI2*i/RCT)), THK-round_rad*(1-sin(PI2*i/RCT))] ];

        translate([0,LEN,0]) rotate([90,0,0]) linear_extrude(height=LEN) polygon(PRO);
                    
        // secondary profile used for rounding the corners
        PRO2 = [ for (i = [0:RCT]) [-LEN/2 + round_rad*(1- sin(PI2*i/RCT)), THK-round_rad*(1-cos(PI2*i/RCT))],
                    [-LEN/2,-tDEPTH],  [LEN/2, -tDEPTH], 
                for (i =[0:RCT]) [LEN/2 +round_rad*(-1 + cos(PI2*i/RCT)), THK-round_rad*(1-sin(PI2*i/RCT))] ];

        translate([-WIDTH/2, LEN/2,0]) rotate([0,0,90]) rotate([90,0,0]) linear_extrude(height=WIDTH) polygon(PRO2);

        // 3rd profile for rounding corners
        PRO3 = [ for (i = [0:RCT]) [-WIDTH/2 + round_rad*(1- sin(PI2*i/RCT)), LEN/2-round_rad*(1-cos(PI2*i/RCT))],
            for (i = [0:RCT]) [-WIDTH/2 + round_rad*(1- cos(PI2*i/RCT)), -LEN/2+round_rad*(1-sin(PI2*i/RCT))],
            for (i = [0:RCT]) [WIDTH/2 - round_rad*(1- sin(PI2*i/RCT)), -LEN/2+round_rad*(1-cos(PI2*i/RCT))],
            for (i = [0:RCT]) [WIDTH/2 - round_rad*(1- cos(PI2*i/RCT)), LEN/2-round_rad*(1-sin(PI2*i/RCT))] ];

        translate([0,LEN/2,-tDEPTH]) linear_extrude(height=THK+tDEPTH) polygon(PRO3);
                }
    // drill hole
    color("red")  translate([0,LEN/2,-tDEPTH-0.5]) cylinder(h=THK+tDEPTH+1, r1 = hole_diam/2, r2 = hole_diam/2, $fn=4*RCT);
                
    if (recess_depth>0)
    // drill recess, if requested.
    translate([0,LEN/2, THK-recess_depth]) color("green") intersection_for(i=[0:floor(recess_sides/2)]) 
            rotate([0,0,360*i/recess_sides]) recp();

            }         
            
                       
module recp(){
    PRO4 = [ [recess_width, recess_width/2], [-recess_width, recess_width/2], 
                [-recess_width, -recess_width/2], [recess_width, -recess_width/2] ];
     color("red") linear_extrude(height=recess_depth+0.01) polygon(PRO4);
}
