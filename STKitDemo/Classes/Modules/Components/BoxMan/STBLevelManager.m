//
//  STBLevelManager.m
//  STBBoxMan
//
//  Created by SunJiangting on 12-12-7.
//
//

#import "STBLevelManager.h"

@implementation STBLevelManager

static STBLevelManager * _levelManager;


+ (STBLevelManager *) standardLevelManager {
    if (!_levelManager) {
        @synchronized(self) {
            if (!_levelManager) {
                _levelManager = [NSAllocateObject([self class], 0, NULL) init];
            }
        }
    }
    return _levelManager;
}


- (id) init {
    self = [super init];
    if (self) {
        _levelArray = [[NSMutableArray arrayWithCapacity:5] retain];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"boxman" ofType:@"plist"];
        NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray * levels = [dictionary objectForKey:@"Levels"];
        for (NSDictionary * dict in levels) {
            STBLevel * level = [STBLevel levelWithDictionary:dict];
            [_levelArray addObject:level];
        }
        NSNumber * levelNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"level"];
        if ([levelNumber isKindOfClass:[NSNumber class]]) {
            _currentLevel = [levelNumber intValue];
        } else {
            _currentLevel = 0;
        }
        _level = [[_levelArray objectAtIndex:_currentLevel] retain];
    }
    return self;
}


- (void) setCurrentLevel:(int)currentLevel {
    if (_levelArray.count == 0) {
        return;
    }
    _currentLevel = MAX(0, currentLevel);
    _currentLevel = MIN(_levelArray.count-1, currentLevel);
    [_level release];
    _level = [[_levelArray objectAtIndex:_currentLevel] retain];
}

/**
 * @brief 是否存在上一关
 *
 * @return 是否存在上一关
 */
- (BOOL) hasPrevLevel {
    return _currentLevel > 0;
}

/**
 * @brief 是否存在下一关
 *
 * @return 是否存在下一关
 */
- (BOOL) hasNextLevel {
    return _currentLevel < _levelArray.count -1;
}

/**
 * @brief 得到上一关
 *
 * @return 上一关的数据，会根据 boxman.plist 读取的信息和当前关数确定上一关
 * @note 如果不存在上一关，则返回nil。最好配合hasPrevLevel 使用
 */
- (STBLevel *) prevLevel {
    int prevLevel = _currentLevel - 1;
    if (prevLevel >= 0) {
        _currentLevel -= 1;
        [_level release];
        _level = [[_levelArray objectAtIndex:prevLevel] retain];
        return [_levelArray objectAtIndex:prevLevel];
    } else {
        return nil;
    }
}

/**
 * @brief 得到下一关
 *
 * @return 下一关的数据，会根据 boxman.plist 读取的信息和当前关数确定下一关
 * @note 如果不存在下一关，则返回nil。最好配合hasNextLevel 使用
 */
- (STBLevel *) nextLevel {
    int nextLevel = _currentLevel + 1;
    if (nextLevel < self.levelArray.count) {
        _currentLevel += 1;
        [_level release];
        _level = [[_levelArray objectAtIndex:nextLevel] retain];
        return [_levelArray objectAtIndex:nextLevel];
    } else {
        return nil;
    }
}

- (void) dealloc {
    [_level release];
    [_levelArray release];
    [super dealloc];
}

- (id) retain {
    return self;
}


+ (id) allocWithZone:(NSZone *)zone {
    STBLevelManager *manager = [self standardLevelManager];
    return manager;
}

- (id) copyWithZone:(NSZone*)zone {
    return self;
}


- (NSUInteger) retainCount {
    return NSUIntegerMax;
}

- (id) autorelease {
    return self;
}

@end
