//
//  CreateRequestViewController.h
//  Neighbour
//
//  Created by Bharath Kongara on 3/22/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "AMTagListView.h"


@interface CreateRequestViewController : UIViewController

@property (nonatomic,strong) NSString *categoryType;
@property (nonatomic,strong) NSString *categoryId;
@property (nonatomic,strong) HomeViewController *homeViewController;
@property (weak, nonatomic) IBOutlet AMTagListView *tagListView;

@end
