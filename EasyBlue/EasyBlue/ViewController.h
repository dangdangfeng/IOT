
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "EasyBluetooth.h"
#import "PeripheralViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

