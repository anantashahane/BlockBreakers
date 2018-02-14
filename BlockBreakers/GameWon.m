//
//  GameWon.m
//  BlockBreakers
//
//  Created by Ananta Shahane on 14/02/18.
//  Copyright © 2018 Ananta Shahane. All rights reserved.
//

#import "GameWon.h"
#import "GameScene.h"

@implementation GameWon
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
