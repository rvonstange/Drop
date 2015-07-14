//
//  CCDragSprite.m
//  Drop
//
//  Created by Robert von Stange on 6/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCDragSprite.h"

@implementation CCDragSprite

- (void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    NSLog(@"Began");

}
- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode: self.parent];
    self.position = touchLocation;
    NSLog(@"Moved");

}

@end
