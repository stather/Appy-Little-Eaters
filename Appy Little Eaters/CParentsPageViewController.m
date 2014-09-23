//
//  CParentsPageViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 10/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CParentsPageViewController.h"

@interface CParentsPageViewController ()

@end

@implementation CParentsPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NSURL* filePath = [[NSBundle mainBundle] URLForResource:@"parentspage" withExtension:@"rtf"];
	NSAttributedString *attrString;
	NSError * err;
	attrString = [[NSAttributedString alloc]   initWithFileURL:filePath options:@{NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType} documentAttributes:nil error:&err];
	self.theText.attributedText = attrString;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
