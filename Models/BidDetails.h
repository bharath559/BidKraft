//
//  BidDetails.h
//  Neighbour
//
//  Created by Bharath kongara on 9/15/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BidDetails : NSObject

@property (nonatomic,strong) NSDate *bidCreatedDate;
@property (nonatomic,strong) NSString *offererName;
@property (nonatomic,strong) NSString *bidTimeLeft;
@property (nonatomic,strong) NSString *offererUserId;
@property (nonatomic,strong) NSString *offererRating;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,assign) float bidAmount;
@property (nonatomic,assign) NSInteger bidId;
@property (nonatomic,assign) BOOL deleteBid;

@end
