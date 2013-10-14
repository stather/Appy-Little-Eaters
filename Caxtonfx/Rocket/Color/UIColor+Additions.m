#import "UIColor+Additions.h"
#import "CattailArtNSColor.h"

@implementation UIColor (UIColorAdditions)

+ (UIColor *)withRGB:(int)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 
                           alpha:1.0];
}

+ (UIColor *) complementryColorForColor:(UIColor *) color
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    NSLog(@"hue = %f saturation = %f brightness = %f alpha = %f",hue,saturation,brightness,alpha);
    
    color = [CattailArtNSColor NewtonComplement:color];
    
    if (brightness < 0.5f)
        brightness = 0.5f;
    
    saturation = 1.0f;
    
    hue = 1.0f - hue;
    
    color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    
    return color;
}
@end
