
#import <CoreBluetooth/CoreBluetooth.h>
#import <objc/runtime.h>

@interface CBPeripheral (RSSI)

@property(nonatomic,strong) NSNumber *rssi;

@end
