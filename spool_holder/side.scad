include <lib.scad>;

$fn=100;

rim_thickness = 1;
rim_height = 1;

standoff_thickness = 1;
standoff_height = .5;

// Amount off the table that the spool will rest
spool_clearance = 10;
side_thickness = 5;
tangent_angle = 50; // Don't go much lower than 50.

// The angle to the humps on which the cut-out circle rests.
// Imagine it as a wheel resting on pegs.
hole_separation = 2 * cos(tangent_angle) * (bearing_or + spool_or);

// The radius of the two curves at the end of the bar.
// Rest the spool at height spool_clearance off the surface.
hr_max = (spool_or + spool_clearance) - (spool_or + bearing_or) * sin(tangent_angle);
hump_radius = max(spool_clearance, bearing_or_t + rim_thickness, hr_max);

// Double checking the bearing and spool
// translate([hole_separation / 2, (bearing_or + spool_or)*sin(tangent_angle) , 0])
// circle(spool_or);
// translate([0, 0, side_thickness + standoff_height])
// circle(bearing_or);
// translate([hole_separation / 2, -hump_radius + spool_clearance / 2 , 0])
// circle(spool_clearance / 2);

module curve() {
	// 2 * cos(tangent_angle) * (r + hump_radius) = hole_separation
	// ry = r
	// rx = hole_separation / 2
	r = (hole_separation) / (2 * cos(tangent_angle)) - hump_radius;
	translate([hole_separation / 2, (r + hump_radius)*sin(tangent_angle), 0])
		circle(r);
}

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

module standoff() {
	pipe(standoff_height, standoff_thickness + bearing_ir_t, standoff_thickness);
}

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

