//
//  CFoodPageViewController.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 10/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CFoodPageViewController.h"
#import "CFoodCell.h"

@interface CFoodPageViewController ()

@end

@implementation CFoodPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self){
	}
	return self;
}

- (void)viewDidLoad
{
	self.selectedFoodImage.hidden = true;

    [super viewDidLoad];
	self.theCollection.backgroundColor = [UIColor clearColor];
	self.theCollection.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	
	NSLayoutConstraint *lc = [NSLayoutConstraint constraintWithItem:self.theCollection attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.333 constant:0];
	[self.view addConstraint:lc];
	
	UIColor * c;
	NSString *filepath;
	switch (self.index){
		case 0:
			filepath = [[NSBundle mainBundle] pathForResource:@"red-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"apple", @"cherry", @"raspberry", @"redpepper", @"strawberry", @"tomato", @"watermelon",  nil];
			break;
		case 1:
			filepath = [[NSBundle mainBundle] pathForResource:@"orange-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"apricots", @"carrot", @"mango", @"orange", @"pawpaw", @"peach", @"pumpkin",  nil];
			break;
		case 2:
			filepath = [[NSBundle mainBundle] pathForResource:@"yellow-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"banana", @"corn", @"lemon", @"pear", @"pineapple", @"yellowapple", @"yellowpepper",  nil];
			break;
		case 3:
			filepath = [[NSBundle mainBundle] pathForResource:@"green-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"broccoli", @"cucumber", @"greenapple", @"greengrapes", @"lime", @"peas", @"sprouts",  nil];
			break;
		case 4:
			filepath = [[NSBundle mainBundle] pathForResource:@"purple-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"blackberry", @"eggplant", @"grapes", @"olives", @"plum", @"raisins", @"rebcabbage",  nil];
			break;
		case 5:
			filepath = [[NSBundle mainBundle] pathForResource:@"white-background" ofType:@"jpg"];
			foods = [[NSArray alloc] initWithObjects:@"cauliflower", @"chicken", @"dates", @"lentils", @"nuts", @"potato", @"whitecabbage",  nil];
			break;
	}
	self.backgroundImage.image = [[UIImage alloc] initWithContentsOfFile:filepath];
	//self.mainView.backgroundColor = c;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    //NSString *searchTerm = self.searches[section];
    //return [self.searchResults[searchTerm] count];
	return [foods count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CFoodCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FoodCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
	int index = [indexPath item];
	NSString * name = [foods objectAtIndex:index];
	NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
	cell.foodImage.image = image;
	cell.foodImage.backgroundColor = [UIColor clearColor];
	cell.backgroundColor = [UIColor clearColor];
	cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
	NSInteger index = [indexPath item];
	NSString * name = [foods objectAtIndex:index];
	NSString *filepath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:filepath];
	self.selectedFoodImage.image = image;
	self.selectedFoodImage.hidden = false;
	self.didYouEatText.hidden = false;
	self.theCollection.hidden = true;
	self.tick.hidden = NO;
	self.cross.hidden = NO;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *searchTerm = self.searches[indexPath.section]; FlickrPhoto *photo =
//    self.searchResults[searchTerm][indexPath.row];
    // 2
//    CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
//    retval.height += 35; retval.width += 35; return retval;
	float height = self.theCollection.bounds.size.height;
	return CGSizeMake(height, height);
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (IBAction)crossClicked:(id)sender {
	self.selectedFoodImage.hidden = YES;
	self.didYouEatText.hidden = YES;
	self.theCollection.hidden = NO;
	self.tick.hidden = YES;
	self.cross.hidden = YES;
	
}
@end
