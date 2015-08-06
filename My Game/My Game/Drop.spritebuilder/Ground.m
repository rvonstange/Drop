//
//  Ground.m
//  Drop
//
//  Created by Robert von Stange on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Ground.h"

@implementation Ground

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ground";
}

@end
