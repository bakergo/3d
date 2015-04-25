$fn=1000;
top_pegs_x = 2;
top_pegs_y = 3;
stacked_on_pegs_x = 3;
stacked_on_pegs_y = 3;

peg_height = 1.7;
peg_radius = 2.4;
layer_height = 3.2;
tolerance = .25;
side_play = tolerance;
// Amount of play allowable between the squares

peg_height_t = peg_height;
peg_radius_t = peg_radius - tolerance;
peg_separation = 8.0;

stacked_on_pegs_x_lim = stacked_on_pegs_x - 1;
stacked_on_pegs_y_lim = stacked_on_pegs_y - 1;

base_x = stacked_on_pegs_x * peg_separation;
base_x_t = base_x - side_play;
base_y = stacked_on_pegs_y * peg_separation;
base_y_t = base_y - side_play;

base_square = max(stacked_on_pegs_x, stacked_on_pegs_y) * peg_separation;
base_square_t = base_square - side_play;

// Number of pegs in the x direction
peg_x_lim = top_pegs_x - 1;
peg_y_lim = top_pegs_y - 1;
bottom_peg_dia = sqrt(2*peg_separation*peg_separation) - 2 * peg_radius;
bottom_peg_radius = bottom_peg_dia / 2;
bottom_peg_radius_t = bottom_peg_radius - 2 * tolerance;
bottom_wall_thickness = (base_square - max(stacked_on_pegs_x_lim, stacked_on_pegs_y_lim) * peg_separation - 2 * peg_radius);
solid_layer_thickness = layer_height - peg_height;

difference() {
	translate([0, 0, -layer_height / 2])
	cube([base_x_t, base_y_t, layer_height], true);
	translate([0, 0, -layer_height / 2])
	cube([base_x_t - bottom_wall_thickness, base_y_t - bottom_wall_thickness, layer_height], true);
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
	for (i = [0 : stacked_on_pegs_x_lim - 1 ] ) {
		for (j = [0 : stacked_on_pegs_y_lim - 1] ) {
			translate([peg_separation*i, peg_separation*j, -peg_height])
				cylinder(peg_height, bottom_peg_radius, bottom_peg_radius, false);
		}
	}
}

intersection() {
	translate([0, 0, -solid_layer_thickness/2])
	cube([base_x_t, base_y_t, peg_height + layer_height], center=true);
	union() {
		translate([-peg_separation * peg_x_lim / 2, -peg_separation * peg_y_lim / 2, 0])
		peg_grid();
		translate([-peg_separation * (stacked_on_pegs_x_lim - 1) / 2, -peg_separation * (stacked_on_pegs_y_lim - 1) / 2, -solid_layer_thickness])
		bottom_peg_grid();
		translate([0, 0, -solid_layer_thickness/2])
		cube([base_x_t, base_y_t, solid_layer_thickness], center=true);
	}
}

