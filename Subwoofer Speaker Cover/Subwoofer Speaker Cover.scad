

extra = 2.0;

module plate(width,depth,height, cornerRadius)
{
    translate([-width/2.0, -depth/2.0, -height/2.0])
    {
        difference()
        {
            cube([width,depth,height]);
            translate([-extra,-extra,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
            translate([-extra,depth-cornerRadius,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
            translate([width-cornerRadius,depth-cornerRadius,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
            translate([width-cornerRadius,-extra,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
        }
        translate([cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
    }
}   

module fin(width,depth,height, cornerRadius)
{
    translate([-width/2.0, -depth/2.0, -height/2.0])
    {
        difference()
        {
            cube([width,depth,height]);
            translate([-extra,depth-cornerRadius,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
            translate([width-cornerRadius,depth-cornerRadius,-extra])
            {
                cube([cornerRadius+extra,cornerRadius+extra,height+2*extra]);
            }
        }
        translate([cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
        translate([width-cornerRadius,depth-cornerRadius,0]) cylinder(r=cornerRadius,h=height);
    }
}   



module makeHoleCylinders(positions, diameter, depth, extra)
{
    for (a = [ 0 : len(positions) - 1 ]) 
    {
        point=positions[a];
        translate([point[0],point[1],-extra]){
            cylinder(r=diameter/2.0,h=depth+2*extra);
        }
    }
}

module makeMountingHoles(holeXSpacing, holeYSpacing, diameter, depth, extra)
{
    halfX=holeXSpacing/2.0;
    halfY=holeYSpacing/2.0;
    
    mountingHoles = [[-halfX,halfY],[-halfX,-halfY],[halfX,-halfY],[halfX,halfY]];
    
    makeHoleCylinders(mountingHoles,diameter, depth, extra);
}

module mountingStrap(holeXSpacing,holeYSpacing,thickness, holeDiameter, margin, cornerRadius)
{
    width = holeXSpacing+(2*margin);
    depth = holeYSpacing+(2*margin);
    difference()
    {
        plate(width, depth, thickness, cornerRadius);
        makeMountingHoles(holeXSpacing, holeYSpacing, holeDiameter, thickness, extra);
    }
}

module straightFins(plateWidth, plateDepth, finMargin, finHeight, finDepth, noOfFins, thickness)
{
    finSpace = plateDepth - (2*finMargin);
    
    finGap = finSpace/(noOfFins-1);
    
    finPos = -(plateDepth/2.0)+finMargin;
    
    for (a = [ 0 : noOfFins-1 ]) 
    {
        translate([0,finPos+a*finGap,finHeight/2.0-thickness/2.0])
        {
            rotate([90,0,0])
            {
                fin(plateWidth-(2*finMargin), finHeight, finDepth, 2.0);
            }
        }
    }
}


module curvedFins(plateDiameter, finMargin, finHeight, finDepth, noOfFins, thickness)
{
    finSpace = plateDiameter - (2*finMargin);
    
    finGap = finSpace/(noOfFins-1);
    
    finPos = -(plateDiameter/2.0)+finMargin;
    
    for (a = [ 0 : noOfFins-1 ]) 
    {
        translate([0,finPos+a*finGap,finHeight/2.0-thickness/2.0])
        {
            rotate([90,0,0])
            {
                fin(finSpace, finHeight, finDepth, 2.0);
            }
        }
    }
}



module speakerCover()
{
    holeXSpacing=175.0;
    holeYSpacing=25.0;
    thickness=3.0;
    margin=7.0;
    cornerRadius=5.0;
    holeDiameter=4.0;
    
    speakerHoleDiameter = 128.0;
    
    plateWidth=150.0;
    plateDepth=130.0;
    
    finHeight=10.0;
    finDepth=2.0;
    finMargin=2.0;
    noOfFins=10;
    
    union()
    {
        difference()
        {
            union()
            {
                mountingStrap(holeXSpacing, holeYSpacing, thickness, holeDiameter, margin,cornerRadius);
                plate(plateWidth,plateDepth,thickness, cornerRadius);
            }
            
            translate([0,0,-thickness/2.0-extra])cylinder(h=thickness+(2*extra), r=speakerHoleDiameter/2.0,$fn = 80);
        }
        straightFins(plateWidth, plateDepth, finMargin, finHeight, finDepth, noOfFins, thickness);
    }
}

module pushPin()
{
    boxHoleTopDiam=5.65;
    boxHoleBottomDiam=5.75;
    boxHoleDepth=6;

    screwHoleOuterDiam=7.0;
    screwHoleDiam=3.25;
    screwHoleDepth=4.0;
    extra=0.5;
    
    difference()
    {
        union()
        {
             cylinder(r1=boxHoleBottomDiam/2.0,r2=boxHoleTopDiam/2.0,h=boxHoleDepth,$fn = 80);
        }
        translate([0,0,-extra])
        {
            cylinder(r=screwHoleDiam/2.0,h=screwHoleDepth+extra,$fn = 80);        
        }
    }
}

color("red")
//pushPin();
speakerCover();
