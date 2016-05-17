//
//  User.h
//  Neighbour
//
//  Created by Bharath kongara on 9/15/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserRequests.h"

typedef NS_ENUM(NSInteger, RequestMode) {
    OpenMode,
    ActiveMode,
    CompletedMode
};

@interface User : NSObject

@property (nonatomic,strong)  NSMutableArray *usrRequests;
@property (nonatomic,strong) UserRequests *usrRequest;
@property (nonatomic,assign) BOOL isRequestViewShown;
@property (nonatomic,strong) NSString *roleId;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,assign) BOOL isVendorViewShown;
@property (nonatomic,strong) NSMutableArray *userAcceptedRequests;
@property (nonatomic,strong) NSMutableArray *userCompletedRequests;
@property (nonatomic,strong) NSMutableArray *userOpenRequests;
@property (nonatomic,strong) NSMutableArray *searchResults;

@property (nonatomic,strong) NSIndexPath *paymentCellIndexPath;

@property (nonatomic,assign) BOOL isActiveRequestMode;
@property (nonatomic,assign) BOOL isPaymentCellDown;
@property (nonatomic,assign) BOOL reloadingAfterPayments;
@property (nonatomic,assign) BOOL reloadingAfterPost;


@property float ratingCount;
@property (nonatomic,strong) NSString *paymentPayPalValue;
@property (nonatomic,strong) NSString *shortDescription;
@property (nonatomic,assign) RequestMode userRequestMode;
@property (nonatomic, strong) NSData *notificationToken;
@property (nonatomic,strong) NSString *badgeCount;
@property (nonatomic,strong) NSString *userSettingId;
@property (nonatomic,strong) NSString *requesterRadius;
@property (nonatomic,strong) NSString *lattitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *homeAddress;
@property (nonatomic,strong) NSString *userAddressId;


@property  BOOL isVendor;


+ (User *)sharedData;

-(void) saveUserData:(NSDictionary *) response;
- (void)saveUserId:(NSString *)userId;
//- (void)saveRoleId:(NSString *)roleId;
-(void) saveUserOpenRequestsData:(NSMutableArray *) responseData;
-(void) saveUserAcceptedRequestsData:(NSMutableArray *) responseData;
-(void) saveUserCompletedRequestsData:(NSMutableArray *) responseData;
- (void)saveBadgeCount:(NSString *)badgeCount;
//- (void)saveDeviceIdentifier:(NSData *)identifier;
- (void)saveUserSettingId:(NSString *)settingsId;
- (void)saveRequesterRadius:(NSString *)radius;
- (void)saveUserLattitude:(NSString *)lattitude;
- (void)saveUserLongitude:(NSString *)longitude;
- (void)saveUserHomeAddress:(NSString *)homeAddress;
- (void)saveUserAddressId:(NSString *)userAddressId;



@end
