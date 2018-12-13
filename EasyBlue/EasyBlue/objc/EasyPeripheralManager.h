// 蓝牙外设模式实现类
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyToy.h"
#import "EasySpeaker.h"

@interface EasyPeripheralManager : NSObject<CBPeripheralManagerDelegate> {
    @public
    //回叫方法
    EasySpeaker *easySpeaker;
}

/// 外设管理器
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
/// 设备名称
@property (nonatomic, copy) NSString *localName;
/// 设备服务
@property (nonatomic, strong) NSMutableArray *services;
/// 设备广播包数据
@property (nonatomic, strong) NSData *manufacturerData;

/// 添加服务
- (EasyPeripheralManager *(^)(NSArray *array))addServices;
/// 添加广播包数据
- (EasyPeripheralManager *(^)(NSData *data))addManufacturerData;
/// 移除广播包数据
- (EasyPeripheralManager *(^)(void))removeAllServices;
/// 启动广播
- (EasyPeripheralManager *(^)(void))startAdvertising;
/// 停止广播
- (EasyPeripheralManager *(^)(void))stopAdvertising;

@end

