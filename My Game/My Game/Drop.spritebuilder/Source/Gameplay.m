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
#import "ExplodingBall.h"
#import "ElasticBall.h"

static int levelNum;
static int maxLevel;

@implementation Gameplay {


    CCPhysicsNode *_physicsNode;
    Ball *_mainBall;
    CCNode *_itemsBox;
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_items;
    CCNode *_temp;
    CCNode *_sballs;
    CCNode *_alreadyPlaced;
    CCNode *_dynamicItems;
    CGPoint original;
    bool dropClicked;
    NSString *currentLevel;
    
}

//used to set the Level Number from other classes
+(void)setLevel: (int) num {
    levelNum = num;
}

+(int)getLevel {
    return levelNum;
}

+(void)setMaxLevel: (int) num {
    maxLevel = num;
}

+(int)getMaxLevel {
    return maxLevel;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    NSString* tempString = [NSString stringWithFormat:@"%i",levelNum];
    //Updates the Gameplay to reflect the new level
    currentLevel = [@"Levels/Level_" stringByAppendingString: tempString];
    CCScene *levelScene = [CCBReader loadAsScene:currentLevel];
    [_levelNode addChild:levelScene];
    
    
    //Grab all the items inside of the items box
    CCNode *level = levelScene.children[0];
    _items = level.children[1];
    _sballs = level.children[0];
    _alreadyPlaced = level.children[2];
    if (level.children.count > 3) {
        _dynamicItems = level.children[3];
    }

    _physicsNode.collisionDelegate = self;
    
    dropClicked = false;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                  target: self
                                                selector:@selector(gameOverCheck)
                                                userInfo: nil repeats:YES];
        
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

// This chunk was used to stop items from overlapping, but after testing the game, I found that users quickly became annoyed
// due to the imperfections with triangles. Therefore I eliminated this feature and the users seemed more satisfied with the gameplay.
//
//    for (int i = 0; i <_items.children.count; i++){
//        if (_temp != _items.children[i]) {
//            if (CGRectIntersectsRect([_items.children[i] boundingBox], [_temp boundingBox])) {
//                _temp.position = original;
//                break;
//            }
//        }
//    }
    if (!CGRectContainsRect([_levelNode boundingBox], [_temp boundingBox])) {
    
            _temp.position = original;
    }
    //Stops items from being placed on stationary balls
    for (int j = 0; j < _sballs.children.count; j++) {
        CCNode * _tempBall = _sballs.children[j];
        if (CGRectIntersectsRect([_tempBall boundingBox], [_temp boundingBox])) {
            _temp.position = original;
            break;
        }
    }
    //Stops items from being placed on dynamic pieces
    for (int i = 0; i < _dynamicItems.children.count; i++) {
        CCNode * _dItem = _dynamicItems.children[i];
        if (CGRectIntersectsRect([_dItem boundingBox], [_temp boundingBox])) {
            _temp.position = original;
            break;
        }
    }

}



//Breakable part collisions
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair itemToBreak:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    [[_physicsNode space] addPostStepBlock:^{
        [self breakItem:nodeA];
    } key:nodeA];
    
}

- (void) breakItem: (CCNode *) itemToBreak {
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"BreakItem"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = itemToBreak.position;
    [itemToBreak.parent addChild:explosion];
    [itemToBreak removeFromParent];
    
}


//Stationary Ball Collisions
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair stationaryBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {

    
    [[_physicsNode space] addPostStepBlock:^{
        [self ballCollision:nodeA];
    } key:nodeA];
    
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


//Double Hit Ball Collisions
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair doubleHit:(CCNode *)nodeA wildcard:(Ball *)nodeB {
    
    if (dropClicked) {
        [[_physicsNode space] addPostStepBlock:^{
            [self doubleHitCollision:nodeA withOtherBall: nodeB];
        } key:nodeA];
    }
    
}

- (void)doubleHitCollision:(CCNode *)doubleHit withOtherBall: (CCNode *) ball {
    StationaryBall *sBall = (StationaryBall *)[CCBReader load:@"StationaryBall"];
    CCNode * parent = doubleHit.parent;
    sBall.physicsBody.type = CCPhysicsBodyTypeStatic;
    sBall.position = doubleHit.position;
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"DoubleBallChange"];
    explosion.autoRemoveOnFinish = TRUE;
    explosion.position = doubleHit.position;
    [parent addChild:explosion];
    [doubleHit removeFromParent];
    [parent addChild:sBall];
    [ball removeFromParent];
    //[self ballRemoval:ball];
    
}

//Ground collisions to eliminate anything that hits the ground
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ground:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    [[_physicsNode space] addPostStepBlock:^{
        [self ballRemoval:nodeB];
    } key:nodeA];
    
}

-(void)ballRemoval:(CCNode *)movingBall {
        CCNode *mainBallParent = _mainBall.parent;
        CCSprite *explosion = (CCSprite *)[CCBReader load:@"Explosion"];
        explosion.position = movingBall.position;
        [_alreadyPlaced addChild:explosion];
        [movingBall removeFromParent];
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
        if (noMovingBallsLeft && !noStationaryBallsLeft && (mainBallParent.children.count == 0)) {
            [self gameOver];
        }
}


//These next two functions are used for Stationary Exploding Ball collisions
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair SEBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    if (dropClicked) {
        [[_physicsNode space] addPostStepBlock:^{
            [self SEBallCollision:nodeA];
        } key:nodeA];
    }
}


- (void)SEBallCollision:(CCNode *)SEBall {
    ExplodingBall *movingBall = (ExplodingBall *)[CCBReader load:@"ExplodingBall"];
    movingBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    movingBall.position = SEBall.position;
    [SEBall.parent addChild:movingBall];
    [SEBall removeFromParent];
}

//These next two functions are used for exploding ball collisions
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair explodingBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    
    [[_physicsNode space] addPostStepBlock:^{
        [self ballExplode:nodeA withOtherNode:nodeB];
    } key:nodeA];
    
}


- (void)ballExplode:(CCNode *)eBall withOtherNode: (CCNode *) other {
    CCSprite *explosion = (CCSprite *)[CCBReader load:@"ExplosionPurple"];
    explosion.position = other.position;
    [_alreadyPlaced addChild:explosion];
    [other removeFromParent];
    [eBall removeFromParent];
}

//These next two functions are used for Stationary Elastic Ball collisions
- (void)ccPhysicsCollisionSeparate:(CCPhysicsCollisionPair *)pair SElasticBall:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    
    if (dropClicked) {
        [[_physicsNode space] addPostStepBlock:^{
            [self SElasticBallCollision:nodeA];
        } key:nodeA];
    }
}


- (void)SElasticBallCollision:(CCNode *)SElasticBall {
    ElasticBall *movingBall = (ElasticBall *) [CCBReader load:@"ElasticBall"];
    movingBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    movingBall.position = SElasticBall.position;
    [SElasticBall.parent addChild:movingBall];
    [SElasticBall removeFromParent];
}


//The next three functions are used for ending the level
- (void)levelComplete {
    self.userInteractionEnabled = FALSE;
    CCScene *moveToNextLevel = [CCBReader loadAsScene:@"MoveToNextLevel"];
    if (levelNum == 20) {
        moveToNextLevel = [CCBReader loadAsScene:@"GameDone"];
    }
    [_contentNode addChild:moveToNextLevel];
}

- (void)gameOver {
    self.userInteractionEnabled = FALSE;
    CCScene *gameOver = [CCBReader loadAsScene:@"GameOverScene"];
    [_contentNode addChild:gameOver];
}

- (void) gameOverCheck {
    CCNode *mainBallParent = _mainBall.parent;
    bool noMovingBallsLeft = true;
    bool noStationaryBallsLeft = true;
    for (int i = 0; i < _sballs.children.count; i++) {
        CCNode *temp = _sballs.children[i];
        if (temp.physicsBody.type == CCPhysicsBodyTypeDynamic) {
            if ((temp.physicsBody.velocity.x > 0.0) || (temp.physicsBody.velocity.y > 0.0)) {
                noMovingBallsLeft = false;
            }
        }
        if (temp.physicsBody.type == CCPhysicsBodyTypeStatic) {
            noStationaryBallsLeft = false;
        }
    }
    if (noMovingBallsLeft && !noStationaryBallsLeft && (mainBallParent.children.count == 0)) {
        [self gameOver];
    }

}


//These three functions are for the buttons
- (void)retry {
    // reload this level
    dropClicked = false;
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

- (void)menu {
    //Go to level select
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"LevelSelection"]];
}


-(void)drop {
    _mainBall.physicsBody.type = CCPhysicsBodyTypeDynamic;
    dropClicked = true;
    for (int i = 0; i < _dynamicItems.children.count; i++) {
        CCNode *temp = _dynamicItems.children[i];
        temp.physicsBody.type = CCPhysicsBodyTypeDynamic;
        
    }
}


@end
