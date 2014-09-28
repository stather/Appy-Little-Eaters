//
//  CSocialStoryViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 10/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CSocialStoryViewController.h"


@interface CSocialStoryViewController ()

@end

@implementation CSocialStoryViewController

@synthesize player;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		currentPage = 1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self){
		currentPage = 1;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	//[self setup];
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"goodfoodmakes2" ofType:@"m4a"];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
	[player play];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)previousPage:(id)sender {
	currentPage--;
	if (currentPage == 0){
		currentPage = 5;
	}
	[self setup];
}

- (IBAction)nextPage:(id)sender {
	currentPage++;
	if (currentPage == 6){
		currentPage = 1;
	}
	[self setup];
}
/*
[player stop];
NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"goodfoodmakes2" ofType:@"m4a"];
NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
[player play];
*/
- (void) setup
{
	switch (currentPage) {
		case 1:
			break;
		case 2:
		{
			self.storyImage.image = [UIImage imageNamed:@"social-story2.png"];
			NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"healthykids2" ofType:@"m4a"];
			NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
			player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
			[player play];
		}
			break;
		case 3:
			break;
		case 4:
			break;
		case 5:
			break;
			
		default:
			break;
	}
	CATransition *transition = [CATransition animation];
	transition.duration = 1.0f;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	
	[self.storyImage.layer addAnimation:transition forKey:nil];
}

@end