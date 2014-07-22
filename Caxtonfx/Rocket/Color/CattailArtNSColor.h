//
//  CattailArtUIColor.h
//
//  Created by Theresa L. Ford on 10/12/08.
//  Copyright 2008 Theresa L. Ford. All rights reserved.  Visit http://www.cattail.nu
//
/*

Programmaticaly generate colors based on the art concepts of:

	complement
	split complement
	triad
	analogous
	value
	saturation
	chromatic

Choose between the RGB "light" color wheel or Newton's "art" color wheel.
See: http://www.cattail.nu/newton/index.html to compare and try these color wheels.
Most computer generated schemes are based on the RGB color wheel, because that's
the true color set based on light, however traditional art uses Newton's 
color wheel.

The first 2 functions switch hues between color wheels.  The rest of the functions
return colors which can be used to generate "eye-pleasing" color schemes
for applications and computer art.

*/

@interface CattailArtNSColor : NSObject {
}

+ (CGFloat) NewtonHueToRGBHue: (CGFloat) startHue;
+ (CGFloat) RGBHueToNewtonHue: (CGFloat) startHue;

+ (UIColor *) RGBComplement: (UIColor *)rootColor;
+ (UIColor *) NewtonComplement: (UIColor *)rootColor;

+ (NSArray *) RGBSplitComplementArray: (UIColor *)rootColor;
+ (NSArray *) NewtonSplitComplementArray: (UIColor *)rootColor;

+ (NSArray *) RGBTriadArray: (UIColor *)rootColor;
+ (NSArray *) NewtonTriadArray: (UIColor *)rootColor;

// Try 45.0 tetradicDegrees
+ (NSArray *) RGBTetradicArray: (UIColor *)rootColor tetradicDegreesCGFloat:(CGFloat)tetradicDegrees;
+ (NSArray *) NewtonTetradicArray: (UIColor *)rootColor tetradicDegreesCGFloat:(CGFloat)tetradicDegrees;

// Try 15.0 stepDegrees
+ (NSArray *) RGBAnalogousArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees;
+ (NSArray *) NewtonAnalogousArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees;

// Try 15.0 stepDegrees
+ (NSArray *) ValueArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees;

// Try 15.0 stepDegrees
+ (NSArray *) SaturationArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees;

// Evenly grab colors all the way around the wheel.  Try 6 numberOfColors.
+ (NSArray *) RGBChromaticArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors;
+ (NSArray *) NewtonChromaticArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors;

// alignment = -1 (left) 0 (center) or 1 (right)
+ (NSArray *) RGBFlameArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(int)alignment;

+ (NSArray *) NewtonFlameArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(int)alignment;

@end
