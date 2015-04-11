include <lib.scad>;
include <parts.scad>;

// Rim around the entire part?
rim_thickness = 1;
rim_height = 1.05;

// Rim around the bearing, to keep the spool from falling off.
bearing_rim_thickness = 1;
bearing_rim_height = 2;

standoff_thickness = 1;
standoff_height = .6;

// Amount off the table/surface that the spool will rest
spool_clearance = 10;
side_thickness = 5;

// Angle that the spool rests on the bearings. Lowering the angle makes the 
// coaster wider and shorter
tangent_angle = 55;

// The distance between the holes for the M8 bolts
hole_separation = 2 * cos(tangent_angle) * (bearing_or + spool_or);

// The radius of the two curves at the end of the bar.
// Rest the spool at height spool_clearance off the surface.
hr_max = (spool_or + spool_clearance) - (spool_or + bearing_or) * sin(tangent_angle);
hump_radius = max(spool_clearance, bearing_or_t + rim_thickness, hr_max);

// ****************************************************************************
// Uncomment to see circles drawn for the bearing and spool; comment before rendering.
// translate([hole_separation / 2, (bearing_or + spool_or)*sin(tangent_angle) , 0])
// circle(spool_or);
// translate([0, 0, side_thickness + standoff_height])
// circle(bearing_or);
// translate([hole_separation / 2, -hump_radius + spool_clearance / 2 , 0])
// circle(spool_clearance / 2);
// ****************************************************************************

// The circular curve on the top (or bottom. I'm a scad file, not a cop)
module curve() {
	// 2 * cos(tangent_angle) * (r + hump_radius) = hole_separation
	// ry = r
	// rx = hole_separation / 2
	r = (hole_separation) / (2 * cos(tangent_angle)) - hump_radius;
	translate([hole_separation / 2, (r + hump_radius)*sin(tangent_angle), 0])
		circle(r);
}

// Bar between the holes
module bar() {
	// ty = hump_radius * sin(45);
	translate([0, -hump_radius, 0])
		square([hole_separation, hump_radius * (1 + sin(tangent_angle))]);
}


// 2d silhouette of the spool holder.
module silhouette() {
	difference() {
		union() {
			circle(hump_radius);
			translate([hole_separation, 0, 0])
				circle(hump_radius);
			bar();
		}
		curve();
	}
}

// small ring around the M8 bolt hole to keep the bearing from rubbing
module standoff() {
	pipe(bearing_rim_height, bearing_or_t, bearing_rim_thickness);
	pipe(standoff_height, bearing_ir_t, standoff_thickness);
}

module spool_holder_side() {
	translate([0, 0, side_thickness])
		linear_extrude(rim_thickness)
		outline(1) silhouette();
	linear_extrude(side_thickness)
		difference() {
			silhouette();
			circle(bearing_id_t/2);
			translate([hole_separation, 0, 0])
				circle(bearing_id_t/2);
		}

	translate([0, 0, side_thickness])
		standoff();
	translate([hole_separation, 0, side_thickness])
		standoff();
}

spool_holder_side();

