
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"
#import "CharacteristicViewController.h"


@interface PeripheralViewController : UITableViewController{
    @public
    EasyBluetooth *easy;
}

@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;

@end
