// Hopf link

RES = 128; // resolution to use

rad1 = 0.6; // component 1 radius
rad2 = 0.6; // component 2 radius
outR = 2;  // outer radius of both components.

offs = 45; // offset angle

color("red") rotate_extrude(angle=360, $fn=RES) translate([outR,0,0]) circle(r=rad1, $fn=RES);

translate([outR,0,0]) rotate([90-offs,0,0]) color("blue") rotate_extrude(angle=360, $fn=RES) translate([outR,0,0]) circle(r=rad1, $fn=RES);

