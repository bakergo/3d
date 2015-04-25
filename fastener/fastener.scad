include <../spool_holder/lib.scad>
include <../spool_holder/parts.scad>

$fn=100;

fastener_id = 6.;
fastener_ir = fastener_id / 2;
fastener_id_t = fastener_id + tolerance;
fastener_ir_t = fastener_ir + tolerance;

wall_thickness = 3.;
standoff_wall_thickness = 2;
real_wall_thickness = max(standoff_wall_thickness, wall_thickness);
standoff_height = 1;

distance_from_side = 10;
distance_factor = 1.6;

module side() {
	translation_distance = (fastener_ir + distance_from_side);
	side_length = translation_distance * distance_factor;
	translate([-wall_thickness / 2, -wall_thickness/2, -wall_thickness / 2])
	translate([translation_distance, translation_distance, 0])
	union() {
		linear_extrude(wall_thickness)
			difference() {
				hull() {
					circle(fastener_ir + real_wall_thickness);
					translate([-translation_distance, -translation_distance, 0])
						difference() {
							square(side_length);
							translate([real_wall_thickness, real_wall_thickness])
								square(side_length);
						}
				}
				circle(fastener_ir_t);
			}
		translate([0, 0, wall_thickness])
			pipe(standoff_height, fastener_ir_t, standoff_wall_thickness);
	}
}

side();
rotate([0, -90, 270])
side();
rotate([90, 0, 90])
side();

