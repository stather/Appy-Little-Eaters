//
//  MyPageControl.m
//  cfx
//
//  Created by Ashish Sharma on 19/10/12.
//
//

#import "MyPageControl.h"

@implementation MyPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _bgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bgImage setImage:[[UIImage imageNamed:@"paging_bg"] stretchableImageWithLeftCapWidth:5.0f topCapHeight:5.0f]];
        [self addSubview:_bgImage];
        
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.pageControl setFrame:CGRectMake(20,(self.frame.size.height-20)/2,self.frame.size.width-40,20)];

    NSDictionary *dic = [self.pageControl startPointandTotalWidth];
    
    NSLog(@"number of pages = %d",self.pageControl.numberOfPages);
    NSLog(@"x = %@",[dic objectForKey:@"width"]);
    
    float x = [[dic objectForKey:@"x"] floatValue]+15.0f;
    float width = [[dic objectForKey:@"width"] floatValue]+10.0f;
    
    [self.bgImage setFrame:CGRectMake(x, 1.0f, width, 17.0f)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
