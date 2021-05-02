// Thickness of the overall print
thickness = 3;
// Diameter of the rack ear mounting screws
screwDiameter = 3;
// Space between each of the rack ear mounting screws
screwSpacing = 76;
// Angle to rotate the mounting hole in order to hold the lamp level
mountHoleAngle = 5;
// 12mm for standard articulating lamps
mountHoleDiameter = 12;
// Height of the mounting shaft of your lamp
mountHoleHeight = 30;
// Distance from the mounting plate to place the mount hole
mountHoleOffset = 3;
// Set to true to mirror the bracket
mirrorBracket = true;

screwRadius = screwDiameter / 2;
mountHoleRadius = mountHoleDiameter / 2;

$fn = 50;

module plate_shape()
{
    difference()
    {
        hull()
        {
            circle(screwRadius + thickness);

            translate([screwSpacing, 0, 0])
                circle(screwRadius + thickness);
            
            translate([screwSpacing / 2, -(mountHoleHeight / 2) + screwRadius + thickness, 0])
                circle(mountHoleHeight / 2);
        }

        circle(screwRadius);

        translate([screwSpacing, 0, 0])
            circle(screwRadius);
    }
}

module mount_shape()
{
    difference()
    {
        union()
        {
            // Outer curve
            circle(mountHoleRadius + thickness);

            // Square base
            translate([
                0, (mountHoleRadius + mountHoleOffset + thickness) / 2, 0
            ])
                square([
                    (mountHoleRadius + thickness) * 2,
                    mountHoleRadius + mountHoleOffset + thickness
                ], true);

            // Right hand corner
            translate([
                mountHoleRadius + (thickness * 1.5),
                mountHoleRadius + mountHoleOffset + (thickness / 2),
                0
            ])
                difference()
            {
                square(thickness, true);
                translate([thickness / 2, -thickness / 2, 0])
                    circle(thickness);
            }

            // Left hand corner
            translate([
                -mountHoleRadius - (thickness * 1.5),
                mountHoleRadius + mountHoleOffset + (thickness / 2),
                0
            ])
                difference()
            {
                square(thickness, true);
                translate([-thickness / 2, -thickness / 2, 0])
                circle(thickness);
            }
        }

        circle(mountHoleRadius);
    }
}

module bracket()
{
    translate([0, 0, screwRadius + thickness])
        rotate([-90, 0, 0])
    {
        linear_extrude(thickness)
            plate_shape();

        intersection()
        {
            translate([
                screwSpacing / 2,
                -mountHoleHeight,
                mountHoleDiameter + mountHoleOffset
            ])
                rotate([-90, 0, -mountHoleAngle])
                linear_extrude(mountHoleHeight * 2, convexity = 5)
                mount_shape();

            linear_extrude(mountHoleHeight + mountHoleOffset)
                plate_shape();
            
            translate([0, 0, thickness])
                multmatrix([
                    [1, 0, 0, 0],
                    [0, 1, 0.25, 0],
                    [0, 0, 1, 0],
                ])
                linear_extrude(mountHoleHeight + mountHoleOffset, convexity = 5)
                plate_shape();
        }
    }
}

if (mirrorBracket)
{
    translate([screwSpacing / 2, 0, 0])
        rotate([0, 0, 180])
        bracket();
}
else
{
    translate([-screwSpacing / 2, 0, 0])
        bracket();
}