
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyBluetooth.h"
#import "PeripheralInfo.h"


@interface CharacteristicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
@public
    EasyBluetooth *easy;
    NSMutableArray *sect;
  __block  NSMutableArray *readValueArray;
  __block  NSMutableArray *descriptors;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBPeripheral *currPeripheral;

@end
