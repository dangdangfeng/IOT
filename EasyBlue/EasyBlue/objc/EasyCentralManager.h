// 蓝牙中心模式实现类 

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyToy.h"
#import "EasySpeaker.h"
#import "EasyDefine.h"

@interface EasyCentralManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate> {
    @public
    //方法是否处理
    BOOL needScanForPeripherals;//是否扫描Peripherals
    BOOL needConnectPeripheral;//是否连接Peripherals
    BOOL needDiscoverServices;//是否发现Services
    BOOL needDiscoverCharacteristics;//是否获取Characteristics
    BOOL needReadValueForCharacteristic;//是否获取（更新）Characteristics的值
    BOOL needDiscoverDescriptorsForCharacteristic;//是否获取Characteristics的描述
    BOOL needReadValueForDescriptors;//是否获取Descriptors的值
    
    //一次性处理
    BOOL oneReadValueForDescriptors;
    
    //方法执行时间
    int executeTime;
    NSTimer *connectTimer;
    //pocket
    NSMutableDictionary *pocket;
    
    //主设备
    CBCentralManager *centralManager;
    //回叫方法
    EasySpeaker *easySpeaker;
}

//扫描Peripherals
- (void)scanPeripherals;
//连接Peripherals
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
//断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;
//断开所有已连接的设备
- (void)cancelAllPeripheralsConnection;
//停止扫描
- (void)cancelScan;

//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals;

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName;

/**
 sometimes ever，sometimes never.  相聚有时，后会无期
 
 this is center with peripheral's story
 **/

//sometimes ever：添加断开重连接的设备
-  (void)sometimes_ever:(CBPeripheral *)peripheral ;
//sometimes never：删除需要重连接的设备
-  (void)sometimes_never:(CBPeripheral *)peripheral ;

@end



