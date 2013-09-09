// ===== DremelFuge =====
// Cathal Garvey (cathalgarvey@gmail.com
// Creative Commons Sharealike Attribution license
// http://creativecommons.org/licenses/by-sa/3.0/
// Also re-licensed under the GNU AGPL 3.0 or later:
// https://www.gnu.org/licenses/agpl.txt

// ===== Parameters =====
// Includes:
<shapes.scad><Eppie.scad>
// Note: Shapes.scad is released under a GNU License, further details in that script.
// Many thanks to Catarina Mota <clifford@clifford.at> for providing this very useful resource to the community!
// Note also: Eppie.scad is released under a Creative Commons Attribution Sharealike License.

// All dimensions are in mm.
// $fn is a global variable that determines the number of faces to divide a curved surface into. Increase $fn for more detailed models.
$fn = 80;

// EppieRad is how wide the top of the eppie is, but not the lip! The Lip should exceed this width by a good margin!
EppieRad = 5.35;
EppieLipRad = 6.65;
// AxleRad is the radius of the axle that protudes from the top, which is accepted by the drill/dremel to spin the device.
// AxleLength is how long the Axle is, including the rotor.
AxleRad = 4.5;
AxleLength = 12.5;
HollowAxle = 1;

// AxleInnerRad is how wide the inner bore of the axle should be, if HollowAxle is set to 1.
// AxleInnerDepth is how deep the bore should be starting from the top of the Axle Length.
// ScrewHoleRad is how wide the smaller hole at the end of the Inner Bore should be.
AxleInnerRad = 2.45;
AxleInnerDepth = 10.5;
ScrewHoleRad = 1;

// RotorDisplacement is how far from the central axle the rotor is intended to extend.
// This determines in large part the G-force that will be applied to the spun samples.
RotorDisplacement = 32;
// RotorEdgeSpan is how thick the rim of the rotor should be.
// This confers strength and momentum, but puts more strain on the dremel and likely increases the odds of uneven plastic infill.
RotorEdgeSpan = 5.8;
// SpokeWidth is how thick the spokes of the rotor/axle are.
SpokeWidth = 3;
// SpokeSpan is how long a spoke is from tip to tip.
SpokeSpan = RotorDisplacement*2 - RotorEdgeSpan / 2;

// RotorHeight is how tall the Rotor is when placed on end. It's important that this be larger than the diameter of the Eppies used, or the holes cut for the Eppies will be larger than the rotor's rim!
RotorHeight = 12.5;

// ===== Modules ======
module Spoke(SpokeH,SpokeL,SpokeW,SpokeRo){
	translate([0,0,SpokeH/2]) rotate([0,0,SpokeRo])
		cube([SpokeL,SpokeW,SpokeH],center=true);
}
module Rotor(SpurR,SpurH,RimW,RimR,SpokeW,Height,BoreD,BoreW,ScrewW){
	difference(){
		union(){
			cylinder(SpurH,SpurR,SpurR);
			tube(Height,RimR,RimW);
			Spoke(Height,SpokeSpan,SpokeW,60);
			Spoke(Height,SpokeSpan,SpokeW,120);
			Spoke(Height,SpokeSpan,SpokeW,180);
		}
		if(HollowAxle == 1){
			translate([0,0,SpurH-BoreD]) cylinder(BoreD,BoreW,BoreW);
			cylinder(SpurH,ScrewW,ScrewW);
		}
	}
}
module EppieCutouts(CutOutSize,Rotation){
		// Cylinder for Eppie:
		translate([0,0,1+RotorHeight/2]) rotate([0,90,Rotation]) translate([0,0,-RotorDisplacement-1])
			cylinder(RotorEdgeSpan+3,CutOutSize,CutOutSize);
		translate([0,0,1+RotorHeight/2]) rotate([0,90,Rotation]) 
			translate([0,0,-RotorDisplacement+RotorEdgeSpan-0.5])
				cylinder(3,CutOutSize+1.2,EppieLipRad);
		// Box cutout for ease of insertion:
		translate([0,0,RotorHeight-2]) rotate([0,90,Rotation]) translate([0,0,-RotorDisplacement+3.7])
					cube([5,CutOutSize*2-0.48,RotorEdgeSpan+2],center = true);
		// Box cutout to preserve cap closure:
		translate([0,0,1.9]) rotate([0,90,Rotation]) translate([0,0,-RotorDisplacement+RotorEdgeSpan])
					cube([4,CutOutSize*2-0.5,4],center = true);

		// Matching Cylinder for facing Eppie:
		translate([0,0,1+RotorHeight/2]) rotate([0,90,Rotation+180]) translate([0,0,-RotorDisplacement-1])
			cylinder(RotorEdgeSpan+3,CutOutSize,CutOutSize);
		translate([0,0,1+RotorHeight/2]) rotate([0,90,Rotation+180])
			translate([0,0,-RotorDisplacement+RotorEdgeSpan-0.5])
				cylinder(3,CutOutSize+1.2,EppieLipRad);
		// Box cutout for ease of insertion:
		translate([0,0,RotorHeight-2]) rotate([0,90,Rotation+180]) translate([0,0,-RotorDisplacement+3.7])
					cube([5,CutOutSize*2-0.48,RotorEdgeSpan+2],center = true);
		// Box cutout to preserve cap closure:
		translate([0,0,1.9]) rotate([0,90,Rotation+180]) translate([0,0,-RotorDisplacement+RotorEdgeSpan])
					cube([4,CutOutSize*2-0.5,4],center = true);
}

module RotorWithHoles(){
	difference(){
		Rotor(AxleRad, AxleLength, RotorEdgeSpan, RotorDisplacement, SpokeWidth, RotorHeight,AxleInnerDepth,AxleInnerRad,ScrewHoleRad);
		EppieCutouts(EppieRad,30);
		EppieCutouts(EppieRad,90);
		EppieCutouts(EppieRad,150);
		}
	}

RotorWithHoles();
