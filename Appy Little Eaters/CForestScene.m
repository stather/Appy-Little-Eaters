//
//  CForestScene.m
//  Appy Little Eaters
//
//  Created by Russell Stather on 12/03/2014.
//  Copyright (c) 2014 Ready Steady Rainbow. All rights reserved.
//

#import "CForestScene.h"

@interface CForestScene()
@property BOOL contentCreated;
@property float scale;
@property BOOL birdOnRightTree;
@property BOOL birdOnLeftTree;
@property BOOL birdFlyingLeft;
@property BOOL birdFlyingRight;
@end

#define backgroundWidth	1855
#define backgroundHeight	320

//#define CGForestPoint(x,y)  CGPointMake((x-(backgroundWidth/2)), ((backgroundHeight/2)-y))



@implementation CForestScene

- (CGPoint) forestPoint:(CGPoint) p
{
	CGSize r = self.frame.size;
	float fact = r.height/backgroundHeight;
	int width = backgroundWidth*fact;
	int height = backgroundHeight*fact;
	return CGPointMake(p.x-(width/2), (height/2)-p.y);
}

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
    self.scaleMode = SKSceneScaleModeAspectFill;
	SKSpriteNode * forest = [self newForestNode];
    [self addChild: forest];
	
	SKSpriteNode * bird = [self newBirdSittingNode];
	[forest addChild: bird];
	
	self.birdOnLeftTree = NO;
	self.birdOnRightTree = YES;
	
	SKSpriteNode * dragon = [self newDragonNode];
	[forest addChild:dragon];
	
	SKSpriteNode * squirrel = [self newSquirrelNode];
	[forest addChild:squirrel];
	
	SKSpriteNode* deer = [self newDeerNode];
	[forest addChild:deer];
}

- (void) squirrelEatNut
{
	SKAction *wait = [SKAction waitForDuration: 0.1];
	SKAction * eat2 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel2"]];
	SKAction * eat3 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel3"]];
	SKAction * eat4 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel4"]];
	SKAction * eat5 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel5"]];
	SKAction * eat6 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel6"]];
	SKAction * eat7 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel7"]];
	SKAction * eat1 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"squirrel1"]];
	
	SKAction * eatSequence = [SKAction sequence:@[wait, eat2, wait, eat3, wait, eat4, wait, eat5, wait, eat6, wait, eat7, wait, eat6, wait, eat5, wait, eat4, wait, eat3, wait, eat2, wait, eat1]];
	SKAction * eating = [SKAction repeatAction:eatSequence count:3];
	SKNode *squirrel = [[self childNodeWithName:@"BACKGROUND"] childNodeWithName:@"SQUIRREL"];
	[squirrel runAction:eating];
}

- (void) deerEatGrass
{
	SKAction *wait = [SKAction waitForDuration: 0.1];
	SKAction * eat2 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer2"]];
	SKAction * eat3 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer3"]];
	SKAction * eat4 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer4"]];
	SKAction * eat5 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer5"]];
	SKAction * eat6 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer6"]];
	SKAction * eat7 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer7"]];
	SKAction * eat1 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"deer1"]];
	
	SKAction * eatSequence = [SKAction sequence:@[wait, eat2, wait, eat3, wait, eat4, wait, eat5, wait, eat6, wait, eat7, wait, eat6, wait, eat5, wait, eat4, wait, eat3, wait, eat2, wait, eat1]];
	SKAction * eating = [SKAction repeatAction:eatSequence count:3];
	SKNode *deer = [[self childNodeWithName:@"BACKGROUND"] childNodeWithName:@"DEER"];
	[deer runAction:eating];
}

- (void) dragonSmoke
{
	SKAction *wait = [SKAction waitForDuration: 0.25];
	SKAction * smoke2 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon2"]];
	SKAction * smoke3 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon3"]];
	SKAction * smoke4 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon4"]];
	SKAction * smoke5 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon5"]];
	SKAction * smoke6 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon6"]];
	SKAction * smoke7 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon2"]];
	SKAction * smoke8 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"dragon1"]];
	SKAction * smokeSequence = [SKAction sequence:@[wait, smoke2, wait, smoke3, wait, smoke4, wait, smoke5, wait, smoke6, wait, smoke7, wait, smoke8]];
	SKNode *dragon = [[self childNodeWithName:@"BACKGROUND"] childNodeWithName:@"DRAGON"];
	[dragon runAction:smokeSequence];
	
}

- (SKAction*) flappingBird
{
	SKAction *wait = [SKAction waitForDuration: 0.1];
	SKAction * flap1 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird1_03"]];
	SKAction * flap2 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird2_03"]];
	SKAction * flap3 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird3_03"]];
	SKAction * flap4 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird4_03"]];
	SKAction * flap5 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird5_03"]];
	SKAction * flap6 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird4_03"]];
	SKAction * flap7 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird3_03"]];
	SKAction * flap8 = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird2_03"]];
	SKAction * flappingSequence = [SKAction sequence:@[flap1, wait, flap2, wait, flap3, wait, flap4, wait, flap5, wait, flap6, wait, flap7, wait, flap8, wait]];
	SKAction * flapping = [SKAction repeatActionForever:flappingSequence];
	return flapping;
}

- (void) flyToLeftTree
{
	SKNode *bird = [[self childNodeWithName:@"BACKGROUND"] childNodeWithName:@"BIRD"];
	bird.xScale = 1;
	[bird removeAllActions];

	SKAction * flapping = [self flappingBird];
	
	CGPoint p = [self forestPoint:CGPointMake(383, 108)];
	
	SKAction * flyPath = [SKAction moveTo:p duration:5];
	
	SKAction * sitting = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird-sitting_03"]];
	SKAction * flight = [SKAction sequence:@[flyPath, sitting]];
	self.birdOnRightTree = NO;
	self.birdFlyingLeft = YES;
	self.birdFlyingRight = NO;
	[bird runAction:flapping withKey:@"flapping"];
	[bird runAction:flight completion:^{
		[bird removeActionForKey:@"flapping"];
		self.birdOnLeftTree = YES;
		self.birdFlyingLeft = NO;
	}];
}

- (void) stopFlying
{
	NSLog(@"flight end");
}

- (void) flyToRightTree
{
	SKNode *bird = [[self childNodeWithName:@"BACKGROUND"] childNodeWithName:@"BIRD"];
	[bird removeAllActions];
	bird.xScale = -1;

	SKAction * flapping = [self flappingBird];
	CGPoint p = [self forestPoint:CGPointMake(904, 65)];

	SKAction * flyPath = [SKAction moveTo:p duration:5];
	SKAction * sitting = [SKAction setTexture:[SKTexture textureWithImageNamed:@"bird-sitting_03"]];
	SKAction * flight = [SKAction sequence:@[flyPath, sitting]];
	self.birdOnLeftTree = NO;
	self.birdFlyingRight = YES;
	self.birdFlyingLeft = NO;
	[bird runAction:flapping withKey:@"flapping"];
	[bird runAction:flight completion:^{
		[bird removeActionForKey:@"flapping"];
		self.birdOnRightTree = YES;
		self.birdFlyingRight = NO;
	}];
}

- (SKSpriteNode *)newForestNode
{
	SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"rewards-forrestv2"];
	sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
	sn.name = @"BACKGROUND";
	CGSize r = self.frame.size;
	float fact = r.height/backgroundHeight;
	
	sn.size = CGSizeMake(backgroundWidth*fact, backgroundHeight*fact);

//	self.scale = self.frame.size.height / 320;
	self.scale = self.frame.size.height / 640;
	return sn;
}

- (SKSpriteNode*) newDeerNode
{
	SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"deer1"];
	CGPoint p = [self forestPoint:CGPointMake(645, 200)];
	sn.position = p;
	float scale = 0.15;
	sn.size = CGSizeMake(sn.size.width*scale, sn.size.height*scale);
	sn.name = @"DEER";
	return sn;
}

- (SKSpriteNode*) newSquirrelNode
{
	SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"squirrel1"];
	CGPoint p = [self forestPoint:CGPointMake(224, 103)];
	sn.position = p;
	float scale = 0.7;
	sn.size = CGSizeMake(sn.size.width*scale, sn.size.height*scale);
	sn.name = @"SQUIRREL";
	return sn;
}

- (SKSpriteNode*) newDragonNode
{
	SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"dragon1"];
	CGPoint p = [self forestPoint:CGPointMake(1550, 140)];
	sn.position = p;
	sn.name = @"DRAGON";
	return sn;
}

- (SKSpriteNode* ) newBirdSittingNode
{
	SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"bird-sitting_03"];
	CGPoint p = [self forestPoint:CGPointMake(904, 69)];
	sn.position = p;
	sn.name = @"BIRD";
	return sn;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInNode:self];
	NSArray * nodes = [self nodesAtPoint:location];
	[nodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SKNode * node = obj;
		if ([node.name isEqualToString:@"BIRD"] && self.birdOnRightTree){
			[self flyToLeftTree];
			return;
		}
		if ([node.name isEqualToString:@"BIRD"] && self.birdOnLeftTree){
			[self flyToRightTree];
			return;
		}
		if ([node.name isEqualToString:@"BIRD"] && self.birdFlyingRight){
			[self flyToLeftTree];
			return;
		}
		if ([node.name isEqualToString:@"BIRD"] && self.birdFlyingLeft){
			[self flyToRightTree];
			return;
		}
		if ([node.name isEqualToString:@"DRAGON"]){
			[self dragonSmoke];
		}
		if ([node.name isEqualToString:@"SQUIRREL"]){
			[self squirrelEatNut];
		}
		if ([node.name isEqualToString:@"DEER"]){
			[self deerEatGrass];
		}
	}];
}

@end