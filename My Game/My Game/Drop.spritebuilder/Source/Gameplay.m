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
    Ball *_mainBall;
    CCNode *_itemsBox;
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_items;
    CCNode *_temp;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    CCScene *levelScene = [CCBReader loadAsScene:@"Levels/Level_1"];
    [_levelNode addChild:levelScene];
    
    //Grab all the items inside of the items box
    CCNode *level = levelScene.children[0];
    _items = level.children[1];

    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    for (int i = 0; i < _items.children.count; i++) {
        _temp = _items.children[i];
        if (CGRectContainsPoint([_temp boundingBox], touchLocation)) {
            _temp.position = touchLocation;
            break;
        }
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // whenever touches move, update the position of the mouseJointNode to the touch position
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _temp.position = touchLocation;
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair stationaryBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {

        [[_physicsNode space] addPostStepBlock:^{
            [self ballCollision:nodeA];
        } key:nodeA];

}

- (void)ballCollision:(CCNode *)ball {
    
    CCNode *movingBall = (CCNode *)[CCBReader load:@"Ball"];
    movingBall.position = ball.position;
    [ball.parent addChild:movingBall];
    [ball removeFromParent];
    
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
