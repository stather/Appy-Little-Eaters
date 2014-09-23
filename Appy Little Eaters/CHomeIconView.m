//
//  CHomeIconView.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 09/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CHomeIconView.h"

@implementation CHomeIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self){
		NSArray *cons = [self constraints];
		[self removeConstraints:cons];
		[self setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.superview setTranslatesAutoresizingMaskIntoConstraints:NO];
		UIView * a = [self viewWithTag:1];
		UIView * b = [self viewWithTag:2];
		UIView * c = [self viewWithTag:3];
		UIView * d = [self viewWithTag:4];
		UIView * e = [self viewWithTag:5];
		[a removeConstraints:[a constraints]];
		float scale = 1.0 / 5.0;
		
		NSLayoutConstraint * lc = [NSLayoutConstraint constraintWithItem:a attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		lc = [NSLayoutConstraint constraintWithItem:a attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		lc = [NSLayoutConstraint constraintWithItem:b attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		
		lc = [NSLayoutConstraint constraintWithItem:c attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		lc = [NSLayoutConstraint constraintWithItem:c attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		
		lc = [NSLayoutConstraint constraintWithItem:d attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		lc = [NSLayoutConstraint constraintWithItem:d attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];

		lc = [NSLayoutConstraint constraintWithItem:e attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		lc = [NSLayoutConstraint constraintWithItem:e attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		
		lc = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:scale constant:0];
		[self addConstraint:lc];
		
		
		
		
		NSDictionary *viewsDictionary =
		NSDictionaryOfVariableBindings(a, b, c, d, e);
		NSArray *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[a]-0-[b]-0-[c]-0-[d]-0-[e]-0-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[a]-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[b]-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[c]-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[d]-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"V:[e]-|"
												options:0 metrics:nil views:viewsDictionary];
		[self addConstraints:constraints];
		
	}
	return self;
}



@end
