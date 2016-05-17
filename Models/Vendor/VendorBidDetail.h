//
//  VendorBidDetail.h
//  Neighbour
//
//  Created by Bharath kongara on 10/6/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VendorBidDetail : NSObject

@property (nonatomic,assign) float bidAmount;
@property (nonatomic,assign) NSInteger bidId;
@property (nonatomic,strong) NSString *bidPlacedDate;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *offererName;
@property (nonatomic,strong) NSString * offererId;
@property (nonatomic,strong) NSString *offererRating;


@end
