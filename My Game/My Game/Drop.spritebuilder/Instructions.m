//
//  Instructions.m
//  Drop
//
//  Created by Robert von Stange on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Instructions.h"

@implementation Instructions

- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    
}

@end
