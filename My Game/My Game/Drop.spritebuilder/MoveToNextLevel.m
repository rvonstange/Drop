//
//  MoveToNextLevel.m
//  Drop
//
//  Created by Robert von Stange on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MoveToNextLevel.h"
#import "Gameplay.h"

@implementation MoveToNextLevel

- (void)mainmenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"LevelSelection"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
- (void)nextLevel {
    int newLevel = [Gameplay getLevel] + 1;
//    int maxLevel = [Gameplay getMaxLevel];
//    if (newLevel > maxLevel) {
//        [Gameplay setMaxLevel:newLevel];
//    }
    [Gameplay setLevel: newLevel];
    CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gamePlay];
    
}


@end
