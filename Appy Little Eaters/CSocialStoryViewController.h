//
//  CSocialStoryViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 10/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSocialStoryViewController : UIViewController{
	int currentPage;
	
}
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *theStory;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
- (IBAction)previousPage:(id)sender;
- (IBAction)nextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *storyImage;


@property (nonatomic,retain) AVAudioPlayer *player;

@end
