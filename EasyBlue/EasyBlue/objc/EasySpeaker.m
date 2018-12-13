
#import "EasySpeaker.h"
#import "EasyDefine.h"

typedef NS_ENUM(NSUInteger, EasySpeakerType) {
    EasySpeakerTypeDiscoverPeripherals,
    EasySpeakerTypeConnectedPeripheral,
    EasySpeakerTypeDiscoverPeripheralsFailToConnect,
    EasySpeakerTypeDiscoverPeripheralsDisconnect,
    EasySpeakerTypeDiscoverPeripheralsDiscoverServices,
    EasySpeakerTypeDiscoverPeripheralsDiscoverCharacteristics,
    EasySpeakerTypeDiscoverPeripheralsReadValueForCharacteristic,
    EasySpeakerTypeDiscoverPeripheralsDiscoverDescriptorsForCharacteristic,
    EasySpeakerTypeDiscoverPeripheralsReadValueForDescriptorsBlock
};

@implementation EasySpeaker {
    //所有委托频道
    NSMutableDictionary *channels;
    //当前委托频道
    NSString *currChannel;
    //notifyList
    NSMutableDictionary *notifyList;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        EasyCallback *defaultCallback = [[EasyCallback alloc]init];
        notifyList = [[NSMutableDictionary alloc]init];
        channels = [[NSMutableDictionary alloc]init];
        currChannel = KEASY_DETAULT_CHANNEL;
        [channels setObject:defaultCallback forKey:KEASY_DETAULT_CHANNEL];
    }
    return self;
}

- (EasyCallback *)callback {
    return [channels objectForKey:KEASY_DETAULT_CHANNEL];
}

- (EasyCallback *)callbackOnCurrChannel {
    return [self callbackOnChnnel:currChannel];
}

- (EasyCallback *)callbackOnChnnel:(NSString *)channel {
    if (!channel) {
        [self callback];
    }
    return [channels objectForKey:channel];
}

- (EasyCallback *)callbackOnChnnel:(NSString *)channel
               createWhenNotExist:(BOOL)createWhenNotExist {
    EasyCallback *callback = [channels objectForKey:channel];
    if (!callback && createWhenNotExist) {
        callback = [[EasyCallback alloc] init];
        [channels setObject:callback forKey:channel];
    }
    
    return callback;
}

- (void)switchChannel:(NSString *)channel {
    if (channel) {
        if ([self callbackOnChnnel:channel]) {
            currChannel = channel;
            EasyLog(@">>>已切换到%@",channel);
        }else {
            EasyLog(@">>>所要切换的channel不存在");
        }
    }else {
        currChannel = KEASY_DETAULT_CHANNEL;
            EasyLog(@">>>已切换到默认频道");
    }
}

//添加到notify list
- (void)addNotifyCallback:(CBCharacteristic *)c
           withBlock:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    [notifyList setObject:block forKey:c.UUID.description];
}

//添加到notify list
- (void)removeNotifyCallback:(CBCharacteristic *)c {
    [notifyList removeObjectForKey:c.UUID.description];
}

//获取notify list
- (NSMutableDictionary *)notifyCallBackList {
    return notifyList;
}

//获取notityBlock
- (void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))notifyCallback:(CBCharacteristic *)c {
    return [notifyList objectForKey:c.UUID.description];
}
@end
