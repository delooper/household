// Tip piece for Crosman P1322
// adjustable so may be useful for other things.

use <threads.scad>

TOP_CYL_D = 11.35; // 11mm top cylinder cross-sectional diameter, enlarge to reduce amount of
  // sanding needed. 11.2 was a bit too small. 11.4 is good but has a tiny amount of
  // play.
TOP_LIN_OD = 7.9; // cylinder liner outer diameter 7.6mm measured 
TOP_LIN_ID = 6.2; // cylinder liner inner diameter, i.e size of extruded pellet. 5.6mm measured, 
  // but we oversize.
TOP_LIN_PRO = 5; // amount liner protrudes from top cylinder. 
 // top cyl to top of plastic part 3mm, 2mm from there to top inner liner. 

BOT_CYL_ID = 15.5; // measured 15.9, but let's undersize it.
BOT_CYL_T = 1.9; // bottom cylinder wall thickness
BOT_CYL_OD = 19.3; // outer diameter

GAP = -1.1; // gap between bottom and top cyl. 
  // -1.4 was too small. 

WallT = 1.8; // wall thickness

PW = 6.5; // slot width for pump mechanism. 

SHL_LEN = 45; // length our shell covers the cylinder.

ST_HT = 16; // sight height!
ST_LEN=22; // sight length.
ST_TH = 1.6; // sight thickness. 

thread_gap=1.6; //gap before thread
thread_len = 11; // length of threads 

FMT = 8.5; // flush mount thickness
FMPH = 9.9; // distance from flush mount to pin hole
PHD = 5.3; // pin hole diam

insert_len = 28; // insert goes this far...

RES=256; // resolution

module top_cyl_ext(){
    //  cylinder over the barrel. 
    cylinder(h=SHL_LEN, r=TOP_CYL_D/2+WallT, $fn=RES);
    // sights.
    APro = [ for (i=[0:RES]) [ST_HT*sin(i*180/RES), ST_LEN*i/RES] ];
    translate([ST_TH/2,-TOP_CYL_D/2,SHL_LEN-ST_LEN]) rotate([90,0,0]) rotate([0,-90,0]) 
       color([1,0,0]) linear_extrude(height=ST_TH) polygon(APro);        
    // thread mount
    translate([0,0,SHL_LEN+3]) cylinder(h=thread_gap, r=0.4374*25.4/2, $fn=RES);
    translate([0,0,SHL_LEN+3+thread_gap]) english_thread(diameter=1/2, threads_per_inch=20, 
        length=(thread_len-thread_gap)*0.03937);
    // mount to lower cyl
    top_bot_merge();
    // main insert
    translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP, SHL_LEN-FMT-insert_len]) 
        cylinder(h=insert_len, r=BOT_CYL_ID/2, $fn=RES);
}

module top_bot_merge(){
    translate([0,0,SHL_LEN-FMT])
    linear_extrude(height=FMT+3)
    hull() {
        circle(r=TOP_CYL_D/2+WallT, $fn=RES);
         translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP]) 
           circle(r=BOT_CYL_OD/2, $fn=RES);
    }
}

module top_cyl_bore(){
    // pellet hole
    color([0,0,1]) translate([0,0,-5]) cylinder(h=SHL_LEN+thread_len+10, r=TOP_LIN_ID/2, $fn=RES);
    // liner hole
    color([0,1,1]) cylinder(h=SHL_LEN+TOP_LIN_PRO, r=TOP_LIN_OD/2, $fn=RES);
    // main cylinder hole
    color([0,1,0]) translate([0,0,-5]) cylinder(h=SHL_LEN+3, r=TOP_CYL_D/2, $fn=RES);
    
    // cut pinhole
    translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP,SHL_LEN-FMT-FMPH]) 
    color([0,1,0]) rotate([0,0,90]) translate([0,-BOT_CYL_OD/2,0]) rotate([-90,0,0]) 
        cylinder(h=BOT_CYL_OD, r=PHD/2, $fn=RES);
    // cut main slot
    
    translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP, SHL_LEN-FMT-insert_len-0.01])
    color([0,0,1]) 
    intersection() {
      linear_extrude(height=insert_len+0.01-3.8)
       polygon([[-PW/2,-BOT_CYL_OD/2], [PW/2, -BOT_CYL_OD/2], 
                      [PW/2, BOT_CYL_OD/2], [-PW/2, BOT_CYL_OD/2]]);
      cylinder(h=insert_len+0.01, r=BOT_CYL_OD/2, $fn=RES);
    }
    // cut room for pump arm, when fully-opened 
    translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP - 1.2*PHD,
      SHL_LEN-FMT-FMPH+6]) 
     rotate([0,270,0]) translate([0,0,-PW/2])
    color([1,0,0]) linear_extrude(height=PW) polygon([[0,0], [0, BOT_CYL_OD/2 + 1.2*PHD], 
       [FMT + FMPH + 3, BOT_CYL_OD/2 + 1.2*PHD]]);
    
    // cut space for bot cyl wall to slide into
    translate([0,TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP, -0.01]) color([0,0,1]) difference(){
        cylinder(h=SHL_LEN-FMT-0.01, r=BOT_CYL_OD/2, $fn=RES);
        cylinder(h=SHL_LEN-FMT-0.01, r=BOT_CYL_ID/2, $fn=RES);
    }
}


difference(){
    top_cyl_ext();
    top_cyl_bore();
}

//top_cyl_bore();
echo(TOP_CYL_D/2 + WallT + BOT_CYL_OD/2 + GAP);
