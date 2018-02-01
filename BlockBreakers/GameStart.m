//
//  GameStart.m
//  BlockBreakers
//
//  Created by Ananta Shahane on 23/01/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import "GameStart.h"
#import "GameScene.h"

@implementation GameStart

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(touches){
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        
        scene.scaleMode = SKSceneScaleModeAspectFit;
        
        SKView *skView = (SKView *)self.view;
        
        // Present the scene
        [skView presentScene:scene];
    }
}


@end
