//
//  CMocrCharacter.h
//  OCRDemo
//
//  Created by Nishant on 2/12/13.
//
//

#import <Foundation/Foundation.h>

@interface CMocrCharacter : NSObject
{
    
}

@property (nonatomic , assign) int unicode;
@property CGRect charRect;



// Returns YES if current character is bold.
//- (BOOL) isBold;


@end
