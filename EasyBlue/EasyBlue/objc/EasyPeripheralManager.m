
#import "EasyPeripheralManager.h"
#import "EasyDefine.h"
#import "NSTimer+Add.h"

#define callbackBlock(...) if ([[easySpeaker callback] __VA_ARGS__])   [[easySpeaker callback] __VA_ARGS__ ]

@interface EasyPeripheralManager ()
@property (nonatomic, assign) NSInteger PERIPHERAL_MANAGER_INIT_WAIT_TIMES;
@property (nonatomic, assign) NSInteger didAddServices;
@property (nonatomic, strong) NSTimer *addServiceTask;
@end

@implementation EasyPeripheralManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _localName = @"easy-default-name";
        _peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil options:nil];
    }
    return  self;    
}


- (EasyPeripheralManager *(^)(void))startAdvertising {
    __weak __typeof(self) weakSelf = self;
    return ^EasyPeripheralManager *() {
        
        if ([self canStartAdvertising]) {
            weakSelf.PERIPHERAL_MANAGER_INIT_WAIT_TIMES = 0;
            NSMutableArray *UUIDS = [NSMutableArray array];
            for (CBMutableService *s in weakSelf.services) {
                [UUIDS addObject:s.UUID];
            }
            //启动广播
            if (weakSelf.manufacturerData) {
                [weakSelf.peripheralManager startAdvertising:
                 @{
                   CBAdvertisementDataServiceUUIDsKey :  UUIDS
                   ,CBAdvertisementDataLocalNameKey : weakSelf.localName,
                   CBAdvertisementDataManufacturerDataKey:weakSelf.manufacturerData
                }];
            } else {
                [weakSelf.peripheralManager startAdvertising:
                 @{
                   CBAdvertisementDataServiceUUIDsKey :  UUIDS
                   ,CBAdvertisementDataLocalNameKey : weakSelf.localName
                   }];
            }
          
        }
        else {
            weakSelf.PERIPHERAL_MANAGER_INIT_WAIT_TIMES++;
            if (weakSelf.PERIPHERAL_MANAGER_INIT_WAIT_TIMES > 5) {
                EasyLog(@">>>error： 第%tu次等待peripheralManager打开任然失败，请检查蓝牙设备是否可用",weakSelf.PERIPHERAL_MANAGER_INIT_WAIT_TIMES);
            }
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.startAdvertising();
            });
            EasyLog(@">>> 第%tu次等待peripheralManager打开",weakSelf.PERIPHERAL_MANAGER_INIT_WAIT_TIMES);
        }
        
        return self;
    };
}

- (EasyPeripheralManager *(^)(void))stopAdvertising {
    __weak __typeof(self) weakSelf = self;
    return ^EasyPeripheralManager*() {
        [weakSelf.peripheralManager stopAdvertising];
        return self;
    };
}

- (BOOL)canStartAdvertising {
    if (_peripheralManager.state != CBManagerStatePoweredOn) {
        return NO;
    }
    if (_didAddServices != _services.count) {
        return NO;
    }
    return YES;
}

- (BOOL)isPoweredOn {
    if (_peripheralManager.state != CBManagerStatePoweredOn) {
        return NO;
    }
    return YES;
}

- (EasyPeripheralManager *(^)(NSArray *array))addServices {
    __weak __typeof(self) weakSelf = self;
    return ^EasyPeripheralManager*(NSArray *array) {
        weakSelf.services = [NSMutableArray arrayWithArray:array];
        [self addServicesToPeripheral];
        return self;
    };
}

- (EasyPeripheralManager *(^)(void))removeAllServices {
    __weak __typeof(self) weakSelf = self;
    return ^EasyPeripheralManager*() {
        weakSelf.didAddServices = 0;
        [weakSelf.peripheralManager removeAllServices];
        return self;
    };
}

- (EasyPeripheralManager *(^)(NSData *data))addManufacturerData {
    __weak __typeof(self) weakSelf = self;
    return ^EasyPeripheralManager*(NSData *data) {
        weakSelf.manufacturerData = data;
        return self;
    };
}

- (void)addServicesToPeripheral {
    if ([self isPoweredOn]) {
        for (CBMutableService *s in _services) {
            [_peripheralManager addService:s];
        }
    }
    else {
        [self.addServiceTask setFireDate:[NSDate distantPast]];
        __weak __typeof(self) weakSelf = self;
        self.addServiceTask = [NSTimer safe_scheduledTimerWithTimeInterval:3 block:^{
            [weakSelf addServicesToPeripheral];
        } repeats:NO];
    }
}

#pragma mark - peripheralManager delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBManagerStateUnknown:
            EasyLog(@">>>CBPeripheralManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            EasyLog(@">>>CBPeripheralManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            EasyLog(@">>>CBPeripheralManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            EasyLog(@">>>CBPeripheralManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            EasyLog(@">>>CBPeripheralManagerStatePoweredOff");
            break;
        case CBManagerStatePoweredOn:
            EasyLog(@">>>CBPeripheralManagerStatePoweredOn");
            //发送centralManagerDidUpdateState通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CBPeripheralManagerStatePoweredOn" object:nil];
            break;
        default:
            break;
    }

//    if([easySpeaker callback] blockOnPeripheralModelDidUpdateState) {
//        [currChannel blockOnCancelScan](centralManager);
//    }
    callbackBlock(blockOnPeripheralModelDidUpdateState)(peripheral);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    _didAddServices++;
    callbackBlock(blockOnPeripheralModelDidAddService)(peripheral,service,error);
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    callbackBlock(blockOnPeripheralModelDidStartAdvertising)(peripheral,error);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    callbackBlock(blockOnPeripheralModelDidReceiveReadRequest)(peripheral, request);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests {
    callbackBlock(blockOnPeripheralModelDidReceiveWriteRequests)(peripheral,requests);
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    callbackBlock(blockOnPeripheralModelIsReadyToUpdateSubscribers)(peripheral);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    callbackBlock(blockOnPeripheralModelDidSubscribeToCharacteristic)(peripheral,central,characteristic);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    callbackBlock(blockOnPeripheralModelDidUnSubscribeToCharacteristic)(peripheral,central,characteristic);
}


@end

