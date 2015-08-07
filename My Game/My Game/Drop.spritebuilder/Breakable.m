//
//  Breakable.m
//  Drop
//
//  Created by Robert von Stange on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Breakable.h"

@implementation Breakable

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"itemToBreak";
}



@end
