//
//  GameScene.h
//  BlockBreakers
//
//  Created by Ananta Shahane on 11/01/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

    @property (nonatomic, strong, nullable) UITouch *motivatingTouch;

@end
