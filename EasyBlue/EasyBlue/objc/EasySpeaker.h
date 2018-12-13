// easybluetooth block查找和channel切换

#import "EasyCallback.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface EasySpeaker : NSObject

- (EasyCallback *)callback;
- (EasyCallback *)callbackOnCurrChannel;
- (EasyCallback *)callbackOnChnnel:(NSString *)channel;
- (EasyCallback *)callbackOnChnnel:(NSString *)channel
               createWhenNotExist:(BOOL)createWhenNotExist;

//切换频道
- (void)switchChannel:(NSString *)channel;

//添加到notify list
- (void)addNotifyCallback:(CBCharacteristic *)c
           withBlock:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block;

//添加到notify list
- (void)removeNotifyCallback:(CBCharacteristic *)c;

//获取notify list
- (NSMutableDictionary *)notifyCallBackList;

//获取notityBlock
- (void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))notifyCallback:(CBCharacteristic *)c;

@end
