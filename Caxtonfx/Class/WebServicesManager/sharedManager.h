//
//  sharedManager.h
//  Caxtonfx
//
//  Created by Nishant on 15/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import <Foundation/Foundation.h>


// Declaring Protocol
@protocol sharedDelegate <NSObject>

@required
// Method that will be called when loading will be finished
-(void)loadingFinishedWithResponse:(NSString *)response withServiceName:(NSString *)service;

@optional
// Method that will be called when loading failed due to some error
-(void)loadingFailedWithError:(NSString *)error withServiceName:(NSString *)service;

@end


@interface sharedManager : NSObject<sharedDelegate>
{
    id<sharedDelegate> delegate;
    bool finished;
}

// Properties
@property (nonatomic , assign)  id<sharedDelegate> delegate;
@property (nonatomic , strong) NSMutableData *mutableData;
@property (nonatomic , strong) NSString *serviceName;

// Methods
+ (sharedManager *)getSharedInstance;
-(void)callServiceWithRequest:(NSString *)requestString methodName:(NSString *)methodName andDelegate:(id<sharedDelegate>)delegateObject;

@end
