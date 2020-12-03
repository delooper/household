h = 0.5*(sqrt(5)-1); // dodecahedron

VR = 0.2; // vertex radius
RT = 0.2; // rod thickness
textstr="ROMS"; 

$fn=120;

//Dodecahedron
C = [ [1,1,1],[1,1,-1],[1,-1,1],[1,-1,-1], [-1,1,1],[-1,1,-1],[-1,-1,1],[-1,-1,-1], [0,1+h,1-h*h], [0,1+h,-1+h*h],  [0,-1-h,1-h*h], [0,-1-h,-1+h*h], [1+h,1-h*h,0], [1+h,-1+h*h,0],  [-1-h,1-h*h,0], [-1-h,-1+h*h,0], [1-h*h,0,1+h], [-1+h*h,0,1+h],  [1-h*h,0,-1-h], [-1+h*h,0,-1-h] ];

FL = [[0, 12, 1, 9, 8], [0, 16, 17, 4, 8], [0, 16, 2, 13, 12], [1, 18, 19, 5, 9], [1, 18, 3, 13, 12], [2, 13, 3, 11, 10], [2, 16, 17, 6, 10], [3, 18, 19, 7, 11], [4, 14, 5, 9, 8], [4, 17, 6, 15, 14], [5, 19, 7, 15, 14], [6, 15, 7, 11, 10]];

// minimum distance between vertices
DM = [ for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1] )
    sqrt((C[i]-C[j])*(C[i]-C[j])) ];
minD = min(DM)+0.1;

// edge list
EL = [for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1]) 
    if (sqrt( (C[i]-C[j])*(C[i]-C[j])) < minD ) [ i, j ]
        ];

difference() {
    intersection(){    
    union(){
    // RODS
    for ( i = [0:len(C)-2] ) for ( j = [i+1:len(C)-1]) {
    V = C[i]-C[j];
    if (sqrt(V*V) < minD ) {
            rod(C[i], C[j], RT);
    }
    }
    // SPHERES
    for ( i = [0:len(C)-1] )
    {  if (i < 8)  color([0.5,0.5,0.5]) translate(C[i]) sphere(r=VR);
      else translate(C[i]) sphere(r=VR);    }
    }
    hull() 
    // Dodecahedron
    polyhedron(points=[[1.0, 1.0, 1.0], [1.0, 1.0, -1.0], [1.0, -1.0, 1.0], [1.0, -1.0, -1.0], [-1.0, 1.0, 1.0], [-1.0, 1.0, -1.0], [-1.0, -1.0, 1.0], [-1.0, -1.0, -1.0], [0.0, 1.618033988749895, 0.6180339887498948], [0.0, 1.618033988749895, -0.6180339887498948], [0.0, -1.618033988749895, 0.6180339887498948], [0.0, -1.618033988749895, -0.6180339887498948], [1.618033988749895, 0.6180339887498948, 0.0], [1.618033988749895, -0.6180339887498948, 0.0], [-1.618033988749895, 0.6180339887498948, 0.0], [-1.618033988749895, -0.6180339887498948, 0.0], [0.6180339887498948, 0.0, 1.618033988749895], [-0.6180339887498948, 0.0, 1.618033988749895], [0.6180339887498948, 0.0, -1.618033988749895], [-0.6180339887498948, 0.0, -1.618033988749895]], faces=[[0, 12, 1, 9, 8], [0, 16, 17, 4, 8], [0, 16, 2, 13, 12], [1, 18, 19, 5, 9], [1, 18, 3, 13, 12], [2, 13, 3, 11, 10], [2, 16, 17, 6, 10], [3, 18, 19, 7, 11], [4, 14, 5, 9, 8], [4, 17, 6, 15, 14], [5, 19, 7, 15, 14], [6, 15, 7, 11, 10]]);
    }
text_corner(0, 2, 1, 0, "red");
text_corner(1, 0, 1, 2, "red");
text_corner(2, 2, 1, 0, "red");
text_corner(3, 2, 1, 0, "red");
text_corner(4, 0, 1, 2, "red");
text_corner(5, 0, 1, 2, "blue");
text_corner(6, 2, 1, 0, "blue");
text_corner(7, 0, 1, 2, "blue");
text_corner(8, 0, 1, 2, "blue");
text_corner(9, 0, 1, 2, "blue");
text_corner(10, 2, 1, 0, "blue");
text_corner(11, 2, 1, 0, "blue");
    
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
    color(COL) rotate([180,0,0]) translate([-0.79,0.03,-0.01]) 
        linear_extrude(height=0.02) scale(0.9) text(textstr, 
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
