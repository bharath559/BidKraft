//
//  JobDetailViewController.h
//  BidKraft
//
//  Created by Bharath Kongara on 4/13/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorSearchTableViewController.h"

@interface JobDetailViewController : UIViewController

@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,strong) VendorSearchTableViewController *vendorSearchViewController;

@end
