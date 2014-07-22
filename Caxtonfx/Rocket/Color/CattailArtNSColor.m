//
//  CattailArtUIColor.m
//
//  Created by Theresa L. Ford on 10/12/08.
//  Copyright 2008 Theresa L. Ford. All rights reserved.  Visit http://www.cattail.nu
//

#import "CattailArtNSColor.h"


@implementation CattailArtNSColor

+ (CGFloat) NewtonHueToRGBHue: (CGFloat) startHue
{
	if (startHue < (120.0/360.0))
		return startHue / 2.0;
	else if (startHue < (180.0/360.0))
		return startHue - (60.0/360.0);
	else if (startHue < (240.0/360.0))
		return 2.0 * (startHue - (120.0/360.0));
	else
		return startHue;
}

+ (CGFloat) RGBHueToNewtonHue: (CGFloat) startHue
{
	if (startHue < (60.0/360.0))
		return startHue * 2.0;
	else if (startHue < (120.0/360.0))
		return startHue + (60.0/360.0);
	else if (startHue < (240.0/360.0))
		return (startHue / 2.0) + (120.0/360.0);
	else
		return startHue;
}

+ (UIColor *) RGBComplement: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	hue += (180.0/360.0);
	if(hue > 1) hue -= 1;
    UIColor *colorComplement = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
	return colorComplement;
}

+ (UIColor *) NewtonComplement: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	hue = [self RGBHueToNewtonHue:hue];
	hue += (180.0/360.0);
	if(hue > 1) hue -= 1;
	hue = [self NewtonHueToRGBHue:hue];
    UIColor *colorComplement = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return colorComplement;
}

+ (NSArray *) RGBSplitComplementArray: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue += 150.0/360.0;
	if(hue > 1) hue -= 1;
    UIColor *splitComplement2 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue += 60.0/360.0;
	if(hue > 1) hue -= 1;
    UIColor *splitComplement3 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *splitComplements = [NSArray arrayWithObjects:rootColor, splitComplement2, splitComplement3, nil];
	return splitComplements;
}

+ (NSArray *) NewtonSplitComplementArray: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 150.0/360.0;
	if(hue > 1) hue -= 1;
	hue = [self NewtonHueToRGBHue:hue];
    UIColor *splitComplement2 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 60.0/360.0;
	if(hue > 1) hue -= 1;
	hue = [self NewtonHueToRGBHue:hue];
    UIColor *splitComplement3 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *splitComplements = [NSArray arrayWithObjects:rootColor, splitComplement2, splitComplement3, nil];
	return splitComplements;
}

+ (NSArray *) RGBTriadArray: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue += 120.0/360.0;
	if(hue > 1) hue -= 1;
    UIColor *triad2 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue += 120.0/360.0;
	if(hue > 1) hue -= 1;
    UIColor *triad3 = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *triads = [NSArray arrayWithObjects:rootColor, triad2, triad3, nil];
	return triads;
}

+ (NSArray *) NewtonTriadArray: (UIColor *)rootColor
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 120.0/360.0;
	if(hue > 1) hue -= 1;
	hue = [self NewtonHueToRGBHue:hue];
	UIColor *triad2 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 120.0/360.0;
	if(hue > 1) hue -= 1;
	hue = [self NewtonHueToRGBHue:hue];
	UIColor *triad3 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *triads = [NSArray arrayWithObjects:rootColor, triad2, triad3, nil];
	return triads;
}

+ (NSArray *) RGBTetradicArray: (UIColor *)rootColor tetradicDegreesCGFloat:(CGFloat)tetradicDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue += 180.0/360.0;
	if(hue > 1) hue -= 1;
	UIColor *tetradic2 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue += tetradicDegrees/360.0;
	if(hue > 1) hue -= 1;
	UIColor *tetradic3 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue += 180.0/360.0;
	if(hue > 1) hue -= 1;
	UIColor *tetradic4 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *tetradics = [NSArray arrayWithObjects:rootColor, tetradic2, tetradic3, tetradic4, nil];
	return tetradics;
}

+ (NSArray *) NewtonTetradicArray: (UIColor *)rootColor tetradicDegreesCGFloat:(CGFloat)tetradicDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 180.0/360.0;
	hue = [self NewtonHueToRGBHue:hue];
	if(hue > 1) hue -= 1;
	UIColor *tetradic2 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += tetradicDegrees/360.0;
	hue = [self NewtonHueToRGBHue:hue];
	if(hue > 1) hue -= 1;
	UIColor *tetradic3 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	hue = [self RGBHueToNewtonHue:hue];
	hue += 180.0/360.0;
	hue = [self NewtonHueToRGBHue:hue];
	if(hue > 1) hue -= 1;
	UIColor *tetradic4 =[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];

	NSArray *tetradics = [NSArray arrayWithObjects:rootColor, tetradic2, tetradic3, tetradic4, nil];
	return tetradics;
}

+ (NSArray *) RGBAnalogousArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway = numberOfColors/2;
	int iterations;
	stepDegrees = stepDegrees/360.0;
	hue -= (stepDegrees * (float) midway);

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	if (hue < 0) hue += 1;
	for(iterations=0;iterations<numberOfColors;iterations++){
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue += stepDegrees;
		if(hue > 1) hue -= 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) NewtonAnalogousArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway = numberOfColors/2;
	int iterations;
	stepDegrees = stepDegrees/360.0;

	hue = [self RGBHueToNewtonHue:hue];
	hue -= (stepDegrees * (float) midway);
	if (hue < 0) hue += 1;

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	for(iterations=0;iterations<numberOfColors;iterations++){
		hue = [self NewtonHueToRGBHue:hue];
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue = [self RGBHueToNewtonHue:hue];
		hue += stepDegrees;
		if(hue > 1) hue -= 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) ValueArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway = numberOfColors/2;
	int iterations;
	stepDegrees = stepDegrees/100.0;
	brightness -= (stepDegrees * (float) midway);

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	if (brightness < 0) brightness = 0;
	for(iterations=0;iterations<numberOfColors;iterations++){
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		brightness += stepDegrees;
		if (brightness < 0) brightness = 0;
		else if (brightness > 1) brightness = 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) SaturationArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors stepDegreesCGFloat:(CGFloat)stepDegrees
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway = numberOfColors/2;
	int iterations;
	stepDegrees = stepDegrees/100.0;
	saturation -= (stepDegrees * (float) midway);

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	if (saturation < 0) saturation = 0;
	for(iterations=0;iterations<numberOfColors;iterations++){
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		saturation += stepDegrees;
		if (saturation < 0) saturation = 0;
		else if (saturation > 1) saturation = 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) RGBChromaticArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	
	int midway = numberOfColors / 2;
	float stepDegrees = (360.0 / (float) numberOfColors) / 360.0;
	hue -= (stepDegrees * (float) midway);
	if (hue < 0) hue += 1;

	int iterations;

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	for(iterations=0;iterations<numberOfColors;iterations++){
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue += stepDegrees;
		if(hue > 1) hue -= 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) NewtonChromaticArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway = numberOfColors / 2;
	float stepDegrees = (360.0 / (float) numberOfColors) / 360.0;

	hue = [self RGBHueToNewtonHue:hue];
	hue -= (stepDegrees * (float) midway);
	if (hue < 0) hue += 1;

	int iterations;

	NSMutableArray * colors = [[NSMutableArray alloc] init];

	for(iterations=0;iterations<numberOfColors;iterations++){
		hue = [self NewtonHueToRGBHue:hue];
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue = [self RGBHueToNewtonHue:hue];
		hue += stepDegrees;
		if(hue > 1) hue -= 1;
	}

	NSArray *array = [NSArray arrayWithArray:colors];
	return array;
}

+ (NSArray *) RGBFlameArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(int)alignment;
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway;
	if(alignment == 0)
		midway = numberOfColors / 2;
	else
		midway = numberOfColors;

	hueStepDegrees = hueStepDegrees / 360.0;
	brightnessStepDegrees = brightnessStepDegrees / 100.0;
   saturationStepDegrees = saturationStepDegrees / 100.0;

	if (alignment == 1)
		hue -= (hueStepDegrees * ((float) numberOfColors - 1.0));
	else if (alignment == 0)
		hue -= (hueStepDegrees * (float) midway);

	if (hue < 0) hue += 1;
	else if (hue > 1) hue -= 1;

	if (alignment == 1) {
		brightness -= (brightnessStepDegrees * (float) numberOfColors);
      saturation -= (saturationStepDegrees * (float) numberOfColors);
   }
	else if (alignment == 0) {
		brightness -= (brightnessStepDegrees * (float) midway);
      saturation -= (saturationStepDegrees * (float) midway);
   }

	if (brightness < 0) brightness = 0;
	else if (brightness > 1) brightness = 1;

   if (saturation < 0) saturation = 0;
   else if (saturation > 1) saturation = 1;
	
	int iterations;
	NSMutableArray * colors = [[NSMutableArray alloc] init];

	for(iterations=0;iterations<numberOfColors;iterations++){
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];

		hue += hueStepDegrees;
		if(hue > 1) hue -= 1;

		if (alignment == -1 || (alignment == 0 && iterations >= midway)) {
			brightness -= brightnessStepDegrees;
         saturation -= saturationStepDegrees;
      }
		else if (alignment == 1 || (alignment == 0 && iterations < midway)) {
			brightness += brightnessStepDegrees;
         saturation += saturationStepDegrees;
      }

		if (brightness < 0) brightness = 0;
		else if (brightness > 1) brightness = 1;

      if (saturation < 0) saturation = 0;
      else if (saturation > 1) saturation = 1;

	}

	NSArray *array = [NSArray arrayWithArray:colors];

	return array;
}

+ (NSArray *) NewtonFlameArray: (UIColor *)rootColor numberOfColorsInt:(int)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(int)alignment
{
	CGFloat hue, saturation, brightness, alpha;
	[rootColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	int midway;
	if(alignment == 0)
		midway = numberOfColors / 2;
	else
		midway = numberOfColors;

	hueStepDegrees = hueStepDegrees / 360.0;
	brightnessStepDegrees = brightnessStepDegrees / 100.0;
   saturationStepDegrees = saturationStepDegrees / 100.0;

	hue = [self RGBHueToNewtonHue:hue];
	if (alignment == 1)
		hue -= (hueStepDegrees * ((float) numberOfColors - 1.0));
	else if (alignment == 0)
		hue -= (hueStepDegrees * (float) midway);

	if (hue < 0) hue += 1;
	else if (hue > 1) hue -= 1;

	if (alignment == 1) {
		brightness -= (brightnessStepDegrees * (float) numberOfColors);
      saturation -= (saturationStepDegrees * (float) numberOfColors);
   }
	else if (alignment == 0) {
		brightness -= (brightnessStepDegrees * (float) midway);
      saturation -= (saturationStepDegrees * (float) midway);
   }

	if (brightness < 0) brightness = 0;
	else if (brightness > 1) brightness = 1;

   if (saturation < 0) saturation = 0;
   else if (saturation > 1) saturation = 1;
	
	int iterations;
	NSMutableArray * colors = [[NSMutableArray alloc] init];

	for(iterations=0;iterations<numberOfColors;iterations++){
		hue = [self NewtonHueToRGBHue:hue];
		[colors addObject:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue = [self RGBHueToNewtonHue:hue];

		hue += hueStepDegrees;
		if(hue > 1) hue -= 1;

		if (alignment == -1 || (alignment == 0 && iterations >= midway)) {
			brightness -= brightnessStepDegrees;
         saturation -= saturationStepDegrees;
      }
		else if (alignment == 1 || (alignment == 0 && iterations < midway)) {
			brightness += brightnessStepDegrees;
         saturation += saturationStepDegrees;
      }

		if (brightness < 0) brightness = 0;
		else if (brightness > 1) brightness = 1;

      if (saturation < 0) saturation = 0;
      else if (saturation > 1) saturation = 1;

	}

	NSArray *array = [NSArray arrayWithArray:colors];

	return array;
}

@end
