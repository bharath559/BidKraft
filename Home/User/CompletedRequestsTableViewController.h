//
//  CompletedRequestsTableView.h
//  Neighbour
//
//  Created by Raghav Sai on 12/2/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RequestTableViewCell.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "HomeViewController.h"

@interface CompletedRequestsTableViewController : UITableViewController

@property (nonatomic , strong) HomeViewController *homeViewController;
@property (nonatomic , weak) UIView *userHeaderView;
@property (nonatomic, strong) UISearchController *searchController;


@end
