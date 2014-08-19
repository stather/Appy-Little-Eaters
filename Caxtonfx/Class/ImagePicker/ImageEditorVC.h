//
//  ImageEditorVC.h
//  cfx
//
//  Created by Ashish on 07/09/12.
//
//

#import <UIKit/UIKit.h>
#import "BJImageCropper.h"

@interface ImageEditorVC : UIViewController
{
    UIImage *imageToEdited;
    
    BJImageCropper *imageCropper;
    
    CGRect croppedRect;
}

@property (nonatomic, strong) BJImageCropper *imageCropper;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *bottomBarView;
@property (nonatomic, strong) IBOutlet UIButton *doneBtn;

- (IBAction) libraryBtnTap:(id)sender;
- (IBAction) cameraBtnTap:(id)sender;
//- (IBAction) historyBtnTap:(id)sender;
- (IBAction) doneBtnTap:(id)sender;

- (id) initWithImage:(UIImage *) image;

@end
