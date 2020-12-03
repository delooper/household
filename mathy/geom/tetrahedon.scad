VR = 0.2; // vertex radius
RT = 0.2; // rod thickness

textstr="ROMS";

$fn=120;

//Tetrahedron
C = [[1,1,-1], [1,-1,1], [-1,1,1], [-1,-1,-1]];

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
        if (sqrt(V*V) < minD ) { rod(C[i], C[j], RT); }
        }
        // SPHERES
        for ( i = [0:len(C)-1] )
        {
        if (i < 8)  color([0.5,0.5,0.5]) translate(C[i]) sphere(r=VR);
        else translate(C[i]) sphere(r=VR);    
        }
        }
     hull() 
   
      // tetrahedron
     polyhedron(points=C, faces=[[0, 2, 1], [0, 3, 1], [0, 3, 2], [1, 3, 2]]);
    }
text_face(0,1,2);
text_face(1,0,3);
text_face(0,2,3);
text_face(2,1,3);
}

function vij(i,j) = C[i]-C[j];
function dot(v1,v2) = v1[0]*v2[0]+v1[1]*v2[1]+v1[2]*v2[2];
function transpose_3(m) = [[m[0][0],m[1][0],m[2][0]],[m[0][1],m[1][1],m[2][1]],[m[0][2],m[1][2],m[2][2]]];

module text_corner(i,j,k) {
    V1 = vij(i,j)/norm(vij(i,j));
    V2a = vij(i,k) - dot(vij(i,k),V1)*V1;
    V2 = V2a/norm(V2a);
    V3 = cross(V1,V2);
    M = transpose_3([V1,V2,V3]);

    translate(C[i]) multmatrix(M)
    color([0,0,1]) rotate([180,0,0]) translate([-1.62,0.04,-0.01]) 
        linear_extrude(height=0.02) text(textstr, 
        font="Berenis ADF Pro:style=Bold", size=0.1);
}

module text_face(i,j,k) {
    text_corner(i,j,k);
    //text_corner(j,k,i);
    //text_corner(k,i,j);
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

