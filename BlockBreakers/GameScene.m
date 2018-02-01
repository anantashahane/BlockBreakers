//
//  GameScene.m
//  BlockBreakers
//
//  Created by Ananta Shahane on 11/01/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
@implementation GameScene

-(void) didMoveToView:(SKView *)view {
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.dynamic = NO;
//    CGVector gravity = CGVectorMake(0, 0);
//    self.physicsWorld.gravity = gravity;
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"Ball.png"];
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.position = CGPointMake(100, 0);
    ball1.physicsBody.friction = 0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0;
    ball1.physicsBody.angularDamping = 0;
    ball1.physicsBody.allowsRotation = YES;
    ball1.physicsBody.mass = 0.15;
    ball1.physicsBody.velocity = CGVectorMake(100 , 100);
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"Ball.png"];
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.position = CGPointMake(100, 100);
    ball2.physicsBody.friction = 0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0;
    ball2.physicsBody.angularDamping = 0;
    ball2.physicsBody.allowsRotation = YES;
    ball2.physicsBody.mass = 0.15;
    ball2.physicsBody.velocity = CGVectorMake(0 , 100);
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle.png"];
    paddle.name = @"Paddle";
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
    paddle.physicsBody.dynamic = NO;
    paddle.position = CGPointMake(0, -368);
    paddle.physicsBody.friction = 0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0;
    paddle.physicsBody.angularDamping = 0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 15.0;
    paddle.physicsBody.velocity = CGVectorMake(0 , 0);
    
    [self addChild:ball1];
    [self addChild:ball2];
    [self addChild:paddle];
    
    CGPoint ball1Anchor = CGPointMake(ball1.position.x, ball1.position.y);
    CGPoint ball2Anchor = CGPointMake(ball2.position.x, ball2.position.y);

    SKPhysicsJointSpring * joint = [SKPhysicsJointSpring jointWithBodyA:ball1.physicsBody
                                                                  bodyB:ball2.physicsBody
                                                                anchorA:ball1Anchor
                                                                anchorB:ball2Anchor];
    joint.damping = 0;
    joint.frequency = 1.2;
    [self.scene.physicsWorld addJoint:joint];
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    const CGRect touchRegion = CGRectMake(-512, -384, self.size.width, self.size.height/3);
    for (UITouch *touch in touches) {
        CGPoint p = [touch locationInNode:self];
        if(CGRectContainsPoint(touchRegion, p)){
            self.motivatingTouch = touch;
        }
    }
    [self trackPaaddlesToMotivatingTouches];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self trackPaaddlesToMotivatingTouches];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches containsObject:self.motivatingTouch])
    {
        self.motivatingTouch = nil;
    }
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([touches containsObject:self.motivatingTouch])
    {
        self.motivatingTouch = nil;
    }
}

-(void) trackPaaddlesToMotivatingTouches{
    CGFloat kTrackPixelsPerSecond = 3000;
    SKNode *paddle = [self childNodeWithName:@"Paddle"];
    UITouch *touch = self.motivatingTouch;
    if(!touch)
    {
        return;
    }
    CGFloat xPos = [touch locationInNode:self].x;
    NSTimeInterval duration = ABS(xPos -  paddle.position.x) / kTrackPixelsPerSecond;
    [paddle runAction:[SKAction moveToX:xPos duration:duration]];
}
@end
