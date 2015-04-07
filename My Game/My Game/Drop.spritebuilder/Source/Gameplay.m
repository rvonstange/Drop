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

@implementation Gameplay {


    CCPhysicsNode *_physicsNode;
    StationaryBall *_ballOne;
    StationaryBall *_ballTwo;
    Ball *_mainBall;
    Log *_log;
    CCNode *_itemsBox;
    CCNode *_levelNode;
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

    //_mainBall.physicsBody.dynamic = YES;
}

// called on every touch in this scene
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_itemsBox];
    
    if (CGRectContainsPoint([_log boundingBox], touchLocation))
    {
        _log.position = touchLocation;
    }
//
//        // create a penguin from the ccb-file
//        _currentPenguin = (Penguin*)[CCBReader load:@"Penguin"];
//        // initially position it on the scoop. 34,138 is the position in the node space of the _catapultArm
//        CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
//        // transform the world position to the node space to which the penguin will be added (_physicsNode)
//        _currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
//        // add it to the physics world
//        [_physicsNode addChild:_currentPenguin];
//        // we don't want the penguin to rotate in the scoop
//        _currentPenguin.physicsBody.allowsRotation = FALSE;
//        
//        // create a joint to keep the penguin fixed to the scoop until the catapult is released
//        _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultArm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
//    }
}
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // whenever touches move, update the position of the mouseJointNode to the touch position
    CGPoint touchLocation = [touch locationInNode:_itemsBox];
    _itemsBox.position = touchLocation;
}


-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // when touches end, meaning the user releases their finger
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else
}



@end
