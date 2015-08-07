//
//  GameDone.m
//  Drop
//
//  Created by Robert von Stange on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameDone.h"

@implementation GameDone

- (void)mainmenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"LevelSelection"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
