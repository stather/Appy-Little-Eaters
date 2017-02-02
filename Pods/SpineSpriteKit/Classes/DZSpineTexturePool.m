//
//  DZSpineTexturePool.m
//  PZTool
//
//  Created by Simon Kim on 13. 10. 11..
//  Copyright (c) 2013 DZPub.com. All rights reserved.
//

#import "DZSpineTexturePool.h"
#import <SpriteKit/SpriteKit.h>

@interface DZSpineTexturePool()
@property (nonatomic, readonly) NSMutableArray *mnames;
@property (nonatomic, readonly) NSMutableDictionary *mapTextures;
@end

@implementation DZSpineTexturePool
@synthesize mapTextures = _mapTextures;
@synthesize mnames = _mnames;

- (NSMutableDictionary *) mapTextures
{
    if ( _mapTextures == nil ) {
        _mapTextures = [NSMutableDictionary dictionary];
    }
    return _mapTextures;
}

- (NSMutableArray *) mnames
{
    if ( _mnames == nil ) {
        _mnames = [NSMutableArray array];
    }
    return _mnames;
}

- (NSArray *) names
{
    return [self.mnames copy];
}

- (SKTexture *) textureAtlasWithName:(NSString *) name
{
    SKTexture *texture = self.mapTextures[name];
    if (texture == nil ) {
        //texture = [SKTexture textureWithImageNamed:name];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSString* bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSArray* possibleURLS = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
        NSURL* appSupportDir = possibleURLS[0];
        NSURL* dirPath = [appSupportDir URLByAppendingPathComponent:bundleId];
        NSURL* filename = [dirPath URLByAppendingPathComponent:name];
        NSString* filepath = [filename path];

        NSString* newpath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        UIImage* image = [UIImage imageWithContentsOfFile:newpath];
        texture = [SKTexture textureWithImage:image];
        if ( texture ) {
            self.mapTextures[name] = texture;
            [self.mnames addObject:name];
        }
    }

    return texture;
}

- (void) unloadTextAtlasWithName:(NSString *) name
{
    [self.mapTextures removeObjectForKey:name];
    [self.mnames removeObject:name];
}

- (void) unloadAll
{
    [self.mapTextures removeAllObjects];
    [self.mnames removeAllObjects];
}

+ (id) sharedPool
{
    static id pool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pool = [[[self class] alloc] init];
    });
    return pool;
}

@end
