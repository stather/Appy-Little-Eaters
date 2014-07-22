//
//  JJGActionSheet.h
//  customeActionSheet
//
//  Created by Sumit on 08/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class JJGActionSheet;
@protocol JJGActionSheetDelegate;

typedef enum JJGActionSheetResult {
    JJGActionSheetButtonResultSelected,
    JJGActionSheetResultResultCancelled
} JJGActionSheetResult;

typedef enum JJGActionSheetCallbackType {
    JJGActionSheetCallbackTypeClickedButtonAtIndex,
    JJGActionSheetCallbackTypeDidDismissWithButtonIndex,
    JJGActionSheetCallbackTypeWillDismissWithButtonIndex,
    JJGActionSheetCallbackTypeWillPresentActionSheet,
    JJGActionSheetCallbackTypeDidPresentActionSheet
} JJGActionSheetCallbackType;


typedef void(^JJGCallbackBlock)(JJGActionSheetResult result, NSInteger buttonIndex) __attribute__((deprecated));
typedef void(^JJGActionSheetCallbackBlock)(JJGActionSheetCallbackType result, NSInteger buttonIndex, NSString *buttonTitle);

@interface JJGActionSheet : UIView

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, unsafe_unretained) NSObject <JJGActionSheetDelegate> *delegate;
@property (nonatomic, copy) JJGActionSheetCallbackBlock callbackBlock;

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (id)initWithDelegate:(NSObject <JJGActionSheetDelegate> *)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... __attribute__ ((deprecated));

- (id)initWithCancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (id)initWithTitle:(NSString *)title delegate:(NSObject <JJGActionSheetDelegate> *)aDelegate cancelButtonTitle:(NSString *)cancelButtonTitle primaryButtonTitle:(NSString *)primaryButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)showFrom:(UIView *)view;

- (void)cancelActionSheet;

@end

@protocol JJGActionSheetDelegate
@optional
- (void)willPresentActionSheet:(JJGActionSheet *)actionSheet;  // before animation and showing view
- (void)didPresentActionSheet:(JJGActionSheet *)actionSheet;  // after animation
- (void)actionSheet:(JJGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;  // when user taps a button
- (void)actionSheet:(JJGActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after hide animation
- (void)actionSheet:(JJGActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex;  // before hide animation
@end



