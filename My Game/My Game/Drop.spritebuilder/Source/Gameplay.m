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


@implementation Gameplay {


    CCPhysicsNode *_physicsNode;
    Ball *_mainBall;
    CCNode *_itemsBox;
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_items;
    CCNode *_temp;
    CCNode *_sballs;
    CGPoint original;
    bool dropClicked;
    int currentLevel;
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
    _sballs = level.children[0];
    
    _physicsNode.collisionDelegate = self;
    
    dropClicked = false;
}


- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    if (dropClicked == false){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        original = touchLocation;
        for (int i = 0; i < _items.children.count; i++) {
            _temp = _items.children[i];
            if (    CGRectContainsPoint([_temp boundingBox], touchLocation)) {
                _temp.position = touchLocation;
                break;
            }
        }
    }
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    // whenever touches move, update the position of the item being dragged to the touch position
    if (dropClicked == false){
        CGPoint touchLocation = [touch locationInNode:_contentNode];
        _temp.position = touchLocation;
    }
}

-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    for (int i = 0; i <_items.children.count; i++){
        if (_temp != _items.children[i]) {
            if (CGRectIntersectsRect([_items.children[i] boundingBox], [_temp boundingBox])) {
                _temp.position = original;
                break;
            }
        }
    }
    //Currently items can be placed on top of stationary balls. So far have not been sucessful in stopping this from occuring.
/*    for (int j = 0; j < _sballs.children.count; j++) {
        CCNode * _tempBall = _sballs.children[j];
        if (CGRectIntersectsRect([_tempBall boundingBox], [_temp boundingBox])) {
            _temp.position = original;
            break;
        }
    }*/

}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair stationaryBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {

    
    [[_physicsNode space] addPostStepBlock:^{
        [self ballCollision:nodeA];
    } key:nodeA];
    
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    
    [[_physicsNode space] addPostStepBlock:^{
        [self ballRemoval:nodeB];
    } key:nodeB];
    
}

-(void)ballRemoval:(CCNode *)movingBall {
    bool mainBallGone = false;
    if (movingBall == _mainBall) {
        mainBallGone = true;
    }
    [movingBall removeFromParent];
    if (mainBallGone == false) {
        return;
    }
    else {
        bool noMovingBallsLeft = true;
        bool noStationaryBallsLeft = true;
        for (int i = 0; i < _sballs.children.count; i++) {
            CCNode *temp = _sballs.children[i];
            if (temp.physicsBody.type == CCPhysicsBodyTypeDynamic) {
                noMovingBallsLeft = false;
            }
            if (temp.physicsBody.type == CCPhysicsBodyTypeStatic) {
                noStationaryBallsLeft = false;
            }
        }
        if (noMovingBallsLeft && !noStationaryBallsLeft) {
            [self gameOver];
        }
    }
}

- (void)gameOver {
    self.userInteractionEnabled = FALSE;
    CCScene *gameOver = [CCBReader loadAsScene:@"GameOverScene"];
    [_contentNode addChild:gameOver];
}



- (void)ballCollision:(CCNode *)stationaryBall {
    bool noBallsLeft = true;
    Ball *movingBall = (Ball *)[CCBReader load:@"Ball"];
    movingBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    movingBall.position = stationaryBall.position;
    [stationaryBall.parent addChild:movingBall];
    [stationaryBall removeFromParent];
    for (int i = 0; i < _sballs.children.count; i++) {
        CCNode *temp = _sballs.children[i];
        if (temp.physicsBody.type == CCPhysicsBodyTypeStatic) {
            noBallsLeft = false;
        }
    }
    if (noBallsLeft) {
        [self levelComplete];
    }
    
}

- (void)levelComplete {
    self.userInteractionEnabled = FALSE;
    CCScene *moveToNextLevel = [CCBReader loadAsScene:@"MoveToNextLevel"];
    [_contentNode addChild:moveToNextLevel];
}

- (void)retry {
    // reload this level
    dropClicked = false;
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

-(void)drop {
    _mainBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    dropClicked = true;
}


@end
