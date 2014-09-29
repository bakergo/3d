tolerance=.25;

// internal diameter of the spool
spool_id = 32;
// outside radius of the spool
spool_or = spool_id / 2 + 84.75;
spool_width = 64;


// 680ZZ bearing
// inner diameter
bearing_id = 8;
// outer diameter
bearing_od = 22;
bearing_or = bearing_od / 2;

// with tolerances
bearing_id_t = bearing_id + 2 * tolerance;
bearing_od_t = bearing_od + 2 * tolerance;
bearing_ir_t = bearing_id / 2 + tolerance;
bearing_or_t = bearing_od / 2 + tolerance;
