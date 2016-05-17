//
//  PayListViewController.h
//  BidKraft
//
//  Created by Raghav Sai on 4/1/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@protocol RatingViewProtocal <NSObject>

-(void) showRatingView;

@end

@interface PayListViewController : UIViewController

@property (nonatomic, assign) float bidAmount;
@property (nonatomic, strong) NSString *payTo;
@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *bidId;
@property (nonatomic, strong) NSString *requestIdToBeDeleted;

@property (nonatomic,strong) HomeViewController *homeViewController;
@property (nonatomic,strong) id<RatingViewProtocal> ratingViewDelegate;

@end
