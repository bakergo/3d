$fn=360;
height_in = 3.1;
o_dia_in = 1.5;

o_height = height_in * 25.4;
o_dia = o_dia_in * 25.4;

floor_thickness = 2;
wall_thickness = 2;
bezel = 1;
i_dia = o_dia - wall_thickness * 2;
slit_width = 1.5;

handle_height = 19;
handle_lift = 8;
handle_width = 4;
handle_corner_r = 1;
handle_wall_thickness = 2;
handle_support_distance=handle_lift;

rim_offset = 7.5;
rim_dia = 2;

slit_dist = 20;

cap_play = 7.5;
cap_height = floor_thickness + cap_play + rim_offset;
cap_tooth_width = 5;

module rounded_square(size, r) {
    width = size[0];
    height = size[1];

    union() {
        square([width, height-2*r], center=true);
        square([width-2*r, height], center=true);            
        for (i = [[1, 1], [-1, 1], [-1, -1], [1, -1]]) {
            translate([i[0] * (width-2*r) / 2 , 
                       i[1] * (height-2*r) / 2])
            circle(r, center=true);
        }
    }
}

module rim() {
    // Rounded lip on the top
    translate([0, 0, o_height / 2 - rim_offset])
    rotate_extrude(angle=360)
    translate([(o_dia) / 2, 0, 0])
    circle(d=rim_dia, $fn=20) ;
}

module poop_bag_cylinder() {
    difference() {
        union() {
            cylinder(
                h=o_height,
                d=o_dia,
                center=true);
            // Rounded lip on the top
            
            translate([0, 0, o_height / 2])
            rotate_extrude(angle=360)
            translate([(o_dia - wall_thickness) / 2, 0, 0])
            circle(d=wall_thickness, $fn=20) ;
            rim();
        }
        bezel_side = bezel * sqrt(2) / 2;
        translate([0, 0, floor_thickness / 2])
        cylinder(
            h=o_height - floor_thickness,
            d=i_dia,
            center=true);
        // bezeled edge on the bottom
        translate([0, 0, -o_height/ 2])
        rotate_extrude(angle=360)
        translate([o_dia / 2, 0, 0])
        rotate(45)
        square([bezel_side, bezel_side], center=true);
        
        // Slit for bags
        rotate([0, 0, 180])
        translate([0, 0, slit_dist / 2])
        difference() {
            sliver_dia = o_dia + rim_dia;
            sliver_height = o_height - slit_dist + wall_thickness;
            angle = slit_width * 360 / PI / sliver_dia;
            cylinder(h=sliver_height, d = o_dia+rim_dia, center=true);
            rotate([0, 0, angle/2])
            union() {
                translate([0, sliver_dia/4, 0])
                cube([sliver_dia, sliver_dia/2, sliver_height], center=true); 
                rotate([0, 0, 180-angle])
                translate([0, sliver_dia/4, 0])
                cube([sliver_dia, sliver_dia/2, sliver_height], center=true); 
            }
        }
    }
}

module handle() {
    translate([0, 0, -handle_width / 2])
    linear_extrude(height = handle_width)
    union() {
        difference() {
          rounded_square([handle_height, handle_lift],
                r=handle_corner_r);
          rounded_square([handle_height - 2 * handle_wall_thickness,
                handle_lift - 2*handle_wall_thickness],
                r=handle_corner_r);
        }
        real_handle_support_distance = handle_support_distance - sqrt(2)/2 * handle_corner_r;
        // Corner tangent variable
        c_tan = sqrt(2)/2 * handle_corner_r;
        
        for (i = [-1,1]) {
            polygon(points=[
                [-i*(handle_height/2-handle_corner_r), -handle_lift/2],
                [-i*(handle_height / 2 + real_handle_support_distance), -handle_lift / 2],
                [-i*(handle_height/2 - handle_corner_r+c_tan),
                handle_lift/2-handle_corner_r+c_tan]]);
        }
    }
}

poop_bag_cylinder();
translate([i_dia / 2, 0, 0])
translate([handle_lift / 2, 0, 0])
rotate([90, 90, 0])
handle();