//
//  GameScene.m
//  BlockBreakers
//
//  Created by Ananta Shahane on 11/01/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import "GameScene.h"
#import "GameOver.h"
#import "GameWon.h"

@implementation GameScene

static const uint32_t category_fence = 0x1 << 3;
static const uint32_t category_paddle = 0x1 << 2;
static const uint32_t category_block = 0x1 << 1;
static const uint32_t category_ball = 0x1 << 0;


-(void) didMoveToView:(SKView *)view {
    self.name = @"Fence";
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask =  category_fence;
    self.physicsBody.collisionBitMask = 0x0;
    self.physicsBody.contactTestBitMask = 0x0;
    SKSpriteNode * bacground = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    bacground.zPosition = 0;
    bacground.lightingBitMask = 0x1;
    self.physicsWorld.contactDelegate = self;
    
    SKSpriteNode *ball1 = [SKSpriteNode spriteNodeWithImageNamed:@"Ball.png"];
    ball1.name = @"Ball1";
    ball1.position = CGPointMake(0, 0);
    ball1.zPosition = 1;
    ball1.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball1.size.width/2];
    ball1.physicsBody.dynamic = YES;
    ball1.physicsBody.friction = 0;
    ball1.physicsBody.restitution = 1.0;
    ball1.physicsBody.linearDamping = 0;
    ball1.physicsBody.angularDamping = 0;
    ball1.physicsBody.allowsRotation = YES;
    ball1.physicsBody.mass = 1.0;
    ball1.physicsBody.velocity = CGVectorMake(400 , 400);
    ball1.physicsBody.affectedByGravity = NO;
    ball1.physicsBody.categoryBitMask = category_ball;
    ball1.physicsBody.contactTestBitMask = category_fence | category_block | category_paddle;
    ball1.physicsBody.collisionBitMask = category_paddle | category_block | category_fence;
    ball1.physicsBody.usesPreciseCollisionDetection = YES;
    
    SKSpriteNode *ball2 = [SKSpriteNode spriteNodeWithImageNamed:@"Ball.png"];
    ball2.name = @"Ball2";
    ball2.position = CGPointMake(50, 50);
    ball2.zPosition = 1;
    ball2.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball2.size.width/2];
    ball2.physicsBody.dynamic = YES;
    ball2.physicsBody.friction = 0.0;
    ball2.physicsBody.restitution = 1.0;
    ball2.physicsBody.linearDamping = 0.0;
    ball2.physicsBody.angularDamping = 0.0;
    ball2.physicsBody.allowsRotation = YES;
    ball2.physicsBody.mass = 1.0;
    ball2.physicsBody.velocity = CGVectorMake(0 , 800);
    ball2.physicsBody.affectedByGravity = NO;
    ball2.physicsBody.categoryBitMask = category_ball;
    ball2.physicsBody.contactTestBitMask = category_fence | category_block | category_paddle;
    ball2.physicsBody.collisionBitMask = category_paddle | category_block | category_fence;
    ball2.physicsBody.usesPreciseCollisionDetection = YES;
    
    SKLightNode *light = [SKLightNode new];
    light.falloff = 1;
    light.ambientColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    light.lightColor = [UIColor colorWithRed:0.8 green:0.7 blue:1.0 alpha:1.0];
    light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    light.zPosition = 1;
    [ball1 addChild: light];
    
    
    SKSpriteNode *paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle.png"];
    paddle.name = @"Paddle";
    paddle.position = CGPointMake(0, -368);
    paddle.zPosition = 1;
    
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(paddle.size.width, paddle.size.height)];
    paddle.physicsBody.dynamic = NO;
    paddle.physicsBody.friction = 0.0;
    paddle.physicsBody.restitution = 1.0;
    paddle.physicsBody.linearDamping = 0.0;
    paddle.physicsBody.angularDamping = 0.0;
    paddle.physicsBody.allowsRotation = NO;
    paddle.physicsBody.mass = 15.0;
    paddle.physicsBody.velocity = CGVectorMake(0 , 0);
    paddle.physicsBody.categoryBitMask = category_paddle;
    paddle.physicsBody.collisionBitMask = 0x0;
    paddle.physicsBody.contactTestBitMask = category_ball;
    paddle.physicsBody.usesPreciseCollisionDetection = YES;
    paddle.lightingBitMask = 0x1;
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
    joint.frequency = 3;
    [self.scene.physicsWorld addJoint:joint];
    
    self.blockFrames = [NSMutableArray array];
    
    SKTextureAtlas *blockAnimation = [SKTextureAtlas atlasNamed:@"Block.atlas"];
    unsigned long numImages = blockAnimation.textureNames.count;
    
    for (int i = 0; i < numImages; i++)
    {
        NSString *textureName = [NSString stringWithFormat:@"block%02d.png", i];
        SKTexture *temp = [blockAnimation textureNamed:textureName];
        [self.blockFrames addObject:temp];
    }
    
    
    SKSpriteNode * node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
    node.scale = 0.1;
    
    CGFloat kBlockWidth = node.size.width;
    CGFloat kBlockHorizontalSpace = 5.0f;
    int kBlocksperRow = self.size.width / (kBlockWidth + kBlockHorizontalSpace);
    
    for (int i = 0; i < kBlocksperRow; i++)
    {
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.10;
        node.name = @"Block";
        node.position = CGPointMake((kBlockHorizontalSpace/2 + kBlockWidth/2 + i * (kBlockWidth) + i*kBlockHorizontalSpace)-self.size.width/2, self.size.height/2-50);
        node.zPosition = 1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0;
        node.physicsBody.restitution = 1;
        node.physicsBody.linearDamping = 0;
        node.physicsBody.angularDamping = 0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0, 0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = YES;
        node.lightingBitMask = 0x1;
        [self addChild:node];
    }
    kBlocksperRow = (self.size.width/ (kBlockWidth + kBlockHorizontalSpace)) -1;
    for (int i = 0; i < kBlocksperRow; i++)
    {
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.10;
        node.name = @"Block";
        node.position = CGPointMake((kBlockHorizontalSpace/2 + kBlockWidth/2 + i * (kBlockWidth) + i*kBlockHorizontalSpace)-self.size.width/2, self.size.height/2-100);
        node.zPosition = 1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0;
        node.physicsBody.restitution = 1;
        node.physicsBody.linearDamping = 0;
        node.physicsBody.angularDamping = 0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0, 0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = YES;
        node.lightingBitMask = 0x1;
        [self addChild:node];
    }
    kBlocksperRow = (self.size.width/ (kBlockWidth + kBlockHorizontalSpace)) -1;
    for (int i = 0; i < kBlocksperRow; i++)
    {
        node = [SKSpriteNode spriteNodeWithTexture:self.blockFrames[0]];
        node.scale = 0.10;
        node.name = @"Block";
        node.position = CGPointMake((kBlockHorizontalSpace/2 + kBlockWidth/2 + i * (kBlockWidth) + i*kBlockHorizontalSpace)-self.size.width/2, self.size.height/2-150);
        node.zPosition = 1;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(0, 0)];
        node.physicsBody.dynamic = NO;
        node.physicsBody.friction = 0;
        node.physicsBody.restitution = 1;
        node.physicsBody.linearDamping = 0;
        node.physicsBody.angularDamping = 0;
        node.physicsBody.allowsRotation = NO;
        node.physicsBody.mass = 1.0;
        node.physicsBody.velocity = CGVectorMake(0, 0);
        node.physicsBody.categoryBitMask = category_block;
        node.physicsBody.collisionBitMask = 0x0;
        node.physicsBody.contactTestBitMask = category_ball;
        node.physicsBody.usesPreciseCollisionDetection = YES;
        node.lightingBitMask = 0x1;
        [self addChild:node];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    const CGRect touchRegion = CGRectMake(-512, -384, self.size.width, self.size.height/2);
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

-(void) didBeginContact:(SKPhysicsContact *)contact {
    NSString *NameA = contact.bodyA.node.name;
    NSString *NameB = contact.bodyB.node.name;
    if([self children].count > 60)
    {
        SKScene *scene = self.scene;
        [[self childNodeWithName:@"spark"] removeAllChildren];
    }
    if(([NameA containsString:@"Fence"] && [NameB containsString:@"Ball"]) || ([NameA containsString:@"Ball"] && [NameB containsString:@"Fence"]))
    {
        if(contact.contactPoint.y < -364)
        {
            SKView *view = (SKView *) self.view;
            [self removeFromParent];

            GameOver *scene = [GameOver nodeWithFileNamed:@"GameOver"];
            scene.scaleMode = SKSceneScaleModeAspectFit;

            [view presentScene:scene];
        }
        NSString *SparkPath = [[NSBundle mainBundle] pathForResource:@"Sparks" ofType:@"sks"];
        SKEmitterNode *spark = [NSKeyedUnarchiver unarchiveObjectWithFile:SparkPath];
        spark.position = [contact contactPoint];
        spark.zPosition = 1;
        SKAction *Sparky = [SKAction runBlock:^{
            [self addChild:spark];
        }];
        
        SKAction *BorderHit = [SKAction playSoundFileNamed:@"Border.wav" waitForCompletion:NO];
        SKAction *rebound = [SKAction sequence:@[BorderHit, Sparky]];
        [self.SparkContainer addObject:spark];
        [self runAction:rebound];
    }
    if(([NameA containsString:@"Block"] && [NameB containsString:@"Ball"])||([NameB containsString:@"Block"] && [NameA containsString:@"Ball"]))
    {
        SKNode *block;
        if([NameA containsString:@"Block"])
        {
            block = contact.bodyA.node;
        }
        else
        {
            block = contact.bodyB.node;
        }
        SKAction *BlockHit = [SKAction playSoundFileNamed:@"Border.wav" waitForCompletion:NO];
        SKAction *ExplodingBlock = [SKAction animateWithTextures:self.blockFrames
                                                    timePerFrame:0.002f
                                                          resize:NO
                                                         restore:NO];
        NSString *particleRampPath = [[NSBundle mainBundle] pathForResource:@"ParticleBuildUp" ofType:@"sks"];
        SKEmitterNode *particleRamp = [NSKeyedUnarchiver unarchiveObjectWithFile:particleRampPath];
        particleRamp.position = CGPointMake(0, 0);
        particleRamp.zPosition = 0;
        
        SKAction *actionRamp = [SKAction runBlock:^{
            [block addChild:particleRamp];
        }];
        SKAction *actionRampSequence = [SKAction group:@[BlockHit, actionRamp, ExplodingBlock]];
        
        NSString *particleExplodedPath = [[NSBundle mainBundle] pathForResource:@"ParticleBlock" ofType:@"sks"];
        SKEmitterNode *BlockExploded = [NSKeyedUnarchiver unarchiveObjectWithFile:particleExplodedPath];
        BlockExploded.position = CGPointMake(0, 0);
        BlockExploded.zPosition = 2;
        SKAction *explodedBlock = [SKAction runBlock:^{
            [block addChild:BlockExploded];
        }];
        
        SKAction *BlockBoom = [SKAction playSoundFileNamed:@"Explosion.wav" waitForCompletion:NO];
        SKAction *actionRemoveBlock = [SKAction removeFromParent];
        SKAction *explosion = [SKAction sequence:@[BlockBoom, explodedBlock,[SKAction fadeOutWithDuration:0.4]]];
        
        SKAction *checkGameOver = [SKAction runBlock:^{
            BOOL anyBlocksRemaining = ([self childNodeWithName:@"Block"] != nil);
            if(!anyBlocksRemaining)
            {
                SKView *skview = (SKView *)self.view;
                [self removeFromParent];
                GameWon *scene = [GameWon nodeWithFileNamed:@"GameWon"];
                scene.scaleMode = SKSceneScaleModeAspectFit;
                [skview presentScene:scene];
            }
        }];
        [block runAction:[SKAction sequence:@[actionRampSequence, explosion, actionRemoveBlock, checkGameOver]]];
    }
    if(([NameA containsString:@"Ball"] && [NameB containsString:@"Paddle"]) || ([NameB containsString:@"Ball"] && [NameA containsString:@"Paddle"]))
    {
        SKAction *paddleAudio = [SKAction playSoundFileNamed:@"paddle.wav" waitForCompletion:NO];
        [self runAction:paddleAudio];
    }
}

-(void) update:(NSTimeInterval)currentTime{
    static const int kMaxSpeed = 1500;
    static const int kMinSpeed = 400;
    
    SKNode *ball1 = [self childNodeWithName:@"Ball1"];
    SKNode *ball2 = [self childNodeWithName:@"Ball2"];
    
    float dx = (ball1.physicsBody.velocity.dx + ball2.physicsBody.velocity.dx)/2;
    float dy = (ball1.physicsBody.velocity.dy + ball2.physicsBody.velocity.dy)/2;
    float speed = sqrtf(dx * dx + dy * dy);
    if(speed > kMaxSpeed)
    {
        ball1.physicsBody.linearDamping += 0.1f;
        ball2.physicsBody.linearDamping += 0.1f;
    }
    else if (speed < kMinSpeed)
    {
        ball1.physicsBody.linearDamping -= 0.1f;
        ball2.physicsBody.linearDamping -= 0.1f;
    }
    else
    {
        ball1.physicsBody.linearDamping = 0.0f;
        ball2.physicsBody.linearDamping = 0.0f;
    }
}
@end
