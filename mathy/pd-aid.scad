/** Poincare Duality Teaching Aid **/ 
/** Clone of my old TinkerCAD model **/

RES = 100;

VR = 0.6; // radius of spheres
ER = 0.3; // redius of edges
DFT = 0.2; // dual face thickness

VTXMAG = 10/sqrt(3);

v0 = [VTXMAG, VTXMAG, -VTXMAG];
v1 = [VTXMAG, -VTXMAG, VTXMAG];
v2 = [-VTXMAG, VTXMAG, VTXMAG];
v3 = [-VTXMAG, -VTXMAG, -VTXMAG];

// plot vertices
translate(v0) sphere(r=VR, $fn=RES);
translate(v1) sphere(r=VR, $fn=RES);
translate(v2) sphere(r=VR, $fn=RES);
translate(v3) sphere(r=VR, $fn=RES);

// plot edges
color("red") rod(v0, v1, ER);
color("red") rod(v0, v2, ER);
color("red") rod(v0, v3, ER);
color("red") rod(v1, v2, ER);
color("red") rod(v1, v3, ER);
color("red") rod(v2, v3, ER);

// plot dual vertex
color("green") sphere(r=VR, $fn=RES);

// plot dual edges
color("blue") arod([0,0,0], -0.7*v0, ER);
color("blue") arod([0,0,0], -0.7*v1, ER);
color("blue") arod([0,0,0], -0.7*v2, ER);
color("blue") arod([0,0,0], -0.7*v3, ER);

quad();
rotate(120, v3/norm(v3)) quad();
rotate(-120, v3/norm(v3)) quad();
rotate(120, v2/norm(v2)) quad();
rotate(-120, v2/norm(v2)) quad();
rotate(120, v3/norm(v3)) rotate(-120, v2/norm(v2)) quad();

// TODO dual 2-cells. 
module quad() {
rotate([45,0,0]) translate([0,0,-DFT/2]) linear_extrude(DFT) 
    polygon([[0,0], [VTXMAG,0], (1/2)*[VTXMAG, -1.33*VTXMAG]]);
rotate([-135,0,0]) translate([0,0,-DFT/2]) linear_extrude(DFT) 
    polygon([[0,0], [VTXMAG,0], (1/2)*[VTXMAG, -1.33*VTXMAG]]);
}

// cylinder between two vertices.
module rod(a, b, r) {
    dir = b-a;
    h   = norm(dir);
    if(dir[0] == 0 && dir[1] == 0) {
        // no transformation necessary
        cylinder(r=r, h=h, $fn=RES);
    }
    else {
        w  = dir / h;
        u0 = cross(w, [0,0,1]);
        u  = u0 / norm(u0);
        v0 = cross(w, u);
        v  = v0 / norm(v0);
        multmatrix(m=[[u[0], v[0], w[0], a[0]],
                      [u[1], v[1], w[1], a[1]],
                      [u[2], v[2], w[2], a[2]],
                      [0,    0,    0,    1]])
        cylinder(r=r, h=h, $fn=RES);
    }
}

module arod(a,b,r) {
    HF = 1.8; // head factor
    dir = b-a;
    h   = norm(dir);
    if(dir[0] == 0 && dir[1] == 0) {
        // no transformation necessary
        cylinder(r=r, h=h, $fn=RES);
        translate([0,0,h]) cylinder(r1=HF*r, r2=0, h=HF*r, $fn=RES);
    }
    else {
        w  = dir / h;
        u0 = cross(w, [0,0,1]);
        u  = u0 / norm(u0);
        v0 = cross(w, u);
        v  = v0 / norm(v0);
        multmatrix(m=[[u[0], v[0], w[0], a[0]],
                      [u[1], v[1], w[1], a[1]],
                      [u[2], v[2], w[2], a[2]],
                      [0,    0,    0,    1]]) {
        cylinder(r=r, h=h, $fn=RES);
        translate([0,0,h]) cylinder(r1=HF*r, r2=0, h=HF*r, $fn=RES);
                      }
    }
}