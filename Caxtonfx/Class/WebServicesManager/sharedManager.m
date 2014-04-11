//
//  sharedManager.m
//  Caxtonfx
//
//  Created by Nishant on 15/05/13.
//  Copyright (c) 2013 kipl. All rights reserved.
//

#import "sharedManager.h"
#import "User.h"
#import "NSString+HTML.h"

@implementation sharedManager
@synthesize mutableData;
@synthesize serviceName;
@synthesize delegate=_delegate;

#pragma mark Singleton Method

+ (sharedManager *)getSharedInstance
{
    static sharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Method For Handling Services -

-(void)callServiceWithRequest:(NSString *)requestString methodName:(NSString *)methodName andDelegate:(id<sharedDelegate>)delegateObject
{
    User *myUser = [User sharedInstance];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.delegate = delegateObject;
    NSString *urlString;
    if (myUser.devMode) {
        urlString = [NSString stringWithFormat:@"https://mobiledev.caxtonfx.com/Service.svc"];
    }
    else{
        urlString = [NSString stringWithFormat:@"https://mobileapi.caxtonfx.com/service.svc"];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    self.serviceName = methodName;
    NSMutableURLRequest *theRequest;
    if([self.serviceName isEqualToString:@"TopUp"])
    {
        theRequest = [NSMutableURLRequest
                      requestWithURL:url
                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    }else{
        
        theRequest = [NSMutableURLRequest
                      requestWithURL:url
                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:120];
    }
    NSString *msgLength = [NSString stringWithFormat:@"%d", [requestString length]];
    [theRequest addValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    if (myUser.devMode) {
        // TEST
        [theRequest addValue:@"mobiledev.caxtonfx.com" forHTTPHeaderField:@"Host"];
    }else{
        //Live
        [theRequest addValue:@"mobileapi.caxtonfx.com" forHTTPHeaderField:@"Host"];
    }
    
    [theRequest addValue:@"Apache-HttpClient/4.1.1 (java 1.5)" forHTTPHeaderField:@"User-Agent"];
    [theRequest addValue:[NSString  stringWithFormat:@"http://tempuri.org/IPhoenixTestService/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [theRequest setHTTPBody: [requestString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self startImmediately:YES];
    
    if(con)
    {
        mutableData = [[NSMutableData alloc] init];
    }
    while(!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegates

-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    [mutableData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [mutableData appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.delegate loadingFailedWithError:[error description] withServiceName:serviceName];
    
    mutableData = nil;
    
    finished = YES;
    
    return;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *xmlResponseString = [[NSString alloc] initWithBytes: [mutableData mutableBytes] length:[mutableData length] encoding:NSUTF8StringEncoding];
    if ([xmlResponseString rangeOfString:@"<s:Envelope"].location == NSNotFound) {
        [self.delegate loadingFailedWithError:[xmlResponseString stringByDecodingHTMLEntities] withServiceName:serviceName];
    } else {
        [self.delegate loadingFinishedWithResponse:[xmlResponseString stringByDecodingHTMLEntities] withServiceName:serviceName];
    }
    mutableData = nil;
    finished = YES;
}
@end
