//
//  Gameplay.h
//  Drop
//
//  Created by Robert von Stange on 2/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

+(void)setLevel: (int) num;
+(int)getLevel;
+(void)setMaxLevel: (int) num;
+(int)getMaxLevel;

@end
