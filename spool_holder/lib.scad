$fn=100;

module hollow_cylinder(height, or, ir) {
	difference() {
		cylinder(height, r1=or, r2=or);
		cylinder(height, r1=ir, r2=ir);
	}
}

module pipe(height, ir, wall_thickness) {
	hollow_cylinder(height, ir+wall_thickness, ir);
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
