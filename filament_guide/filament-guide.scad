// Diameter of the Z-axis rod, mm
rod_dia=12;
rod_r=rod_dia / 2;
tolerance = .25; // Amount of mechanical tolerance in the part
smooth_r = 1; // the radius at which everything is smoothed.

// Outside separation of the two rods
rod_sep=60;
rod_pos=(rod_sep - rod_dia) / 2;
rod_h=60;

$fs=.1;

wall_size=1;
sit_on=20;
bridge_fatness=5;
top_fatness=2;

loop_height=15;
sphere_r = rod_r + wall_size;

module centered_cube(x, y, z) {
	translate([-x/2, -y/2, -z])
	cube([x, y, z]);

}
module ring(rod_r, wall_size, loop_height) {
	sphere_r = rod_r + wall_size;
	difference() {
		scale([1, 1, loop_height / sphere_r])
		sphere(sphere_r);
		scale([1, 1, (loop_height - wall_size) / (sphere_r - wall_size)])
		rotate([0, 90, 0])
		linear_extrude(rod_sep * 2, center=true)
		circle(sphere_r - wall_size);
		centered_cube(2*sphere_r, 2*sphere_r, sphere_r);
	}

};

difference() {
	minkowski() {
		union() {
			cylinder(sit_on + top_fatness, 
				rod_r + wall_size,
				rod_r + wall_size);
			translate([0, 0, sit_on + top_fatness])
			ring(rod_r, wall_size, loop_height);
		}
		sphere(smooth_r);
	}
	translate([0, 0, -sit_on])
	cylinder(sit_on * 2, r1=rod_r + tolerance,r2=rod_r + tolerance);
	centered_cube(4*rod_r, 4*rod_r, rod_r);
}


