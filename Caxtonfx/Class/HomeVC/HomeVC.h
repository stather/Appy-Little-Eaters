//
//  HomeVC.h
//  Caxtonfx
//
//  Created by Sumit on 08/04/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"

@interface HomeVC : UIViewController <UIScrollViewDelegate,sharedDelegate,NSXMLParserDelegate,PAPasscodeViewControllerDelegate>

@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *lodingView;
@property (nonatomic,strong) IBOutlet UILabel *updateInfo;
@property (nonatomic,strong) IBOutlet UILabel *mainLabel;
@property (nonatomic, strong) NSMutableArray *textArray;
@property (nonatomic, strong) NSString *currentElement;


-(IBAction)moreInfoBtnPressed:(id)sender;

-(IBAction)LoginBtnPressed:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
