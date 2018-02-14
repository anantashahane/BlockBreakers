//
//  GameScene.h
//  BlockBreakers
//
//  Created by Ananta Shahane on 11/01/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (strong, nonatomic) NSMutableArray *blockFrames;
@property (nonatomic, strong, nullable) UITouch *motivatingTouch;
@property(nonatomic, strong) NSMutableArray *SparkContainer;

@end
