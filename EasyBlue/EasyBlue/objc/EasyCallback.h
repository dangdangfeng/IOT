
// @brief  easybluetooth 的block定义和储存


#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyOptions.h"

//设备状态改变的委托
typedef void (^EYCentralManagerDidUpdateStateBlock)(CBCentralManager *central);
//找到设备的委托
typedef void (^EYDiscoverPeripheralsBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSDictionary *advertisementData, NSNumber *RSSI);
//连接设备成功的block
typedef void (^EYConnectedPeripheralBlock)(CBCentralManager *central,CBPeripheral *peripheral);
//连接设备失败的block
typedef void (^EYFailToConnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//断开设备连接的bock
typedef void (^EYDisconnectBlock)(CBCentralManager *central,CBPeripheral *peripheral,NSError *error);
//找到服务的block
typedef void (^EYDiscoverServicesBlock)(CBPeripheral *peripheral,NSError *error);
//找到Characteristics的block
typedef void (^EYDiscoverCharacteristicsBlock)(CBPeripheral *peripheral,CBService *service,NSError *error);
//更新（获取）Characteristics的value的block
typedef void (^EYReadValueForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *characteristic,NSError *error);
//获取Characteristics的名称
typedef void (^EYDiscoverDescriptorsForCharacteristicBlock)(CBPeripheral *peripheral,CBCharacteristic *service,NSError *error);
//获取Descriptors的值
typedef void (^EYReadValueForDescriptorsBlock)(CBPeripheral *peripheral,CBDescriptor *descriptor,NSError *error);

//easyBluettooth cancelScanBlock方法调用后的回调
typedef void (^EYCancelScanBlock)(CBCentralManager *centralManager);
//easyBluettooth cancelAllPeripheralsConnection 方法调用后的回调
typedef void (^EYCancelAllPeripheralsConnectionBlock)(CBCentralManager *centralManager);

typedef void (^EYDidWriteValueForCharacteristicBlock)(CBCharacteristic *characteristic,NSError *error);
typedef void (^EYDidWriteValueForDescriptorBlock)(CBDescriptor *descriptor,NSError *error);

typedef void (^EYDidUpdateNotificationStateForCharacteristicBlock)(CBCharacteristic *characteristic,NSError *error);

typedef void (^EYDidReadRSSIBlock)(NSNumber *RSSI,NSError *error);

typedef void (^EYDidDiscoverIncludedServicesForServiceBlock)(CBService *service,NSError *error);

typedef void (^EYDidUpdateNameBlock)(CBPeripheral *peripheral);

typedef void (^EYDidModifyServicesBlock)(CBPeripheral *peripheral,NSArray *invalidatedServices);


//peripheral model
typedef void (^EYPeripheralModelDidUpdateState)(CBPeripheralManager *peripheral);
typedef void (^EYPeripheralModelDidAddService)(CBPeripheralManager *peripheral,CBService *service,NSError *error);
typedef void (^EYPeripheralModelDidStartAdvertising)(CBPeripheralManager *peripheral,NSError *error);
typedef void (^EYPeripheralModelDidReceiveReadRequest)(CBPeripheralManager *peripheral,CBATTRequest *request);
typedef void (^EYPeripheralModelDidReceiveWriteRequests)(CBPeripheralManager *peripheral,NSArray *requests);
typedef void (^EYPeripheralModelIsReadyToUpdateSubscribers)(CBPeripheralManager *peripheral);
typedef void (^EYPeripheralModelDidSubscribeToCharacteristic)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic);
typedef void (^EYPeripheralModelDidUnSubscribeToCharacteristic)(CBPeripheralManager *peripheral,CBCentral *central,CBCharacteristic *characteristic);

#pragma mark - EasyCallback
@interface EasyCallback : NSObject

#pragma mark - callback block
//设备状态改变的委托
@property (nonatomic, copy) EYCentralManagerDidUpdateStateBlock blockOnCentralManagerDidUpdateState;
//发现peripherals
@property (nonatomic, copy) EYDiscoverPeripheralsBlock blockOnDiscoverPeripherals;
//连接callback
@property (nonatomic, copy) EYConnectedPeripheralBlock blockOnConnectedPeripheral;
//连接设备失败的block
@property (nonatomic, copy) EYFailToConnectBlock blockOnFailToConnect;
//断开设备连接的bock
@property (nonatomic, copy) EYDisconnectBlock blockOnDisconnect;
 //发现services
@property (nonatomic, copy) EYDiscoverServicesBlock blockOnDiscoverServices;
//发现Characteristics
@property (nonatomic, copy) EYDiscoverCharacteristicsBlock blockOnDiscoverCharacteristics;
//发现更新Characteristics的
@property (nonatomic, copy) EYReadValueForCharacteristicBlock blockOnReadValueForCharacteristic;
//获取Characteristics的名称
@property (nonatomic, copy) EYDiscoverDescriptorsForCharacteristicBlock blockOnDiscoverDescriptorsForCharacteristic;
//获取Descriptors的值
@property (nonatomic, copy) EYReadValueForDescriptorsBlock blockOnReadValueForDescriptors;

@property (nonatomic, copy) EYDidWriteValueForCharacteristicBlock blockOnDidWriteValueForCharacteristic;

@property (nonatomic, copy) EYDidWriteValueForDescriptorBlock blockOnDidWriteValueForDescriptor;

@property (nonatomic, copy) EYDidUpdateNotificationStateForCharacteristicBlock blockOnDidUpdateNotificationStateForCharacteristic;

@property (nonatomic, copy) EYDidReadRSSIBlock blockOnDidReadRSSI;

@property (nonatomic, copy) EYDidDiscoverIncludedServicesForServiceBlock blockOnDidDiscoverIncludedServicesForService;

@property (nonatomic, copy) EYDidUpdateNameBlock blockOnDidUpdateName;

@property (nonatomic, copy) EYDidModifyServicesBlock blockOnDidModifyServices;

//easyBluettooth stopScan方法调用后的回调
@property(nonatomic, copy) EYCancelScanBlock blockOnCancelScan;
//easyBluettooth stopConnectAllPerihperals 方法调用后的回调
@property(nonatomic, copy) EYCancelAllPeripheralsConnectionBlock blockOnCancelAllPeripheralsConnection;
//easyBluettooth 蓝牙使用的参数参数
@property(nonatomic, strong) EasyOptions *easyOptions;


#pragma mark - 过滤器Filter
//发现peripherals规则
@property (nonatomic, copy) BOOL (^filterOnDiscoverPeripherals)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI);
//连接peripherals规则
@property (nonatomic, copy) BOOL (^filterOnconnectToPeripherals)(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI);

#pragma mark - peripheral model

//peripheral model

@property (nonatomic, copy) EYPeripheralModelDidUpdateState blockOnPeripheralModelDidUpdateState;
@property (nonatomic, copy) EYPeripheralModelDidAddService blockOnPeripheralModelDidAddService;
@property (nonatomic, copy) EYPeripheralModelDidStartAdvertising blockOnPeripheralModelDidStartAdvertising;
@property (nonatomic, copy) EYPeripheralModelDidReceiveReadRequest blockOnPeripheralModelDidReceiveReadRequest;
@property (nonatomic, copy) EYPeripheralModelDidReceiveWriteRequests blockOnPeripheralModelDidReceiveWriteRequests;
@property (nonatomic, copy) EYPeripheralModelIsReadyToUpdateSubscribers blockOnPeripheralModelIsReadyToUpdateSubscribers;
@property (nonatomic, copy) EYPeripheralModelDidSubscribeToCharacteristic blockOnPeripheralModelDidSubscribeToCharacteristic;
@property (nonatomic, copy) EYPeripheralModelDidUnSubscribeToCharacteristic blockOnPeripheralModelDidUnSubscribeToCharacteristic;

@end
