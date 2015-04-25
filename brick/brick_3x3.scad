$fn=100;
peg_height = 1.7;
peg_radius = 2.4;
layer_height = 3.2;
// 1" square
inch = 25.4;
base_square = inch;
tolerance = .25;
// Amount of play allowable between the squares
side_play = 1;

peg_height_t = peg_height;
peg_radius_t = peg_radius - tolerance;
peg_separation = 8.0;
base_square_t = base_square - side_play;

// Number of pegs in the x direction
peg_x = 2;
peg_y = 3;
peg_x_lim = peg_x - 1;
peg_y_lim = peg_y - 1;
bottom_peg_dia = sqrt(2*peg_separation*peg_separation) - 2 * peg_radius;
bottom_peg_radius = bottom_peg_dia / 2;
bottom_peg_radius_t = bottom_peg_radius - 2 * tolerance;
bottom_wall_thickness = (base_square - 2 * peg_separation - 2 * peg_radius);
solid_layer_thickness = layer_height - peg_height;
difference() {
	translate([0, 0, -layer_height / 2])
	cube([base_square_t, base_square_t, layer_height], true);
	translate([0, 0, -layer_height / 2])
	cube([base_square_t - bottom_wall_thickness, base_square_t - bottom_wall_thickness, layer_height], true);
}

module peg_grid() {
	for (i = [0 : peg_x_lim ] ) {
		for (j = [0 : peg_y_lim ] ) {
			translate([peg_separation*i, peg_separation*j, 0])
				cylinder(peg_height_t, peg_radius_t, peg_radius_t, false);
		}
	}
}

module bottom_peg_grid() {
	for (i = [0 : peg_x_lim + 1 ] ) {
		for (j = [0 : peg_y_lim - 1] ) {
			translate([peg_separation*i, peg_separation*j, -peg_height])
				cylinder(peg_height, bottom_peg_radius, bottom_peg_radius, false);
		}
	}
}


intersection() {
	translate([0, 0, -solid_layer_thickness/2])
	cube([base_square_t, base_square_t, peg_height + layer_height], center=true);
	union() {
		translate([-peg_separation * peg_x_lim / 2, -peg_separation * peg_y_lim / 2, 0])
		peg_grid();
		translate([-peg_separation, -peg_separation * .5, -solid_layer_thickness])
		bottom_peg_grid();
		translate([0, 0, -solid_layer_thickness/2])
		cube([base_square_t, base_square_t, solid_layer_thickness], center=true);
	}
}

