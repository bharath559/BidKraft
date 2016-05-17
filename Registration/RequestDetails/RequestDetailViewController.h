//
//  RequestDetailViewController.h
//  Neighbour
//
//  Created by bkongara on 9/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"
#import "OffersTableViewCell.h"
#import "ResultsSearchTableViewController.h"


@interface RequestDetailViewController : UIViewController <TPFloatRatingViewDelegate,UserProfileProtocol,PaymentProtocol>

@property (strong, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (assign,nonatomic) NSInteger requestId;
@property (nonatomic,strong) ResultsSearchTableViewController *resultsSearchController;

@end
