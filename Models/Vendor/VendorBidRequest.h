//
//  VendorBidRequest.h
//  Neighbour
//
//  Created by Bharath kongara on 10/6/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VendorBidDetail.h"
@interface VendorBidRequest : NSObject

@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) NSString *createdDate;
@property (nonatomic,strong) NSString *bidTimeLeft;

@property (nonatomic,strong) NSString *requestDescription;
@property (nonatomic,assign) NSInteger leastBidAmount;
@property (nonatomic,assign) NSInteger numberOfHours;
@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,assign) NSInteger totalBids;
@property (nonatomic,strong) NSString *requestStartDate;
@property (nonatomic,strong) NSString *requestStartFromTime;
@property (nonatomic,strong) NSString *requestStatus;
@property (nonatomic,assign) NSInteger requestStatusId;
@property (nonatomic,strong) VendorBidDetail *vendorPlacedBid;

@property (nonatomic,strong) NSMutableArray *bidsArray;
@property (nonatomic,strong) NSString *categoryName;

@property (nonatomic,strong) NSString *jobTitle;
@property (nonatomic,strong) NSMutableArray *tags;
@property (nonatomic,strong) NSDate *bidEndDateTime;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *requesterId;


@end
