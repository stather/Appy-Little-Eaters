//
//  CHomeViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 09/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CHomeViewController.h"
#import "CHelloScene.h"

@interface CHomeViewController ()

@end

@implementation CHomeViewController



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
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.iconTray layoutSubviews];
}

- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue
{
	//[segue perform];
}
- (IBAction)unwindToHomeView:(UIStoryboardSegue *)segue
{
	//[segue perform];
}

@end
