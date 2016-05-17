//
//  VendorData.h
//  Neighbour
//
//  Created by Bharath kongara on 10/6/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VendorBidDetail.h"
#import "VendorBidRequest.h"
#import "User.h"

typedef NS_ENUM(NSInteger, VendorMode) {
    VendorOpenMode,
    VendorPlacedBidsMode,
    VendorBidsOwnMode
};

@interface VendorData : NSObject

@property (nonatomic,strong) NSMutableArray *vendorBids;
@property (nonatomic,strong) NSMutableArray *vendorOpenRequests;
@property (nonatomic,strong) NSMutableArray *vendorOwnBids;
@property (nonatomic,assign) BOOL isRequestViewShown;
@property (nonatomic,strong) VendorBidDetail *vendorBidDetail;
@property (nonatomic,strong) VendorBidRequest *vendorBidRequest;
@property (nonatomic,strong) BidDetails *vendorOpenBid;
@property (nonatomic,strong) UserRequests *usrRequest;
@property (nonatomic,assign) VendorMode vendorRequestMode;


@property (nonatomic,strong) NSString *userSettingId;
@property (nonatomic,strong) NSString *vendorRadius;
@property (nonatomic,strong) NSMutableArray *vendorCategories;
@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, assign) BOOL reloadingAfterBidPlaced;

+ (VendorData *)sharedData;
-(void) saveVendorData:(NSMutableArray *) responseData;
-(void) saveEachVendorOpenRequestData:(NSMutableArray *) responseArray;
-(void) saveVendorOwnBidsData:(NSMutableArray *) responseData;
-(void) saveVendorSettingsId:(NSString *) settingsId;
-(void) saveVendorRadius:(NSString *) radius;
-(void) saveVendorCategories:(NSMutableArray *) categories;

@end
