/** Poincare Duality Teaching Aid **/ 
/** Clone of my old TinkerCAD model **/
// 1.003 in black

RES = 200;

VR = 0.6; // radius of spheres
ER = 0.3; // redius of edges
DFT = 0.3; // dual face thickness

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
color("blue") arod([0,0,0], -0.6*v0, ER);
color("blue") arod([0,0,0], -0.6*v1, ER);
color("blue") arod([0,0,0], -0.6*v2, ER);
color("blue") arod([0,0,0], -0.6*v3, ER);

quad();
rotate( 120, v3/norm(v3)) quad();
rotate(-120, v3/norm(v3)) quad();
rotate( 120, v2/norm(v2)) quad();
rotate(-120, v2/norm(v2)) quad();
rotate( 120, v3/norm(v3)) rotate(-120, v2/norm(v2)) quad();

// dual 2-cells. 
module quad() {
 difference() {
    union() {
         rotate([45,0,0]) translate([0,0,-DFT/2]) linear_extrude(DFT) 
            polygon([[0,0], [VTXMAG,0], (1/2)*[VTXMAG, -1.43*VTXMAG]]);
        rotate([-135,0,0]) translate([0,0,-DFT/2]) linear_extrude(DFT) 
            polygon([[0,0], [VTXMAG,0], (1/2)*[VTXMAG, -1.43*VTXMAG]]); 
        // support-trusses between dual 2-cells and the edges, to make it a bit more robust.
        
        F1=1.5*(1/3)*(v0+v1+v2); 
        F2=1.5*(1/3)*(v0+v1+v3);
        E = (1/2)*(v0+v1);
        for ( a = [0:0.02:1] ) {
            C = 0.87+0.1*a;
            D = 0.13+0.1*a;
            polyhedron( points = [ (1-C)*v0+C*E, (1-C)*v1+C*E, (1-D)*E+D*F1, (1-D)*E+D*F2, E ], 
                                faces =  [[0,4,2], [0,2,3], [1,2,4], [1,4,3], [3,4,0], [1,3,2] ] ); 
            }
        }
    translate([3,0,0]) translate(0.4*[-0.4,1,-1]) rotate([45,0,0]) color("purple") cylinder(r=1.2, $fn=RES);  
        
 rotate([45,0,0]) 
        color("orange") rotate([0,0,-90]) translate([-2.7,2.5,0.06]) rotate([0,0,38]) 
    linear_extrude(height=0.1) scale(0.07) text("Poincaré");
 rotate([180,0,0]) rotate([45,0,0]) 
        color("orange") rotate([0,0,-90]) translate([-2.7,2.5,0.06]) rotate([0,0,38]) 
     linear_extrude(height=0.1) scale(0.07) text("Poincaré");
    }
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
        translate([0,0,h]) cylinder(r1=HF*r, r2=0, h=1.2*HF*r, $fn=RES);
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
        translate([0,0,h]) cylinder(r1=HF*r, r2=0, h=1.2*HF*r, $fn=RES);
                      }
    }
}
