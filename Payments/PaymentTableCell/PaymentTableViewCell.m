//
//  PaymentTableViewCell.m
//  Neighbour
//
//  Created by Raghav Sai on 11/9/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "PaymentTableViewCell.h"
#import "ASStarRatingView.h"

@interface PaymentTableViewCell ()




@end

@implementation PaymentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.btnPayWithPayPal.layer.cornerRadius=10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
