//
//  OpenRequestsTableView.h
//  Neighbour
//
//  Created by Bharath Kongara on 11/29/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface OpenRequestsTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>

@property (nonatomic,strong) HomeViewController *homeViewController;
@property (nonatomic,strong) UIView *userHeaderView;
@property (nonatomic, strong) UISearchController *searchController;

@end
