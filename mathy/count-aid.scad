/** Dad's counting apparatus.

Here’s what I can use - three “pies" about 75 mm diameter and 4 mm thick.

Pie #1 has two 1/4 sectors and four 1/8 sectors

Pie #2 has two 1/3 sector and, two 1/6 sectors

Pie #3 has three 1/5 sectors and four 1/10 sectors

This would offer several exercises when we combine pieces from different pies.

If each piece can have the sector fraction imprinted on it as well as the decimal value, it will be useful.

**/

use <text_on.scad>

RES = 400;

cdiam = 75; // disc diameter
cthick = 7; // disc thickness
crd = 1.6; // rounding of profile

NSEG = 4; // divide circle into NSEG equal-size sectors

difference() {
    rotate_extrude(angle=360/NSEG, $fn=RES) SPRO();

    //translate([5,5,cthick-crd+0.01]) color("blue") linear_extrude(height=crd) text("1/4");

    translate([0,0,0]) rotate([0,0,90+(180/NSEG)-14]) 
    color("blue") text_on_cylinder(t="Quarter",r1=cdiam/2-1,r2=cdiam/2-1,h=4, 
        font="Liberation Mono", direction="ttb", size=cthick-2*crd);
}

module SPRO() {
    union() {
        translate([cdiam/2-crd, crd]) circle(r=crd, $fn=RES/8);
        translate([cdiam/2-crd, cthick-crd]) circle(r=crd, $fn=RES/8);
        polygon([[0,0], [cdiam/2-crd,0], [cdiam/2, crd], [cdiam/2,cthick-crd], [cdiam/2-crd, cthick], [0, cthick]]);
    }
}


