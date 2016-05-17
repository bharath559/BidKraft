//
//  ResultsSearchTableViewController.h
//  Neighbour
//
//  Created by ravi pitapurapu on 11/24/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface ResultsSearchTableViewController : UITableViewController<UITableViewDelegate,UISearchResultsUpdating>

@property (nonatomic,assign) BOOL isTableReload;
@property (nonatomic,strong) UIView *vendorHeaderView;
@property (nonatomic,assign) BOOL isvendorViewShown;
@property (nonatomic,assign) BOOL isPlacedBidsShown;
@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) HomeViewController *homeController;

@end
