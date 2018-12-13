// 预定义一些库的执行行为和配置

#import <Foundation/Foundation.h>

# pragma mark - easy 行为定义

//Easy if show log 是否打印日志，默认1：打印 ，0：不打印
#define KEASY_IS_SHOW_LOG 1

//CBcentralManager等待设备打开次数
# define KEASY_CENTRAL_MANAGER_INIT_WAIT_TIMES 5

//CBcentralManager等待设备打开间隔时间
# define KEASY_CENTRAL_MANAGER_INIT_WAIT_SECOND 2.0

//EasyRhythm默认心跳时间间隔
#define KEASYRHYTHM_BEATS_DEFAULT_INTERVAL 3;

//Easy默认链式方法channel名称
#define KEASY_DETAULT_CHANNEL @"easyDefault"

# pragma mark - easy通知

//蓝牙系统通知
//centralManager status did change notification
#define EasyNotificationAtCentralManagerDidUpdateState @"EasyNotificationAtCentralManagerDidUpdateState"
//did discover peripheral notification
#define EasyNotificationAtDidDiscoverPeripheral @"EasyNotificationAtDidDiscoverPeripheral"
//did connection peripheral notification
#define EasyNotificationAtDidConnectPeripheral @"EasyNotificationAtDidConnectPeripheral"
//did filed connect peripheral notification
#define EasyNotificationAtDidFailToConnectPeripheral @"EasyNotificationAtDidFailToConnectPeripheral"
//did disconnect peripheral notification
#define EasyNotificationAtDidDisconnectPeripheral @"EasyNotificationAtDidDisconnectPeripheral"
//did discover service notification
#define EasyNotificationAtDidDiscoverServices @"EasyNotificationAtDidDiscoverServices"
//did discover characteristics notification
#define EasyNotificationAtDidDiscoverCharacteristicsForService @"EasyNotificationAtDidDiscoverCharacteristicsForService"
//did read or notify characteristic when received value  notification
#define EasyNotificationAtDidUpdateValueForCharacteristic @"EasyNotificationAtDidUpdateValueForCharacteristic"
//did write characteristic and response value notification
#define EasyNotificationAtDidWriteValueForCharacteristic @"EasyNotificationAtDidWriteValueForCharacteristic"
//did change characteristis notify status notification
#define EasyNotificationAtDidUpdateNotificationStateForCharacteristic @"EasyNotificationAtDidUpdateNotificationStateForCharacteristic"
//did read rssi and receiced value notification
#define EasyNotificationAtDidReadRSSI @"EasyNotificationAtDidReadRSSI"

//蓝牙扩展通知
// did centralManager enable notification
#define EasyNotificationAtCentralManagerEnable @"EasyNotificationAtCentralManagerEnable"

# pragma mark - easy 定义的方法

//Easy log
#define EasyLog(fmt, ...) if(KEASY_IS_SHOW_LOG) { NSLog(fmt,##__VA_ARGS__); }

