//
//  CustomTextField.m
//  OnePulse
//
//  Created by Amit on 10/04/13.
//  Copyright (c) 2013 RawDuck. All rights reserved.
//
#import "UIButton+CustomDesign.h"

@implementation UIButton (CustomDesign)
- (void)validButton
{
    [self setImage:[UIImage imageNamed:@"emailTextBox"] forState:UIControlStateNormal];
}
//- (void)btnWithActivityIndicator
//{
//    UIActivityIndicatorView*loadingIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    loadingIndicator.frame=CGRectMake(240,10, 30, 30);
//    [self addSubview:loadingIndicator];
//    [loadingIndicator startAnimating];
//}
-(void)btnWithoutActivityIndicator
{
    for (int i=0; i<[[self subviews] count]; i++)
    {
        if ([[[self subviews] objectAtIndex:i] isKindOfClass:[UIActivityIndicatorView class]])
        {
            [[[self subviews] objectAtIndex:i] removeFromSuperview];
        }
    }
}
-(void)btnWithCrossImage
{
    NSLog(@"Y origin Is %f",self.frame.origin.y);
//    if (self.tag==1001)
//    {
//        UIImageView *crossImg=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.width-50, self.frame.size.height/2-8, 16, 16)];
//        [crossImg setImage:[UIImage imageNamed:@"cross"]];
//        [self addSubview:crossImg];
//        [crossImg bringSubviewToFront:self];
//    }
//    else
//    {
        UIImageView *crossImg=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-28, (self.frame.size.height-16)/2, 16, 16)];
        [crossImg setImage:[UIImage imageNamed:@"cross"]];
        [self addSubview:crossImg];
        [crossImg bringSubviewToFront:self];
//    }
}
-(void)btnWithOutCrossImage
{
    NSLog(@"%@",[self subviews]);
   for (UIView *subview in [self subviews])
   {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            if ([(UIImageView*)subview image]==[UIImage imageNamed:@"cross"])
            {
                [subview removeFromSuperview];
            }
        }
    }
}
-(void)btnWithCheckImage
{
    UIImageView *crossImg=[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.width-40,  (self.frame.size.height-16)/2, 16, 16)];
    [crossImg setImage:[UIImage imageNamed:@"checkMarkIcon"]];
    [self addSubview:crossImg];
    [crossImg bringSubviewToFront:self];
}
-(void)btnWithOutCheckImage
{
    NSLog(@"%@",[self subviews]);
    for (UIView *subview in [self subviews])
    {
        if ([subview isKindOfClass:[UIImageView class]])
        {
            if ([(UIImageView*)subview image]==[UIImage imageNamed:@"checkMarkIcon"])
            {
                [subview removeFromSuperview];
                
            }
        }
    }
}

- (void)btnWithActivityIndicator
{
    //CGRectMake(self.frame.size.width-20, (self.frame.size.height-16)/2, 19, 16)
    UIActivityIndicatorView*loadingIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingIndicator.frame=CGRectMake(self.frame.size.width-40,(self.frame.size.height-30)/2, 30, 30);
    [self addSubview:loadingIndicator];
    loadingIndicator.tag = -1;
    [loadingIndicator startAnimating];
}
- (void)disableSendButton
{
    [[self viewWithTag:-1] removeFromSuperview];
}
- (void)enableButtonWithLoading
{
}
- (void)enableButtonWithGrayBGImg
{
}
-(void)errorSendButtonImage
{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
    UIImageView *wrongImgView = [[UIImageView alloc]init ];//WithFrame:(self.frame.size.width-40,(self.frame.size.height-16)/2, 15, 15)];    //CGRectMake(242, 19, 16, 16)];//CGRectMake(self.frame.size.width-40,(self.frame.size.height-30)/2, 30, 30);
    wrongImgView.frame = CGRectMake(self.frame.size.width-30,(self.frame.size.height-16)/2, 15, 15);

    [wrongImgView setImage:[UIImage imageNamed:@"cross"]];
    [self addSubview:wrongImgView];
    wrongImgView.tag = -2;
}

- (void)btnSuccess
{
    [[self viewWithTag:-1] removeFromSuperview];
    [[self viewWithTag:-2] removeFromSuperview];
    UIImageView *correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-30,(self.frame.size.height-16)/2, 19, 16)];
    [correctImgView setImage:[UIImage imageNamed:@"checkMarkIcon"]];
    [self addSubview:correctImgView];
    
    correctImgView.tag = -2;
}

- (void)signUpBtnWithActivityIndicator
{
    UIActivityIndicatorView*loadingIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingIndicator.frame=CGRectMake(240,12, 30, 30);
    [self addSubview:loadingIndicator];
    loadingIndicator.tag = -1;
    [loadingIndicator startAnimating];
}

- (void)removeIndicator
{
    [[self viewWithTag:-1] removeFromSuperview];
}
@end
