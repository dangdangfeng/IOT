#import "EasyRhythm.h"
#import "EasyDefine.h"
#import "NSTimer+Add.h"

@interface EasyRhythm ()
@property (nonatomic, assign) BOOL isOver;
@property (nonatomic, copy) EYBeatsBreakBlock blockOnBeatBreak;
@property (nonatomic, copy) EYBeatsOverBlock blockOnBeatOver;
@end

@implementation EasyRhythm

- (instancetype)init {
    self = [super init];
    if (self) {
        _beatsInterval = KEASYRHYTHM_BEATS_DEFAULT_INTERVAL;
    }
    return  self;
}

- (void)beats {
    if (_isOver) {
        EasyLog(@">>>beats isOver");
        return;
    }

    EasyLog(@">>>beats at :%@",[NSDate date]);
    if (self.beatsTimer) {
        [self.beatsTimer setFireDate: [[NSDate date] dateByAddingTimeInterval:self.beatsInterval]];
    }else {
        __weak __typeof(self) weakSelf = self;
        self.beatsTimer = [NSTimer safe_timerWithTimeInterval:self.beatsInterval block:^{
            [weakSelf beatsBreak];
        } repeats:YES];
        [self.beatsTimer setFireDate: [[NSDate date] dateByAddingTimeInterval:self.beatsInterval]];
        [[NSRunLoop currentRunLoop] addTimer:self.beatsTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)beatsBreak {
    EasyLog(@">>>beatsBreak :%@",[NSDate date]);
    [self.beatsTimer setFireDate:[NSDate distantFuture]];// 随机返回一个比较遥远的未来时间
    if (self.blockOnBeatBreak) {
        self.blockOnBeatBreak(self);
    }
}

- (void)beatsOver {
    EasyLog(@">>>beatsOver :%@",[NSDate date]);
    [self.beatsTimer setFireDate:[NSDate distantFuture]];
    self.isOver = YES;
    if (self.blockOnBeatOver) {
        self.blockOnBeatOver(self);
    }
}

- (void)beatsRestart {
    EasyLog(@">>>beatsRestart :%@",[NSDate date]);
    self.isOver = NO;
    [self beats];
}

- (void)setBlockOnBeatsBreak:(void(^)(EasyRhythm *bry))block {
    self.blockOnBeatBreak = block;
}

- (void)setBlockOnBeatsOver:(void(^)(EasyRhythm *bry))block {
    self.blockOnBeatOver = block;
}

@end
