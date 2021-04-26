// Whitehead link

// use parametrization with
// (x,y) = sqrt(1-theta^2) (cos theta, sin theta)
// z = sin(2theta)
// for theta in [-pi/4, pi/4] and the pi-translate of that. 


RES = 64; // resolution to use

rad1 = 1.0; // component 1 radius
rad2 = 1.0; // component 2 radius
zscal = 2.8;
rscal=1.4;
yscal=1.8;
outR = 5;  // outer radius of both components.

del = 2.4;

rotate([90,0,0])
color("red") rotate_extrude(angle=360, $fn=2*RES) 
    translate([1.3*outR,0,0])  circle(r=rad1, $fn=RES);

module comp2() {
    union() {
    for (i=[-RES:RES-1]) {
     theta1 = 45*i/RES;
     theta2 = 45*(i+1)/RES;
     r0 = rscal*outR*(1-theta1*theta1/(45*45));
     p0 = [r0*cos(theta1), yscal*r0*sin(theta1), zscal*sin(2*theta1)];
     r1 = rscal*outR*(1-theta2*theta2/(45*45));
     p1 = [r1*cos(theta2), yscal*r1*sin(theta2), zscal*sin(2*theta2)];
     rod(p0, p1, rad2);
  }
  }
}

union() {
    translate([del,0,0]) comp2();
    translate([-del,0,0]) rotate([0,0,180]) comp2();
    for (i=[-RES-1:RES+1]) {
        color("blue") rod(
        [del*(i/RES), -yscal*cos(90*i/RES), zscal*sin(90*i/RES)], 
        [del*(i+1)/RES, -yscal*cos(90*(i+1)/RES),zscal*sin(90*(i+1)/RES)], rad2);
        color("green") rod(
        [del*(i/RES), yscal*cos(90*i/RES), -zscal*sin(90*i/RES)], 
        [del*(i+1)/RES, yscal*cos(90*(i+1)/RES), -zscal*sin(90*(i+1)/RES)], rad2);
    }
}

module rod(a, b, r) {
    dir = b-a;
    h   = norm(dir);
    if(dir[0] == 0 && dir[1] == 0) {
        if (a[2]<b[2])        translate(a) cylinder(r=r, h=h, $fn=RES);
        else translate(b) cylinder(r=r, h=h, $fn=RES);
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
    // cap w/sphere
    translate(a) sphere(r=r, $fn=RES);
}