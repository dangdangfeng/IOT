
#import "EasyBluetooth.h"
#import "NSTimer+Add.h"

@implementation EasyBluetooth{
    EasyCentralManager *easyCentralManager;
    EasyPeripheralManager *easyPeripheralManager;
    EasySpeaker *easySpeaker;
    int CENTRAL_MANAGER_INIT_WAIT_TIMES;
    NSTimer *timerForStop;
}

//单例模式
+ (instancetype)shareEasyBluetooth {
    static EasyBluetooth *share = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        share = [[EasyBluetooth alloc] init];
    });
   return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化对象
        easyCentralManager = [[EasyCentralManager alloc] init];
        easySpeaker = [[EasySpeaker alloc] init];
        easyCentralManager->easySpeaker = easySpeaker;
        
        easyPeripheralManager = [[EasyPeripheralManager alloc] init];
        easyPeripheralManager->easySpeaker = easySpeaker;
    }
    return self;
}

#pragma mark - easybluetooth的委托
/*
 默认频道的委托
 */
//设备状态改变的委托
- (void)setBlockOnCentralManagerDidUpdateState:(void (^)(CBCentralManager *central))block {
    [[easySpeaker callback] setBlockOnCentralManagerDidUpdateState:block];
}
//找到Peripherals的委托
- (void)setBlockOnDiscoverToPeripherals:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block{
    [[easySpeaker callback] setBlockOnDiscoverPeripherals:block];
}
//连接Peripherals成功的委托
- (void)setBlockOnConnected:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block {
    [[easySpeaker callback] setBlockOnConnectedPeripheral:block];
}
//连接Peripherals失败的委托
- (void)setBlockOnFailToConnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callback] setBlockOnFailToConnect:block];
}
//断开Peripherals的连接
- (void)setBlockOnDisconnect:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callback] setBlockOnDisconnect:block];
}
//设置查找服务回叫
- (void)setBlockOnDiscoverServices:(void (^)(CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callback] setBlockOnDiscoverServices:block];
}
//设置查找到Characteristics的block
- (void)setBlockOnDiscoverCharacteristics:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block {
    [[easySpeaker callback] setBlockOnDiscoverCharacteristics:block];
}
//设置获取到最新Characteristics值的block
- (void)setBlockOnReadValueForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callback] setBlockOnReadValueForCharacteristic:block];
}
//设置查找到Characteristics描述的block
- (void)setBlockOnDiscoverDescriptorsForCharacteristic:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block {
    [[easySpeaker callback] setBlockOnDiscoverDescriptorsForCharacteristic:block];
}
//设置读取到Characteristics描述的值的block
- (void)setBlockOnReadValueForDescriptors:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block {
    [[easySpeaker callback] setBlockOnReadValueForDescriptors:block];
}

//写Characteristic成功后的block
- (void)setBlockOnDidWriteValueForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callback] setBlockOnDidWriteValueForCharacteristic:block];
}
//写descriptor成功后的block
- (void)setBlockOnDidWriteValueForDescriptor:(void (^)(CBDescriptor *descriptor,NSError *error))block {
    [[easySpeaker callback] setBlockOnDidWriteValueForDescriptor:block];
}
//characteristic订阅状态改变的block
- (void)setBlockOnDidUpdateNotificationStateForCharacteristic:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callback] setBlockOnDidUpdateNotificationStateForCharacteristic:block];
}
//读取RSSI的委托
- (void)setBlockOnDidReadRSSI:(void (^)(NSNumber *RSSI,NSError *error))block {
    [[easySpeaker callback] setBlockOnDidReadRSSI:block];
}
//discoverIncludedServices的回调，暂时在easybluetooth中无作用
- (void)setBlockOnDidDiscoverIncludedServicesForService:(void (^)(CBService *service,NSError *error))block {
    [[easySpeaker callback] setBlockOnDidDiscoverIncludedServicesForService:block];
}
//外设更新名字后的block
- (void)setBlockOnDidUpdateName:(void (^)(CBPeripheral *peripheral))block {
    [[easySpeaker callback] setBlockOnDidUpdateName:block];
}
//外设更新服务后的block
- (void)setBlockOnDidModifyServices:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block {
    [[easySpeaker callback] setBlockOnDidModifyServices:block];
}

//设置蓝牙使用的参数参数
- (void)setEasyOptionsWithScanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
                          connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions
                        scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
                                  discoverWithServices:(NSArray *)discoverWithServices
                           discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics {
    EasyOptions *option = [[EasyOptions alloc] initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                                                        connectPeripheralWithOptions:connectPeripheralWithOptions
                                                      scanForPeripheralsWithServices:scanForPeripheralsWithServices
                                                                discoverWithServices:discoverWithServices
                                                         discoverWithCharacteristics:discoverWithCharacteristics];
    [[easySpeaker callback] setEasyOptions:option];
}

#pragma mark -  channel的委托

//设备状态改变的委托
- (void)setBlockOnCentralManagerDidUpdateStateAtChannel:(NSString *)channel
                                                 block:(void (^)(CBCentralManager *central))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCentralManagerDidUpdateState:block];
}

//找到Peripherals的委托
- (void)setBlockOnDiscoverToPeripheralsAtChannel:(NSString *)channel
                                          block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverPeripherals:block];
}

//连接Peripherals成功的委托
- (void)setBlockOnConnectedAtChannel:(NSString *)channel
                              block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnConnectedPeripheral:block];
}

//连接Peripherals失败的委托
- (void)setBlockOnFailToConnectAtChannel:(NSString *)channel
                                  block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnFailToConnect:block];
}

//断开Peripherals的连接
- (void)setBlockOnDisconnectAtChannel:(NSString *)channel
                               block:(void (^)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDisconnect:block];
}

//设置查找服务回叫
- (void)setBlockOnDiscoverServicesAtChannel:(NSString *)channel
                                     block:(void (^)(CBPeripheral *peripheral,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverServices:block];
}

//设置查找到Characteristics的block
- (void)setBlockOnDiscoverCharacteristicsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBService *service,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverCharacteristics:block];
}

//设置获取到最新Characteristics值的block
- (void)setBlockOnReadValueForCharacteristicAtChannel:(NSString *)channel
                                               block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForCharacteristic:block];
}

//设置查找到Characteristics描述的block
- (void)setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:(NSString *)channel
                                                         block:(void (^)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDiscoverDescriptorsForCharacteristic:block];
}

//设置读取到Characteristics描述的值的block
- (void)setBlockOnReadValueForDescriptorsAtChannel:(NSString *)channel
                                            block:(void (^)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnReadValueForDescriptors:block];
}

//写Characteristic成功后的block
- (void)setBlockOnDidWriteValueForCharacteristicAtChannel:(NSString *)channel
                                                        block:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidWriteValueForCharacteristic:block];
}

//写descriptor成功后的block
- (void)setBlockOnDidWriteValueForDescriptorAtChannel:(NSString *)channel
                                      block:(void (^)(CBDescriptor *descriptor,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidWriteValueForDescriptor:block];
}

//characteristic订阅状态改变的block
- (void)setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:(NSString *)channel
                                                                     block:(void (^)(CBCharacteristic *characteristic,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel
                createWhenNotExist:YES] setBlockOnDidUpdateNotificationStateForCharacteristic:block];
}

//读取RSSI的委托
- (void)setBlockOnDidReadRSSIAtChannel:(NSString *)channel
                                block:(void (^)(NSNumber *RSSI,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidReadRSSI:block];
}

//discoverIncludedServices的回调，暂时在easybluetooth中无作用
- (void)setBlockOnDidDiscoverIncludedServicesForServiceAtChannel:(NSString *)channel
                                                          block:(void (^)(CBService *service,NSError *error))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidDiscoverIncludedServicesForService:block];
}

//外设更新名字后的block
- (void)setBlockOnDidUpdateNameAtChannel:(NSString *)channel
                                  block:(void (^)(CBPeripheral *peripheral))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidUpdateName:block];
}

//外设更新服务后的block
- (void)setBlockOnDidModifyServicesAtChannel:(NSString *)channel
                                      block:(void (^)(CBPeripheral *peripheral,NSArray *invalidatedServices))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnDidModifyServices:block];
}

//设置蓝牙运行时的参数
- (void)setEasyOptionsAtChannel:(NSString *)channel
 scanForPeripheralsWithOptions:(NSDictionary *)scanForPeripheralsWithOptions
  connectPeripheralWithOptions:(NSDictionary *)connectPeripheralWithOptions
    scanForPeripheralsWithServices:(NSArray *)scanForPeripheralsWithServices
          discoverWithServices:(NSArray *)discoverWithServices
   discoverWithCharacteristics:(NSArray *)discoverWithCharacteristics {
    EasyOptions *option = [[EasyOptions alloc]initWithscanForPeripheralsWithOptions:scanForPeripheralsWithOptions
                                                       connectPeripheralWithOptions:connectPeripheralWithOptions
                                                     scanForPeripheralsWithServices:scanForPeripheralsWithServices
                                                               discoverWithServices:discoverWithServices
                                                        discoverWithCharacteristics:discoverWithCharacteristics];
     [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setEasyOptions:option];
}

#pragma mark - easybluetooth filter委托
//设置查找Peripherals的规则
- (void)setFilterOnDiscoverPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[easySpeaker callback] setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
- (void)setFilterOnConnectToPeripherals:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[easySpeaker callback] setFilterOnconnectToPeripherals:filter];
}
//设置查找Peripherals的规则
- (void)setFilterOnDiscoverPeripheralsAtChannel:(NSString *)channel
                                      filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnDiscoverPeripherals:filter];
}
//设置连接Peripherals的规则
- (void)setFilterOnConnectToPeripheralsAtChannel:(NSString *)channel
                                     filter:(BOOL (^)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI))filter {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setFilterOnconnectToPeripherals:filter];
}

#pragma mark - easybluetooth Special
//easyBluettooth cancelScan方法调用后的回调
- (void)setBlockOnCancelScanBlock:(void(^)(CBCentralManager *centralManager))block {
    [[easySpeaker callback] setBlockOnCancelScan:block];
}

//easyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
- (void)setBlockOnCancelAllPeripheralsConnectionBlock:(void(^)(CBCentralManager *centralManager))block{
    [[easySpeaker callback] setBlockOnCancelAllPeripheralsConnection:block];
}

//easyBluettooth cancelScan方法调用后的回调
- (void)setBlockOnCancelScanBlockAtChannel:(NSString *)channel
                                    block:(void(^)(CBCentralManager *centralManager))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelScan:block];
}

//easyBluettooth cancelAllPeripheralsConnectionBlock 方法调用后的回调
- (void)setBlockOnCancelAllPeripheralsConnectionBlockAtChannel:(NSString *)channel
                                                        block:(void(^)(CBCentralManager *centralManager))block {
    [[easySpeaker callbackOnChnnel:channel createWhenNotExist:YES] setBlockOnCancelAllPeripheralsConnection:block];
}

#pragma mark - 链式函数
//查找Peripherals
- (EasyBluetooth *(^)(void)) scanForPeripherals {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needScanForPeripherals"];
        return self;
    };
}

//连接Peripherals
- (EasyBluetooth *(^)(void)) connectToPeripherals {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needConnectPeripheral"];
        return self;
    };
}

//发现Services
- (EasyBluetooth *(^)(void)) discoverServices {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverServices"];
        return self;
    };
}

//获取Characteristics
- (EasyBluetooth *(^)(void)) discoverCharacteristics {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverCharacteristics"];
        return self;
    };
}

//更新Characteristics的值
- (EasyBluetooth *(^)(void)) readValueForCharacteristic {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needReadValueForCharacteristic"];
        return self;
    };
}

//设置查找到Descriptors名称的block
- (EasyBluetooth *(^)(void)) discoverDescriptorsForCharacteristic {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needDiscoverDescriptorsForCharacteristic"];
        return self;
    };
}

//设置读取到Descriptors值的block
- (EasyBluetooth *(^)(void)) readValueForDescriptors {
    return ^EasyBluetooth *() {
        [self->easyCentralManager->pocket setObject:@"YES" forKey:@"needReadValueForDescriptors"];
        return self;
    };
}

//开始并执行
- (EasyBluetooth *(^)(void)) begin {
    return ^EasyBluetooth *() {
        //取消未执行的stop定时任务
        [self->timerForStop invalidate];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self resetSeriseParmeter];
            //处理链式函数缓存的数据
            if ([[self->easyCentralManager->pocket valueForKey:@"needScanForPeripherals"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needScanForPeripherals = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needConnectPeripheral"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needConnectPeripheral = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needDiscoverServices"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needDiscoverServices = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needDiscoverCharacteristics"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needDiscoverCharacteristics = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needReadValueForCharacteristic"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needReadValueForCharacteristic = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needDiscoverDescriptorsForCharacteristic"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needDiscoverDescriptorsForCharacteristic = YES;
            }
            if ([[self->easyCentralManager->pocket valueForKey:@"needReadValueForDescriptors"] isEqualToString:@"YES"]) {
                self->easyCentralManager->needReadValueForDescriptors = YES;
            }
            //调整委托方法的channel，如果没设置默认为缺省频道
            NSString *channel = [self->easyCentralManager->pocket valueForKey:@"channel"];
            [self->easySpeaker switchChannel:channel];
            //缓存的peripheral
            CBPeripheral *cachedPeripheral = [self->easyCentralManager->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
            //校验series合法性
            [self validateProcess];
            //清空pocjet
            self->easyCentralManager->pocket = [[NSMutableDictionary alloc]init];
            //开始扫描或连接设备
            [self start:cachedPeripheral];
        });
        return self;
    };
}

//私有方法，扫描或连接设备
- (void)start:(CBPeripheral *)cachedPeripheral {
    if (easyCentralManager->centralManager.state == CBManagerStatePoweredOn) {
        CENTRAL_MANAGER_INIT_WAIT_TIMES = 0;
        //扫描后连接
        if (easyCentralManager->needScanForPeripherals) {
            //开始扫描peripherals
            [easyCentralManager scanPeripherals];
        }
        //直接连接
        else {
            if (cachedPeripheral) {
                [easyCentralManager connectToPeripheral:cachedPeripheral];
            }
        }
        return;
    }
    //尝试重新等待CBCentralManager打开
    CENTRAL_MANAGER_INIT_WAIT_TIMES ++;
    if (CENTRAL_MANAGER_INIT_WAIT_TIMES >= KEASY_CENTRAL_MANAGER_INIT_WAIT_TIMES ) {
        EasyLog(@">>> 第%d次等待CBCentralManager 打开任然失败，请检查你蓝牙使用权限或检查设备问题。",CENTRAL_MANAGER_INIT_WAIT_TIMES);
        return;
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, KEASY_CENTRAL_MANAGER_INIT_WAIT_SECOND * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self start:cachedPeripheral];
    });
    EasyLog(@">>> 第%d次等待CBCentralManager打开",CENTRAL_MANAGER_INIT_WAIT_TIMES);
}

//sec秒后停止
- (EasyBluetooth *(^)(int sec)) stop {
    __weak __typeof(self) weakSelf = self;
    return ^EasyBluetooth *(int sec) {
        EasyLog(@">>> stop in %d sec",sec);
        
        //听见定时器执行easyStop
        self->timerForStop = [NSTimer safe_timerWithTimeInterval:sec block:^{
            [weakSelf easyStop];
        } repeats:NO];
        [self->timerForStop setFireDate: [[NSDate date]dateByAddingTimeInterval:sec]];
        [[NSRunLoop currentRunLoop] addTimer:self->timerForStop forMode:NSRunLoopCommonModes];
        
        return self;
    };
}

//私有方法，停止扫描和断开连接，清空pocket
- (void)easyStop {
    EasyLog(@">>>did stop");
    [timerForStop invalidate];
    [self resetSeriseParmeter];
    easyCentralManager->pocket = [[NSMutableDictionary alloc]init];
    //停止扫描，断开连接
    [easyCentralManager cancelScan];
    [easyCentralManager cancelAllPeripheralsConnection];
}

//重置串行方法参数
- (void)resetSeriseParmeter {
    easyCentralManager->needScanForPeripherals = NO;
    easyCentralManager->needConnectPeripheral = NO;
    easyCentralManager->needDiscoverServices = NO;
    easyCentralManager->needDiscoverCharacteristics = NO;
    easyCentralManager->needReadValueForCharacteristic = NO;
    easyCentralManager->needDiscoverDescriptorsForCharacteristic = NO;
    easyCentralManager->needReadValueForDescriptors = NO;
}

//持有对象
- (EasyBluetooth *(^)(id obj)) having {
    return ^(id obj) {
        [self->easyCentralManager->pocket setObject:obj forKey:NSStringFromClass([obj class])];
        return self;
    };
}

//切换委托频道
- (EasyBluetooth *(^)(NSString *channel)) channel {
    return ^EasyBluetooth *(NSString *channel) {
        //先缓存数据，到begin方法统一处理
        [self->easyCentralManager->pocket setValue:channel forKey:@"channel"];
        return self;
    };
}

- (void)validateProcess {
    NSMutableArray *faildReason = [[NSMutableArray alloc]init];
    
    //规则：不执行discoverDescriptorsForCharacteristic()时，不能执行readValueForDescriptors()
    if (!easyCentralManager->needDiscoverDescriptorsForCharacteristic) {
        if (easyCentralManager->needReadValueForDescriptors) {
            [faildReason addObject:@"未执行discoverDescriptorsForCharacteristic()不能执行readValueForDescriptors()"];
        }
    }
    
    //规则：不执行discoverCharacteristics()时，不能执行readValueForCharacteristic()或者是discoverDescriptorsForCharacteristic()
    if (!easyCentralManager->needDiscoverCharacteristics) {
        if (easyCentralManager->needReadValueForCharacteristic||easyCentralManager->needDiscoverDescriptorsForCharacteristic) {
            [faildReason addObject:@"未执行discoverCharacteristics()不能执行readValueForCharacteristic()或discoverDescriptorsForCharacteristic()"];
        }
    }
    
    //规则： 不执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()
    if (!easyCentralManager->needDiscoverServices) {
        if (easyCentralManager->needDiscoverCharacteristics||easyCentralManager->needDiscoverDescriptorsForCharacteristic ||easyCentralManager->needReadValueForCharacteristic ||easyCentralManager->needReadValueForDescriptors) {
             [faildReason addObject:@"未执行discoverServices()不能执行discoverCharacteristics()、readValueForCharacteristic()、discoverDescriptorsForCharacteristic()、readValueForDescriptors()"];
        }
    }

    //规则：不执行connectToPeripherals()时，不能执行discoverServices()
    if(!easyCentralManager->needConnectPeripheral) {
        if (easyCentralManager->needDiscoverServices) {
             [faildReason addObject:@"未执行connectToPeripherals()不能执行discoverServices()"];
        }
    }
    
    //规则：不执行needScanForPeripherals()，那么执行connectToPeripheral()方法时必须用having(peripheral)传入peripheral实例
    if (!easyCentralManager->needScanForPeripherals) {
        CBPeripheral *peripheral = [easyCentralManager->pocket valueForKey:NSStringFromClass([CBPeripheral class])];
        if (!peripheral) {
            [faildReason addObject:@"若不执行scanForPeripherals()方法，则必须执行connectToPeripheral方法并且需要传入参数(CBPeripheral *)peripheral"];
        }
    }
    
    //抛出异常
    if ([faildReason lastObject]) {
        NSException *e = [NSException exceptionWithName:@"BadyBluetooth usage exception" reason:[faildReason lastObject]  userInfo:nil];
        @throw e;
    }
}

- (EasyBluetooth *) and {
    return self;
}
- (EasyBluetooth *) then {
    return self;
}
- (EasyBluetooth *) with {
    return self;
}

- (EasyBluetooth *(^)(int sec)) enjoy {
    return ^EasyBluetooth *(int sec) {
        self.connectToPeripherals().discoverServices().discoverCharacteristics()
        .readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
        return self;
    };
}

#pragma mark - 工具方法
//断开连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    [easyCentralManager cancelPeripheralConnection:peripheral];
}
//断开所有连接
- (void)cancelAllPeripheralsConnection {
    [easyCentralManager cancelAllPeripheralsConnection];
}
//停止扫描
- (void)cancelScan{
    [easyCentralManager cancelScan];
}
//读取Characteristic的详细信息
- (EasyBluetooth *(^)(CBPeripheral *peripheral,CBCharacteristic *characteristic)) characteristicDetails {
    //切换频道
    [easySpeaker switchChannel:[easyCentralManager->pocket valueForKey:@"channel"]];
    easyCentralManager->pocket = [[NSMutableDictionary alloc]init];
    
    return ^(CBPeripheral *peripheral,CBCharacteristic *characteristic) {
        //判断连接状态
        if (peripheral.state == CBPeripheralStateConnected) {
            self->easyCentralManager->oneReadValueForDescriptors = YES;
            [peripheral readValueForCharacteristic:characteristic];
            [peripheral discoverDescriptorsForCharacteristic:characteristic];
        }
        else {
            EasyLog(@"!!!设备当前处于非连接状态");
        }
        
        return self;
    };
}

- (void)notify:(CBPeripheral *)peripheral
characteristic:(CBCharacteristic *)characteristic
        block:(void(^)(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error))block {
    //设置通知
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    [easySpeaker addNotifyCallback:characteristic withBlock:block];
}

- (void)cancelNotify:(CBPeripheral *)peripheral
     characteristic:(CBCharacteristic *)characteristic {
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    [easySpeaker removeNotifyCallback:characteristic];
}

//获取当前连接的peripherals
- (NSArray *)findConnectedPeripherals {
     return [easyCentralManager findConnectedPeripherals];
}

//获取当前连接的peripheral
- (CBPeripheral *)findConnectedPeripheral:(NSString *)peripheralName {
     return [easyCentralManager findConnectedPeripheral:peripheralName];
}

//获取当前corebluetooth的centralManager对象
- (CBCentralManager *)centralManager {
    return easyCentralManager->centralManager;
}

/**
 添加断开自动重连的外设
 */
- (void)AutoReconnect:(CBPeripheral *)peripheral{
    [easyCentralManager sometimes_ever:peripheral];
}

/**
 删除断开自动重连的外设
 */
- (void)AutoReconnectCancel:(CBPeripheral *)peripheral{
    [easyCentralManager sometimes_never:peripheral];
}
 
- (CBPeripheral *)retrievePeripheralWithUUIDString:(NSString *)UUIDString {
    CBPeripheral *p = nil;
    @try {
        NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:UUIDString];
        p = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]][0];
    } @catch (NSException *exception) {
        EasyLog(@">>> retrievePeripheralWithUUIDString error:%@",exception)
    } @finally {
    }
    return p;
}

#pragma mark - peripheral model

//进入外设模式

- (CBPeripheralManager *)peripheralManager {
    return easyPeripheralManager.peripheralManager;
}

- (EasyPeripheralManager *(^)(void)) bePeripheral {
    return ^EasyPeripheralManager* () {
        return self->easyPeripheralManager;
    };
}
- (EasyPeripheralManager *(^)(NSString *localName)) bePeripheralWithName {
    return ^EasyPeripheralManager* (NSString *localName) {
        self->easyPeripheralManager.localName = localName;
        return self->easyPeripheralManager;
    };
}

- (void)peripheralModelBlockOnPeripheralManagerDidUpdateState:(void(^)(CBPeripheralManager *peripheral))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidUpdateState:block];
}
- (void)peripheralModelBlockOnDidAddService:(void(^)(CBPeripheralManager *peripheral,CBService *service,NSError *error))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidAddService:block];
}
- (void)peripheralModelBlockOnDidStartAdvertising:(void(^)(CBPeripheralManager *peripheral,NSError *error))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidStartAdvertising:block];
}
- (void)peripheralModelBlockOnDidReceiveReadRequest:(void(^)(CBPeripheralManager *peripheral,CBATTRequest *request))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidReceiveReadRequest:block];
}
- (void)peripheralModelBlockOnDidReceiveWriteRequests:(void(^)(CBPeripheralManager *peripheral,NSArray *requests))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidReceiveWriteRequests:block];
}
- (void)peripheralModelBlockOnIsReadyToUpdateSubscribers:(void(^)(CBPeripheralManager *peripheral))block {
    [[easySpeaker callback] setBlockOnPeripheralModelIsReadyToUpdateSubscribers:block];
}
- (void)peripheralModelBlockOnDidSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidSubscribeToCharacteristic:block];
}
- (void)peripheralModelBlockOnDidUnSubscribeToCharacteristic:(void(^)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic))block {
    [[easySpeaker callback] setBlockOnPeripheralModelDidUnSubscribeToCharacteristic:block];
}

@end


