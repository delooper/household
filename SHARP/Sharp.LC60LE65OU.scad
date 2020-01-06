echo("Remote control cover for Sharp AQUOS TV. LC-60LE65OU, although this might fit other models.");
// if clip is too stiff consider making it thinner. i.e. reduce HookW variable.

$fn=200;

RES=100;
W=23.75;
L=54.75;

Opoints = [
    for (a = [-RES:RES]) [(W/2)*(a/RES), 2.8-(a/RES)*(a/RES)],
    [W/2, 0], [-W/2,0],
        ];


//translate([0,20,0])
union(){
// MAIN BODY    
difference(){
    intersection() {
        translate([W/2,0,0]) rotate([0,0,90]) rotate([90,0,90]) linear_extrude(height=L) polygon(Opoints);
        linear_extrude(height=3) rounded_square( [23.75,54.75] );
    }
    color("green") translate([10,8,2.1]) linear_extrude(height=2) scale(0.5) rotate([0,0,90]) text("Never Forget");
    color("red") translate([16,22,2.1]) linear_extrude(height=2) scale(0.2) rotate([0,0,90]) text("Hamster");
}

// HOOK FLANGE //2.5 should be 1.5
HookW=6.75;
Hpoints = [ [0,0], [0.3,0], [1.5,0.9], [1.5,1.1], [0,1.1] ];
translate([W/2-HookW/2,L,0]) rotate([90,0,90]) linear_extrude(height=HookW) polygon(Hpoints);
}

// CLIP
ClipW = 12;

Cpoints = [ [0,0], [1.5,0], [1.5,-6.6], [1.0,-7.4], [-0.4,-7.4], [-1.2,-6.8], [-3.5,-3], 
                   [-3.5,1], [-2.2,1], [-2.2,-3], 
                   [-0.4,-6], [-0.1,-6], [0,-5.8] ];
translate([W/2-ClipW/2,0,0]) rotate([90,0,90])
union(){
    linear_extrude(height=ClipW) polygon(Cpoints);
    for (i=[0:5]) translate([-3.5,-2.5,2*i*ClipW/12+ClipW/12]) sphere(0.4);
    }

module rounded_square(dim, corners=[2.4,2.4,2.4,2.4], center=false){
  w=dim[0];
  h=dim[1];

  if (center){
    translate([-w/2, -h/2])
    rounded_square_(dim, corners=corners);
  }else{
    rounded_square_(dim, corners=corners);
  }
}

module rounded_square_(dim, corners, center=false){
  w=dim[0];
  h=dim[1];
  render(){
    difference(){
      square([w,h]);

      if (corners[0])
        square([corners[0], corners[0]]);

      if (corners[1])
        translate([w-corners[1],0])
        square([corners[1], corners[1]]);

      if (corners[2])
        translate([0,h-corners[2]])
        square([corners[2], corners[2]]);

      if (corners[3])
        translate([w-corners[3], h-corners[3]])
        square([corners[3], corners[3]]);
    }

    if (corners[0])
      translate([corners[0], corners[0]])
      intersection(){
        circle(r=corners[0]);
        translate([-corners[0], -corners[0]])
        square([corners[0], corners[0]]);
      }

    if (corners[1])
      translate([w-corners[1], corners[1]])
      intersection(){
        circle(r=corners[1]);
        translate([0, -corners[1]])
        square([corners[1], corners[1]]);
      }

    if (corners[2])
      translate([corners[2], h-corners[2]])
      intersection(){
        circle(r=corners[2]);
        translate([-corners[2], 0])
        square([corners[2], corners[2]]);
      }

    if (corners[3])
      translate([w-corners[3], h-corners[3]])
      intersection(){
        circle(r=corners[3]);
        square([corners[3], corners[3]]);
      }
  }
}
