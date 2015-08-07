//
//  DoubleHitBall.m
//  Drop
//
//  Created by Robert von Stange on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "DoubleHitBall.h"

@implementation DoubleHitBall

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"doubleHit";
}

@end
