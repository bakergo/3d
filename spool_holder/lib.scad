tolerance=.25;
phi=1.618;
bearing_id = 8;
bearing_od = 22;
bearing_or = bearing_od / 2;
bearing_id_t = bearing_id + 2 * tolerance;
bearing_od_t = bearing_od + 2 * tolerance;
bearing_ir_t = bearing_id / 2 + tolerance;
bearing_or_t = bearing_od / 2 + tolerance;

spool_id = 32;
spool_or = spool_id / 2 + 84.75;
spool_width = 64;

module hollow_cylinder(height, or, ir) {
	difference() {
		cylinder(height, r1=or, r2=or);
		cylinder(height, r1=ir, r2=ir);
	}
}

module pipe(height, r, wall_thickness) {
	hollow_cylinder(height, r, r-wall_thickness);
}

// 2-dimensional ring of given radii.
module ring(or, ir) {
	difference() {
		circle(or);
		circle(ir);

	}
}

module outline(thickness) {
	difference() {
		children();
		__inverted_outline(thickness) children();
	}
}

module __inverted_outline(thickness) {
	difference() {
		children();
		render() {
			minkowski() {
				shell(thickness)
					children();
				circle(thickness);
			}
		}
	}

}

module shell(thickness) {
	difference() {
		render() {
			minkowski() {
				children();
				circle(thickness);
			}
		}	
		children();
	}

}
