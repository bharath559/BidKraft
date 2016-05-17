

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "RequestTableViewCell.h"
#import "VendorTableViewCell.h"

@protocol VendorPlacedBidsProtocol <NSObject>

-(void)getCellDataPlacedBids:(NSString *)requestDate withRequestDesc:(NSString *)requestDescription onCellData:(VendorTableViewCell *) cell;

@end

@interface VendorPlacedBidsTableViewController : UITableViewController

@property (nonatomic,strong) HomeViewController *homeViewController;
@property (nonatomic,strong) id<VendorPlacedBidsProtocol> vendorPlacedBidsNavControlDelegate;

@end
