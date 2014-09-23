//
//  CForestViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 19/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CForestViewController.h"
#import "CForestScene.h"

@interface CForestViewController ()
@property SKView* spriteView;
@property CGPoint startAnchor;
@end

@implementation CForestViewController

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
	self.spriteView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.mainView.frame.size.width, self.mainView.frame.size.height)];
	[self.mainView addSubview:self.spriteView];

	CForestScene * forest = [[CForestScene alloc] initWithSize:self.spriteView.frame.size];
	[self.spriteView presentScene:forest];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myAction:(id)sender {
	UIPanGestureRecognizer * g = sender;
	if (g.state == UIGestureRecognizerStateBegan) {
		self.startAnchor = self.spriteView.scene.anchorPoint;
	}
	CGPoint p = [g translationInView:self.mainView];
	float offset = p.x / self.spriteView.frame.size.width;
	
	CGPoint anchor = self.startAnchor;
	anchor.x += offset;
	float anchorLimit = 1.43;
	if (anchor.x < -anchorLimit){
		anchor.x = -anchorLimit;
	}
	if (anchor.x > anchorLimit){
		anchor.x = anchorLimit;
	}
	self.spriteView.scene.anchorPoint = anchor;
	//NSLog(@"%f,%f", anchor.x, anchor.y);
}
@end
