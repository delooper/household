// Picatinny rail for Crosman P1322
// adjustable so may be useful for other things.

// see the Wikipedia page for the metric dimensions. The diagram will
//  help you make sense of the terminology below.
//  https://en.wikipedia.org/wiki/Picatinny_rail#/media/File:Picatinny.svg

PICM = 21.2; // picatinny major diam 21.2mm is spec, but larger seems ok
PICm = 16.2; // picatinny minor diam. 15.67 is spec, but larger seems ok

// GAPs
PICg = 5.25; // gap length
PICs = 10; // periodicity
PICd = 3; // gap depth

// RISER
PICh = 9.32; // height of riser 9.32
PICbh = 3.79; // displacement from bottom
PICv = 5.53; // height of 45-degree section

SH_RAD=3.2; // side=hole radius

PICN = 6; // number of teeth in rail.

RES=256; // resolution parameter

module top_rail() {
difference() {
    linear_extrude( height=PICs*PICN-PICg) 
    polygon(points=[[0,0], [-PICm/2,0], [-PICm/2, PICbh], [-PICm/2-PICv/2, PICbh+PICv/2], [-PICm/2, PICbh+PICv],
              [PICm/2, PICbh+PICv], [PICm/2+PICv/2, PICbh+PICv/2], [PICm/2, PICbh], [PICm/2, 0] ]);
for (i=[0:PICN-2])
        translate([0,PICh-PICd+0.003,PICs*i+PICs-PICg])
            color([0,0,1]) linear_extrude( height=PICg )
                 polygon(points=[[0,0], [-PICM,0], [-PICM, PICd], [PICM, PICd], [PICM,0]]);
}
}

//top_rail();

MT_EXW = 1.5; // Extra width
MT_EXV = 11; // extra vertical support

TOP_CYL_D = 11.35; // 11mm top cylinder cross-sectional diameter, enlarge to reduce amount of
  // sanding needed. 11.2 was a bit too small.
PUMP_CYL_D = 19; // 19mm air cylinder cross-sectional diameter
EX_GAP = 0.8; // gap between the "business end" barrell and the air chamber. 

module bot_section() {
 color([1,1,0]) linear_extrude( height=PICs*PICN-PICg) 
    polygon(points=[[-PICm/2,0], [-PICm/2-MT_EXW, -MT_EXW], 
        [-PICm/2-MT_EXW, -MT_EXW-MT_EXV], 
        [0, -PUMP_CYL_D/2-TOP_CYL_D/2-EX_GAP], 
        [PICm/2+MT_EXW, -MT_EXW-MT_EXV], [PICm/2+MT_EXW, -MT_EXW], [PICm/2,0]]);
}

//bot_section();

module two_holes() {
    DELTA=-1.4;
    color([1,0,0]) translate([0,DELTA,-1]) linear_extrude( height=PICs*PICN) 
       circle(r=TOP_CYL_D/2, $fn=RES);
    color([0,0,1]) translate([0,-TOP_CYL_D/2-PUMP_CYL_D/2-EX_GAP+DELTA,-1]) linear_extrude( height=PICs*PICN) circle(r=PUMP_CYL_D/2, $fn=RES);
}

module side_holes() {
    for (i=[0:PICN-2])  translate([0,-PICg-1.4,PICs*i+PICs-PICg/2]) color([0,1,0]) 
          translate([-PICm,0,0]) rotate([0,90,0]) cylinder( h=2*PICm, r=SH_RAD, $fn=RES );
}

//side_holes();

//two_holes();

difference(){
    union(){
        top_rail();
        bot_section();  
        }
    two_holes();
    side_holes();
    }
