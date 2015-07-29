//
//  StationaryBall.m
//  Drop
//
//  Created by Robert von Stange on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StationaryBall.h"

@implementation StationaryBall

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"stationaryBall";
}

@end
