

#import "MainScene.h"


@implementation MainScene

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelection"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)instructions {
    CCScene *instructions = [CCBReader loadAsScene:@"Instructions"];
    [[CCDirector sharedDirector] replaceScene:instructions];
}

@end
