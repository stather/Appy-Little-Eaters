//
//  CHomeViewController.h
//  Appy Little Eaters
//
//  Created by Russell Stather on 09/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "CHomeIconView.h"

@interface CHomeViewController : UIViewController 
@property (weak, nonatomic) IBOutlet CHomeIconView *iconTray;
- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue;
- (IBAction)unwindToHomeView:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet SKView *spriteView;

@property (nonatomic,retain) AVAudioPlayer *player;
@property (nonatomic,retain) AVAudioPlayer *ukeplayer;

@end
