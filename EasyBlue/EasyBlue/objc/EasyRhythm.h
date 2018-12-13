// easybluetooth Rhythm用于检测蓝牙的任务执行情况，处理复杂的蓝牙流程操作
#import <Foundation/Foundation.h>
#import "EasyDefine.h"

@interface EasyRhythm : NSObject

typedef void (^EYBeatsBreakBlock)(EasyRhythm *bry);
typedef void (^EYBeatsOverBlock)(EasyRhythm *bry);

//timer for beats
@property (nonatomic, strong) NSTimer *beatsTimer;

//beat interval
@property (nonatomic, assign) NSInteger beatsInterval;

#pragma mark beats
/// 心跳
- (void)beats;
/// 主动中断心跳
- (void)beatsBreak;
/// 结束心跳，结束后会进入BlockOnBeatOver，并且结束后再不会在触发BlockOnBeatBreak
- (void)beatsOver;
/// 恢复心跳，beatsOver操作后可以使用beatsRestart恢复心跳，恢复后又可以进入BlockOnBeatBreak方法
- (void)beatsRestart;

/// 心跳中断的委托
- (void)setBlockOnBeatsBreak:(EYBeatsBreakBlock)block;
/// 心跳结束的委托
- (void)setBlockOnBeatsOver:(EYBeatsOverBlock)block;

@end
