//
//  Gameplay.m
//  Drop
//
//  Created by Robert von Stange on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"
#import "StationaryBall.h"
#import "Ball.h"
#import "Log.h"
#import "CCDragSprite.h"

@implementation Gameplay {


    CCPhysicsNode *_physicsNode;
    StationaryBall *_ballOne;
    StationaryBall *_ballTwo;
    Ball *_mainBall;
    Log *_log;
    CCNode *_itemsBox;
    CCNode *_levelNode;
    CCNode *_items;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level_1"];
    [_levelNode addChild:level];
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    //_physicsNode.collisionDelegate = self;
    
}


- (void)retry {
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

-(void)drop {
    _mainBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    CCLOG(@"Drop");
}





@end
