//
//  ForgottenPinView.m
//  Caxtonfx
//
//  Created by Catalin Demian on 07/08/14.
//  Copyright (c) 2014 kipl. All rights reserved.
//

#import "ForgottenPinView.h"

@implementation ForgottenPinView

- (id)init{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self) {
    }
    return self;
}

- (void)forgottenPinAction:(id)sender {
    NSLog(@"Forgotten Pin Action");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"If you have forgotten your 4-digit card PIN, please click OK to call 0044 207 281 0712 and select the 'PIN advice option'" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:@"00442072810712"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
        alertView.delegate = nil;
    }
}

@end
