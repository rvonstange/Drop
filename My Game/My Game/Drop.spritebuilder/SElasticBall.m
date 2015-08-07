//
//  SElasticBall.m
//  Drop
//
//  Created by Robert von Stange on 8/7/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "SElasticBall.h"

@implementation SElasticBall

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"SElasticBall";
}

@end
