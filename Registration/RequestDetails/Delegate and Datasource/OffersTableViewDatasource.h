//
//  RequestDetailTableDatasource.h
//  Neighbour
//
//  Created by bkongara on 9/11/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestDetailViewController.h"
#import "JobDetailViewController.h"

@interface OffersTableViewDatasource : NSObject<UITableViewDataSource>

@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;
@property (nonatomic,strong)  JobDetailViewController *jobDetailViewController;
@property (nonatomic,strong) UITableView *offersTableView;
@property (nonatomic,strong) UIView *noBidsView;


@end
