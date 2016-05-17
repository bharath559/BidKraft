//
//  VendorSearchTableViewController.h
//  Neighbour
//
//  Created by ravi pitapurapu on 12/2/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorViewController.h"

@interface VendorSearchTableViewController : UITableViewController<UISearchResultsUpdating,UITableViewDelegate>
@property (nonatomic,strong) VendorViewController *homeController;

@end
