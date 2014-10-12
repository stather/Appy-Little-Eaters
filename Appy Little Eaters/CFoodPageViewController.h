//
//  CFoodPageViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 10/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFoodPageViewController : UIViewController <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate>{
	NSArray * foods;
}

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UICollectionView *theCollection;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic) int index;
@property (weak, nonatomic) IBOutlet UITextField *foodColourText;
@property (weak, nonatomic) IBOutlet UIImageView *selectedFoodImage;
@property (weak, nonatomic) IBOutlet UITextView *didYouEatText;
@property (weak, nonatomic) IBOutlet UIButton *tick;
@property (weak, nonatomic) IBOutlet UIButton *cross;
- (IBAction)crossClicked:(id)sender;
- (IBAction)tickClicked:(id)sender;

@property (nonatomic,retain) AVAudioPlayer *player;


@end
