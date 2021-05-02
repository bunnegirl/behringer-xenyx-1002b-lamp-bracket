// Thickness of the rack ear plate
plateThickness = 3;
// Height of the rack ear plate
plateHeight = 25;
// Diameter of the rack ear mounting screws
plateScrewDiameter = 3;
// Space between each of the rack ear mounting screws
plateScrewSpacing = 75;
// Thickness of the mount
mountThickness = 3;
// Adjust the elevation of the bracket (min 0, max 90)
mountAngle = 10;
// Angle to rotate the mounting hole in order to hold the lamp level
mountHoleAngle = 7.8;
// 12mm for standard articulating lamps
mountHoleDiameter = 12;
// Height of the mounting shaft of your lamp (min 30)
mountHoleHeight = 40;
// Set to true to mirror the bracket
mirrorBracket = false;

plateScrewRadius = plateScrewDiameter / 2;
mountHoleRadius = mountHoleDiameter / 2;
mountHeight = mountHoleRadius + mountThickness;

$fn = 50;

module plate_shape()
{
    translate([-plateScrewSpacing / 2, -plateScrewRadius - plateThickness, 0])
        difference()
    {
        hull()
        {
            circle(plateScrewRadius + plateThickness);

            translate([plateScrewSpacing, 0, 0])
                circle(plateScrewRadius + plateThickness);

            translate([
                (plateScrewSpacing / 2) + ((plateHeight / 2) * sin(mountHoleAngle)),
                -(plateHeight / 2) + plateScrewRadius + plateThickness,
                0
            ])
                circle(plateHeight / 2);
        }

        circle(plateScrewRadius);

        translate([plateScrewSpacing, 0, 0])
            circle(plateScrewRadius);
    }
}

module mount_shape()
{
    difference()
    {
        translate([0, (mountHoleRadius + mountThickness) / 2, 0])
            square(
                [
                    (mountHoleRadius + mountThickness) * 4,
                    mountHoleRadius + mountThickness
                ],
                true
            );

        translate([
            -mountHoleDiameter - mountThickness - mountThickness,
            0,
            0
        ])
            circle(mountHoleRadius + mountThickness);

        translate([
            mountHoleDiameter + mountThickness + mountThickness,
            0,
            0
        ])
            circle(mountHoleRadius + mountThickness);

        translate([0, 0, 0])
            circle(mountHoleRadius + mountThickness);
    }
}

module bracket()
{
    // Plate
    rotate([-90, 0, 0])
        linear_extrude(plateThickness)
        plate_shape();

    // Mount
    intersection()
    {
        rotate([0, mountHoleAngle, 0])
            union()
        {
            difference()
            {
                translate([0, -mountHeight, -mountHoleHeight])
                    linear_extrude(mountHoleHeight + plateHeight, convexity = 5)
                    mount_shape();

                rotate([0, -mountHoleAngle, 0])
                    multmatrix([
                        [1, 0, 0, 0],
                        [0, 1, 0, 0],
                        [0, sin(mountAngle), 1, 0],
                    ])
                    translate([
                        0,
                        -(plateScrewSpacing) + plateThickness,
                        -plateScrewSpacing,
                    ])
                    cube(plateScrewSpacing * 2, true);
            }

            cylHeight = mountHoleHeight + (mountHoleHeight * sin(mountAngle));

            translate([
                0,
                -mountHoleRadius - mountThickness,
                -(cylHeight / 2)
            ])
                difference()
            {
                cylinder(cylHeight + plateHeight, mountHoleRadius + mountThickness, mountHoleRadius + mountThickness);
                translate([0, 0, -mountThickness])
                    cylinder(mountHoleHeight + mountThickness, mountHoleRadius, mountHoleRadius);
            }
        }

        union()
        {
            translate([
                0,
                -(plateScrewSpacing) + plateThickness,
                -plateScrewSpacing,
            ])
                cube(plateScrewSpacing * 2, true);

            multmatrix([
                [1, 0, 0, 0],
                [0, 1, 0, 0],
                [0, sin(mountAngle), 1, 0],
            ])
                translate([
                    0,
                    -plateScrewSpacing, 0])
                    rotate([-90, 0, 0])
                    linear_extrude(plateScrewSpacing, convexity = 5)
                    plate_shape();
        }
    }
}

if (mirrorBracket)
{
    rotate([0, 0, 180])
        bracket();
}
else
{
        bracket();
}