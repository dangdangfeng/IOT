//
//  NSTimer+Add.h
//  Teee
//
//  Created by taoxiaofei on 2018/11/14.
//  Copyright © 2018年 easy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Add)
+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                           block:(void(^)(void))block
                                         repeats:(BOOL)repeats;

+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(void(^)(void))block
                              repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
