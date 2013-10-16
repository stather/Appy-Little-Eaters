  //
//  MyCardsTableCell.m
//  Caxtonfx
//
//  Created by XYZ on 17/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "MyCardsTableCell.h"
#import "TopUpRechargeVC.h"
#import "MyCardVC.h"

@implementation MyCardsTableCell

@synthesize errorImgView,succesImgView,bgImgView,flagImgView,accountTypeLable,accountNameLable,blnceLable,currentBlnceLable,topupBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accountNameLable.textColor = UIColorFromRedGreenBlue(102, 102, 102);
        [self.accountNameLable setFont:[UIFont fontWithName:@"OpenSans" size:19]];
        
        [self.accountTypeLable setFont:[UIFont fontWithName:@"OpenSans" size:10]];
         self.accountNameLable.textColor = UIColorFromRedGreenBlue(204, 204, 204);
        
        [self.currentBlnceLable setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        self.currentBlnceLable.textColor = UIColorFromRedGreenBlue(39, 39, 39);
        
        [self.blnceLable setFont:[UIFont fontWithName:@"OpenSans" size:25]];
        self.blnceLable.textColor = UIColorFromRedGreenBlue(39, 39, 39);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(IBAction)topupBtnPressed:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    UITabBarController *tabbarcontroller = appDelegate.tabBarController;
    UINavigationController *navController = (UINavigationController*)[tabbarcontroller selectedViewController];
    NSArray *controllerArray = navController.viewControllers;
    for(int i=0;i<controllerArray.count;i++)
    {
        if([[controllerArray objectAtIndex:i]isKindOfClass:[MyCardVC class]])
        {
            if([self.superview isKindOfClass:[UITableView class]]){
                NSIndexPath *myIndexPath = [(UITableView *) self.superview indexPathForCell: self];
                [[controllerArray objectAtIndex:i] topupBtnPressed:myIndexPath];
                break;
            }else if([self.superview.superview isKindOfClass:[UITableView class]]){
                NSIndexPath *myIndexPath = [(UITableView *) self.superview.superview indexPathForCell: self];
                [[controllerArray objectAtIndex:i] topupBtnPressed:myIndexPath];
                break;
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry this is not avaliable now.\n Try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            
        }
    }
}

@end
