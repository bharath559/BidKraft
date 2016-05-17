//
//  PaymentTableViewCell.h
//  Neighbour
//
//  Created by Raghav Sai on 11/9/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASStarRatingView.h"

@interface PaymentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnPayWithPayPal;

@end
