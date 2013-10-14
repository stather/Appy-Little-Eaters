//
//  JJGActionSheet.m
//  customeActionSheet
//
//  Created by Sumit on 08/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "JJGActionSheet.h"

@interface JJGActionSheet ()

@property (nonatomic, strong) UIView *blackOutView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setupButtons;
- (void)setupBackground;
- (UIView *)buildBlackOutViewWithFrame:(CGRect)frame;

- (UIButton *)buildButtonWithTitle:(NSString *)title;
- (UIButton *)buildCancelButtonWithTitle:(NSString *)title;
- (UIButton *)buildPrimaryButtonWithTitle:(NSString *)title;
- (UIButton *)buildDestroyButtonWithTitle:(NSString *)title;

- (CGFloat)calculateSheetHeight;

- (void)buttonWasPressed:(id)button;

@end


const CGFloat kButtonPadding = 10;
const CGFloat kButtonHeight = 47;

const CGFloat kPortraitButtonWidth = 300;
const CGFloat kLandscapeButtonWidth = 450;

const CGFloat kActionSheetAnimationTime = 0.2;
const CGFloat kBlackoutViewFadeInOpacity = 0.6;


@implementation JJGActionSheet

@synthesize delegate;
@synthesize callbackBlock;

@synthesize buttons;
@synthesize blackOutView;

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.buttons = [NSMutableArray array];
        self.opaque = YES;
    }
    
    return self;
}

- (id)initWithDelegate:(NSObject<JJGActionSheetDelegate> *)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithCancelButtonTitle:cancelButtonTitle primaryButtonTitle:primaryButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    if (self) {
        self.delegate = aDelegate;
    }
    
    return self;
}

- (id)initWithCancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self init];
    if (self) {
        
        // Build normal buttons
        va_list argumentList;
        va_start(argumentList, otherButtonTitles);
        
        NSString *argString = otherButtonTitles;
        while (argString != nil) {
            
            UIButton *button = [self buildButtonWithTitle:argString];
            [self.buttons addObject:button];
            
            argString = va_arg(argumentList, NSString *);
        }
        
        va_end(argumentList);
        
        // Build cancel button
        UIButton *cancelButton = [self buildCancelButtonWithTitle:cancelButtonTitle];
        [self.buttons insertObject:cancelButton atIndex:0];
        
        // Add primary button
        if (primaryButtonTitle) {
            UIButton *primaryButton = [self buildPrimaryButtonWithTitle:primaryButtonTitle];
            [self.buttons addObject:primaryButton];
        }
        
        // Add destroy button
        if (destructiveButtonTitle) {
            UIButton *destroyButton = [self buildDestroyButtonWithTitle:destructiveButtonTitle];
            [self.buttons insertObject:destroyButton atIndex:1];
        }
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithTitle:title delegate:nil cancelButtonTitle:cancelButtonTitle primaryButtonTitle:primaryButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
    return self;
}

- (id)initWithTitle:(NSString *)title delegate:(NSObject <JJGActionSheetDelegate> *)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithCancelButtonTitle:cancelButtonTitle primaryButtonTitle:primaryButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles, nil];
    
	if ([title length]) {
		_titleLabel = [self buildTitleLabelWithTitle:title];
	}
	if (aDelegate) {
		self.delegate = aDelegate;
	}
    
    return self;
}

#pragma mark - View setup

- (void)layoutSubviews {
    
    [self setupBackground];
    [self setupTitle];
    [self setupButtons];
}

- (void)setupBackground {
        
    UIImageView *background = [[UIImageView alloc] initWithImage:[ UIImage imageNamed:@"pickerBg"]];
    background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self insertSubview:background atIndex:0];
}

- (void)setupButtons {
    
    CGFloat yOffset = self.frame.size.height - kButtonPadding - floorf(kButtonHeight/2);
    
    BOOL cancelButton = YES;
    for (UIButton *button in self.buttons) {
        
        CGFloat buttonWidth;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            buttonWidth = kLandscapeButtonWidth;
        }
        else {
            buttonWidth = kPortraitButtonWidth;
        }
        
        button.frame = CGRectMake(0, 0, buttonWidth, kButtonHeight);
        button.center = CGPointMake(self.center.x, yOffset);
        [self addSubview:button];
        
        yOffset -= button.frame.size.height + kButtonPadding;
        
        // We draw a line above the cancel button so add an extra kButtonPadding
        if (cancelButton) {
            yOffset -= kButtonPadding;
            cancelButton = NO;
        }
    }
}

- (void)setupTitle {
    
    CGFloat labelWidth;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        labelWidth = kLandscapeButtonWidth;
    }
    else {
        labelWidth = kPortraitButtonWidth;
    }
    
    self.titleLabel.frame = CGRectMake((self.bounds.size.width - labelWidth) / 2, self.titleLabel.frame.origin.y, labelWidth, self.titleLabel.bounds.size.height);
    
    [self addSubview:self.titleLabel];
}

#pragma mark - Blackout view builder

- (UIView *)buildBlackOutViewWithFrame:(CGRect)frame {
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor blackColor];
    view.opaque = YES;
    view.alpha = 0;
    
    return view;
}

#pragma mark - Button builders

- (UILabel *)buildTitleLabelWithTitle:(NSString *)title {
    
    CGSize newSize = [title sizeWithFont:[UIFont systemFontOfSize:13.0]
                       constrainedToSize:CGSizeMake(300.0, NSIntegerMax)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 9.0, kPortraitButtonWidth, newSize.height + 5.0)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.numberOfLines = 0;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0.0, -1.0);
    
    return label;
}

- (UIButton *)buildButtonWithTitle:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.accessibilityLabel = title;
    button.opaque = YES;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"ActionSheettweetBtn"] ;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UIImage *touchBackgroundImage = [UIImage imageNamed:@"ActionSheettweetBtnSelected"] ;
    [button setBackgroundImage:touchBackgroundImage forState:UIControlStateHighlighted];
        
    return button;
}

- (UIButton *)buildCancelButtonWithTitle:(NSString *)title {
    
    UIButton *button = [self buildButtonWithTitle:title];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"ActionSheetcancelBtn"] ;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UIImage *touchBackgroundImage = [UIImage imageNamed:@"ActionSheetcancelBtnHover"] ;
    [button setBackgroundImage:touchBackgroundImage forState:UIControlStateHighlighted];
    
    return button;
}

- (UIButton *)buildPrimaryButtonWithTitle:(NSString *)title {
    
    UIButton *button = [self buildButtonWithTitle:title];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"ActionSheetemailShareBtn"] ;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UIImage *touchBackgroundImage = [UIImage imageNamed:@"ActionSheetemailShareBtnSelected"] ;
    [button setBackgroundImage:touchBackgroundImage forState:UIControlStateHighlighted];
    
    return button;
}

- (UIButton *)buildDestroyButtonWithTitle:(NSString *)title {
    
    UIButton *button = [self buildButtonWithTitle:title];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"ActionSheetpostFbBtn"] ;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UIImage *touchBackgroundImage = [UIImage imageNamed:@"ActionSheetpostFbBtnSelected"] ;
    [button setBackgroundImage:touchBackgroundImage forState:UIControlStateHighlighted];
    
    button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    button.titleLabel.layer.shadowOffset = CGSizeMake(0.0, -1.0);
    
    return button;
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    return [[[self.buttons objectAtIndex:buttonIndex] titleLabel] text];
}

#pragma mark - Button actions

- (void)buttonWasPressed:(id)button {
    NSInteger buttonIndex = [self.buttons indexOfObject:button];
    
    if (self.callbackBlock) {
        self.callbackBlock(JJGActionSheetCallbackTypeClickedButtonAtIndex, buttonIndex, [[[self.buttons objectAtIndex:buttonIndex] titleLabel] text]);
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
            [self.delegate actionSheet:self clickedButtonAtIndex:buttonIndex];
        }
    }
    
    [self hideActionSheetWithButtonIndex:buttonIndex];
}

- (void)hideActionSheetWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex >= 0) {
        if (self.callbackBlock) {
            self.callbackBlock(JJGActionSheetCallbackTypeWillDismissWithButtonIndex, buttonIndex, [[[self.buttons objectAtIndex:buttonIndex] titleLabel] text]);
        }
        else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:willDismissWithButtonIndex:)]) {
                [self.delegate actionSheet:self willDismissWithButtonIndex:buttonIndex];
            }
        }
    }
    [UIView animateWithDuration:kActionSheetAnimationTime animations:^{
        CGFloat endPosition = self.frame.origin.y + self.frame.size.height;
        self.frame = CGRectMake(self.frame.origin.x, endPosition, self.frame.size.width, self.frame.size.height);
        self.blackOutView.alpha = 0;
    } completion:^(BOOL finished) {
        if (buttonIndex >= 0) {
            if (self.callbackBlock) {
                self.callbackBlock(JJGActionSheetCallbackTypeDidDismissWithButtonIndex, buttonIndex, [[[self.buttons objectAtIndex:buttonIndex] titleLabel] text]);
            }
            else {
                if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:didDismissWithButtonIndex:)]) {
                    [self.delegate actionSheet:self didDismissWithButtonIndex:buttonIndex];
                }
            }
        }
        [self removeFromSuperview];
    }];
}

-(void)cancelActionSheet {
    [self hideActionSheetWithButtonIndex:-1];
}

#pragma mark - Present action sheet

- (void)showFrom:(UIView *)view {
    
    CGFloat startPosition = view.bounds.origin.y + view.bounds.size.height;
    self.frame = CGRectMake(0, startPosition, view.bounds.size.width, [self calculateSheetHeight]);
    [view addSubview:self];
    
    self.blackOutView = [self buildBlackOutViewWithFrame:view.bounds];
    [view insertSubview:self.blackOutView belowSubview:self];
    
    if (self.callbackBlock) {
        self.callbackBlock(JJGActionSheetCallbackTypeWillPresentActionSheet, -1, nil);
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willPresentActionSheet:)]) {
            [self.delegate willPresentActionSheet:self];
        }
    }
    
    [UIView animateWithDuration:kActionSheetAnimationTime
                     animations:^{
                         CGFloat endPosition = startPosition - self.frame.size.height;
                         self.frame = CGRectMake(self.frame.origin.x, endPosition, self.frame.size.width, self.frame.size.height);
                         self.blackOutView.alpha = kBlackoutViewFadeInOpacity;
                     }
                     completion:^(BOOL finished) {
                         if (self.callbackBlock) {
                             self.callbackBlock(JJGActionSheetCallbackTypeDidPresentActionSheet, -1, nil);
                         }
                         else {
                             if (self.delegate && [self.delegate respondsToSelector:@selector(didPresentActionSheet:)]) {
                                 [self.delegate didPresentActionSheet:self];
                             }
                         }
                     }];
}

#pragma mark - Helpers

- (CGFloat)calculateSheetHeight {
    return floorf((kButtonHeight * self.buttons.count) + (self.buttons.count * kButtonPadding) + kButtonHeight/2) + self.titleLabel.bounds.size.height + 4;
}
@end
