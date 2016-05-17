

#import <UIKit/UIKit.h>
#import "VendorTableViewCell.h"


@protocol VendorOpenRequestsProtocol <NSObject>

-(void)getCellData:(NSString *)requestDate withRequestDesc:(NSString *)requestDescription withRequestID:(NSInteger)requestID onCellData:(VendorTableViewCell *) cell;

@end

@interface VendorOpenRequestsTableViewController : UITableViewController

@property (nonatomic,strong) id<VendorOpenRequestsProtocol> vendorOpenRequestsNavControlDelegate;

@end
