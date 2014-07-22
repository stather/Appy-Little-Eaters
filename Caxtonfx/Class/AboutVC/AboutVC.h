//
//  AboutVC.h
//  Caxtonfx
//
//  Created by Sumit on 04/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJGActionSheet.h"

@interface AboutVC : UIViewController<UIScrollViewDelegate,JJGActionSheetDelegate>

@property (nonatomic,strong) UIScrollView *scrollview;

@end
