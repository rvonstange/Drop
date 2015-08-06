//
//  LevelSelection.m
//  Drop
//
//  Created by Robert von Stange on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "LevelSelection.h"
#import "MainScene.h"
#import "Gameplay.h"

@implementation LevelSelection {

    CCLayoutBox *_box;
    CCNode *_container;
    CCNode *_1;
    CCNode *_2;
    CCNode *_3;
    CCNode *_4;
    CCNode *_5;
    CCNode *_6;
    CCNode *_7;
    CCNode *_8;
    CCNode *_9;
    CCNode *_10;
    CCNode *_11;
    CCNode *_12;
    CCNode *_13;
    CCNode *_14;
    CCNode *_15;
    CCNode *_16;
    CCNode *_17;
    CCNode *_18;
    CCNode *_19;
    CCNode *_20;
    
}

- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    
}

- (void)didLoadFromCCB {

    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
}

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    CGPoint touchLocation = [touch locationInNode: _box ];
    for (int i = 0; i < _box.children.count; i++) {
        CCNode *temp = _box.children[i];
        for (int j = 0; j <temp.children.count; j++) {
            CCNode *temp2 = temp.children[j];
            CGFloat width = [temp2 boundingBox].size.width;
            CGFloat height = [temp2 boundingBox].size.height;
            CGFloat x = [temp2 boundingBox].origin.x;
            CGFloat y = i*74.0;
            if (CGRectContainsPoint(CGRectMake(x, y, width, height), touchLocation)) {
                NSInteger number = [temp2.name integerValue];
                [Gameplay setLevel: (int)number];
                CCScene *gamePlay = [CCBReader loadAsScene:@"Gameplay"];
                [[CCDirector sharedDirector] replaceScene:gamePlay];

            }
        }
    }
    
}


@end
