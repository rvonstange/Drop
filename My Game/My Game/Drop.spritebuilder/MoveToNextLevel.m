//
//  MoveToNextLevel.m
//  Drop
//
//  Created by Robert von Stange on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MoveToNextLevel.h"

@implementation MoveToNextLevel

- (void)mainmenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"LevelSelection"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}
- (void)nextLevel {
    //Honestly Have no idea as of right now 
}


@end
