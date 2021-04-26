VR = 0.2; // vertex radius
RT = 0.14; // rod thickness
textstr="Icosahedron"; 

$fn=120;

 // Icosahedron
C = [[-1.17082039, 0.0, -0.7236068],[-1.17082039, 0.0, 0.7236068], [-0.7236068, -1.17082039, 0.0],[-0.7236068, 1.17082039, 0.0],[0.0, -0.7236068, -1.17082039],[0.0, -0.7236068, 1.17082039],[0.0, 0.7236068, -1.17082039],[0.0, 0.7236068, 1.17082039],[0.7236068, -1.17082039, 0.0],[0.7236068, 1.17082039, 0.0],[1.17082039, 0.0, -0.7236068],[1.17082039, 0.0, 0.7236068]];

FL = [[0, 2, 1], [0, 3, 1], [0, 4, 2], [0, 6, 3], [0, 6, 4], [1, 5, 2], [1, 7, 3], [1, 7, 5], [2, 8, 4], [2, 8, 5], [3, 9, 6], [3, 9, 7], [4, 10, 6], [4, 10, 8], [5, 11, 7], [5, 11, 8], [6, 10, 9], [7, 11, 9], [8, 11, 10], [9, 11, 10]];

// minimum distance between vertices
DM = [ for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1] )
    sqrt((C[i]-C[j])*(C[i]-C[j])) ];
minD = min(DM)+0.1;

// edge list
EL = [for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1]) 
    if (sqrt( (C[i]-C[j])*(C[i]-C[j])) < minD ) [ i, j ]
        ];
 
difference(){
    intersection(){    
    union(){
    // RODS
    for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1]) {
        V = C[i]-C[j];
        if (sqrt(V*V) < minD ) {  rod(C[i], C[j], RT);}
        }
    // SPHERES
    for ( i = [0:len(C)-1] )
    {    if (i < 8)  color([0.5,0.5,0.5]) translate(C[i]) sphere(r=VR);
      else translate(C[i]) sphere(r=VR);   }
    }
    hull() 

    // Icosahedron
   polyhedron(points=[[-1.17082039, 0.0, -0.7236068], [-1.17082039, 0.0, 0.7236068], [-0.7236068, -1.17082039, 0.0], [-0.7236068, 1.17082039, 0.0], [0.0, -0.7236068, -1.17082039], [0.0, -0.7236068, 1.17082039], [0.0, 0.7236068, -1.17082039], [0.0, 0.7236068, 1.17082039], [0.7236068, -1.17082039, 0.0], [0.7236068, 1.17082039, 0.0], [1.17082039, 0.0, -0.7236068], [1.17082039, 0.0, 0.7236068]], faces=[[0, 2, 1], [0, 3, 1], [0, 4, 2], [0, 6, 3], [0, 6, 4], [1, 5, 2], [1, 7, 3], [1, 7, 5], [2, 8, 4], [2, 8, 5], [3, 9, 6], [3, 9, 7], [4, 10, 6], [4, 10, 8], [5, 11, 7], [5, 11, 8], [6, 10, 9], [7, 11, 9], [8, 11, 10], [9, 11, 10]]);
    }
text_corner(0, 2, 1, 0, "red");
text_corner(1, 0, 1, 2, "red");
text_corner(2, 2, 1, 0, "red");
text_corner(3, 0, 1, 2, "red");
text_corner(4, 2, 1, 0, "red");
text_corner(5, 0, 1, 2, "red");
text_corner(6, 2, 1, 0, "blue");
text_corner(7, 0, 1, 2, "blue");
text_corner(8, 0, 1, 2, "blue");
text_corner(9, 2, 1, 0, "blue");
text_corner(10, 2, 1, 0, "blue");
text_corner(11, 0, 1, 2, "blue");
text_corner(12, 0, 1, 2, "green");
text_corner(13, 2, 1, 0, "green");
text_corner(14, 2, 1, 0, "green");
text_corner(15, 0, 1, 2, "green");
text_corner(16, 0, 1, 2, "green");
text_corner(17, 2, 1, 0, "green");
text_corner(18, 0, 1, 2, "black");
text_corner(19, 2, 1, 0, "black");
}

function vij(f, i,j) = C[FL[f][i]]-C[FL[f][j]];
function dot(v1,v2) = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];
function transpose_3(m) = [[m[0][0],m[1][0],m[2][0]],[m[0][1],m[1][1],m[2][1]],[m[0][2],m[1][2],m[2][2]]];


module text_corner(f, i,j,k, COL) {
    V1 = vij(f, i,j)/norm(vij(f, i,j));
    V2a = vij(f, i,k) - dot(vij(f, i,k),V1)*V1;
    V2 = V2a/norm(V2a);
    V3 = cross(V1,V2);
    M = transpose_3([V1,V2,V3]);

    translate(C[FL[f][i]]) multmatrix(M)
    color(COL) rotate([180,0,0]) translate([-0.98,0.02,-0.01]) 
        linear_extrude(height=0.02) scale(0.8) text(textstr, 
        font="Berenis ADF Pro:style=Bold", size=0.09);
}


module rod(a, b, r) {
    dir = b-a;
    h   = norm(dir);
    if(dir[0] == 0 && dir[1] == 0) {
        if (a[2]<b[2])        translate(a) cylinder(r=r, h=h);
        else translate(b) cylinder(r=r, h=h);
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
        cylinder(r=r, h=h);
    }
}
