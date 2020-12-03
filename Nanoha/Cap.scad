// Yasuhara Nanoha lens cap

// For formlabs, print w/approx 1.003 scale in standard resins.

// Cap thickness
CAPTHK = 2.4;
// Cap diameter
CAPDIA = 56;

// number of radial segments
RADSEG = 720;

// post diameter
dim_PD = 5; // 5mm
// post length
dim_PL = 3;
// post center
dim_PC = CAPDIA/2 - dim_PD/2;

// vtab dimensions
dim_VTl = 11; 
dim_VTw = 2.9;
dim_VTh = 4;

// htab dimensions
dim_HTl = 10;
dim_HTw = 3.6;
dim_HTh = 4;

// Main cap.
color([1,1,1]) difference() {
    cylinder($fn = RADSEG, h=CAPTHK, r1=CAPDIA/2, r2=CAPDIA/2);
    translate([0,0,-0.02]) cylinder($fn = RADSEG, h=CAPTHK/3, 
        r1=0.9*CAPDIA/2, r2=0.9*CAPDIA/2);
}

// Front text
translate([0,0,0.1]) color("SteelBlue", 1.0) translate([12,6,0]) scale([-0.5,0.5]) 
  linear_extrude(height=CAPTHK/2) 
   text($fn=80, "Yasuhara", font="Open Sans Condensed");
translate([0,0,0.1]) color("SteelBlue", 1.0) translate([11,-10,0]) scale([-0.5,0.5]) 
  linear_extrude(height=CAPTHK/2) 
   text($fn=80, "Nanoha", font="Open Sans Condensed");

// Inner disc
color([0.6,0.6,0.6]) translate([0,0,CAPTHK]) 
    cylinder($fn = 360, h=2, r1=25/2, r2=25/2);

// Mounting tabs
translate([14.5,2.9,0]) translate([0,0,CAPTHK]) cube([dim_VTw,dim_VTl,dim_VTh]);
translate([-14.5-2.9,2.9,0]) translate([0,0,CAPTHK]) cube([dim_VTw,dim_VTl,dim_VTh]);
translate([0,-25/2-3.3,0]) translate([-5,-3.6,CAPTHK]) cube([dim_HTl,dim_HTw,dim_HTh]);

// Securing posts
intersection() {
    union() {
        translate([0,-dim_PC,CAPTHK]) color([0.8,1,1]) union() { 
        cylinder($fn=RADSEG, h=dim_PL, r1=dim_PD/2, r2=dim_PD/2);
        translate([-dim_PD/2,-dim_PD,0]) cube([dim_PD,dim_PD,dim_PL]);
        }

        rotate(a=[0,0,120]) translate([0,-dim_PC,CAPTHK]) color([0.8,1,1]) union() {
        cylinder($fn=RADSEG, h=dim_PL, r1=dim_PD/2, r2=dim_PD/2);
        translate([-dim_PD/2,-dim_PD,0]) cube([dim_PD,dim_PD,dim_PL]);
        }

        rotate(a=[0,0,-120]) translate([0,-dim_PC,CAPTHK]) color([0.8,1,1]) union() {
        cylinder($fn=RADSEG, h=dim_PL, r1=dim_PD/2, r2=dim_PD/2);
        translate([-dim_PD/2,-dim_PD,0]) cube([dim_PD,dim_PD,dim_PL]);
        }
    }
    
    translate([0,0,CAPTHK]) cylinder($fn=RADSEG, h=dim_PL, r1=CAPDIA/2, r2=CAPDIA/2);
   
}