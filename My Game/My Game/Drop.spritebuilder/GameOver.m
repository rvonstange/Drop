//
//  GameOver.m
//  Drop
//
//  Created by Robert von Stange on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

- (void)mainmenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"LevelSelection"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
- (void)retry {
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

@end
