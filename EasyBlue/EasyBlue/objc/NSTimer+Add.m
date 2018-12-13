//
//  NSTimer+Add.m
//  Teee
//
//  Created by taoxiaofei on 2018/11/14.
//  Copyright © 2018年 easy. All rights reserved.
//

#import "NSTimer+Add.h"

@implementation NSTimer (Add)
+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                           block:(void(^)(void))block
                                         repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(xx_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(void(^)(void))block
                              repeats:(BOOL)repeats{
    return [self timerWithTimeInterval:interval target:self selector:@selector(xx_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)xx_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}
@end
