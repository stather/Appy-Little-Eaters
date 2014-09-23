//
//  CHelloScene.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 14/02/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CHelloScene.h"
#import "CSpaceshipScene.h"

@interface CHelloScene ()
@property BOOL contentCreated;
@end

@implementation CHelloScene

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
	
}
- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeResizeFill;
    [self addChild: [self newHelloNode]];
}

- (SKLabelNode *)newHelloNode
{
    SKLabelNode *helloNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    helloNode.text = @"Hello, World!";
    helloNode.fontSize = 42;
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
	helloNode.name = @"helloNode";
    return helloNode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	SKNode *helloNode = [self childNodeWithName:@"helloNode"];
    if (helloNode != nil)
    {
        helloNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [helloNode runAction: moveSequence completion:^{
			SKScene *spaceshipScene  = [[CSpaceshipScene alloc] initWithSize:self.size];
			SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
			[self.view presentScene:spaceshipScene transition:doors];
		}];
    }
}
@end
