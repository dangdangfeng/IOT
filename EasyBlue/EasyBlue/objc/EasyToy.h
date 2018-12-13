// easybluetooth 工具类

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface EasyToy : NSObject

/// 十六进制转换为普通字符串的
+ (NSString *)ConvertHexStringToString:(NSString *)hexString;

/// 普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string;

/// int转data
+(NSData *)ConvertIntToData:(int)i;

/// data转int
+(int)ConvertDataToInt:(NSData *)data;

/// 十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString;

///根据UUIDString查找CBCharacteristic
+ (CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
                                         UUIDString:(NSString *)UUIDString;
@end

/**
 *  构造Characteristic，并加入service
 *  service:CBService
 
 *  param`ter for properties ：option 'r' | 'w' | 'n' or combination
 *    r                       CBCharacteristicPropertyRead
 *    w                       CBCharacteristicPropertyWrite
 *    n                       CBCharacteristicPropertyNotify
 *  default value is rw     Read-Write
 
 *  paramter for descriptor：be uesd descriptor for characteristic
 */

void makeCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *properties,NSString *descriptor);

/**
 *  构造一个包含初始值的Characteristic，并加入service,包含了初值的characteristic必须设置permissions和properties都为只读
 *  make characteristic then add to service, a static characteristic mean it has a initial value .according apple rule, it must set properties and permissions to CBCharacteristicPropertyRead and CBAttributePermissionsReadable
 */
void makeStaticCharacteristicToService(CBMutableService *service,NSString *UUID,NSString *descriptor,NSData *data);
/**
 生成CBService
 */
CBMutableService *makeCBService(NSString *UUID);

/**
 生成UUID
 */
NSString *genUUID(void);
