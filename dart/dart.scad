// A foam dart gun clone. 
tolerance = .25;

head_length = 12.5;
head_diameter = 14.5;

body_diameter = 12.8;
body_length = 72.86 - head_length;
wall_thickness = 2.8;
hole_depth = 55.35;
hole_dia = 5.8;

$fn=100;

module body(body_length, body_dia, hole_depth, hole_dia) {
	body_diameter_t = body_dia - 2*tolerance;
	hole_depth_t = hole_depth + tolerance;
	hole_dia_t = hole_dia + 2 * tolerance;

	difference() {
		cylinder(body_length, d1=body_diameter_t, d2=body_diameter_t);
		cylinder(hole_depth_t, d1=hole_dia_t, d2=hole_dia_t);
	}
}

module head() {
	head_diameter_t = head_diameter - 2 * tolerance;
	head_length_t = head_length - tolerance;
	body_diameter_t = body_diameter - 2*tolerance;
	union() {
		cylinder(head_length / 2, d1=head_diameter_t, d2=head_diameter_t);
		translate([0, 0, head_length_t / 2])
		resize(newsize=[0, 0, head_length_t])
		sphere(r=head_diameter_t / 2);
		rotate_extrude()
		translate([body_diameter_t / 2, 0, 0])
		circle(r=(head_diameter_t - body_diameter_t)/2);
	}
}

union() {
	translate([0, 0, body_length])
	head();
	body(body_length, body_diameter, hole_depth, hole_dia);
}

