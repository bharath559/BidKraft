//
//  ServiceURLProvider.h
//  Qwyvr
//
//  Created by ravi pitapurapu on 9/13/14.
//  Copyright (c) 2014 Qwyvr. All rights reserved.
//

#import <Foundation/Foundation.h>

////////////////////////////////////////////////////////////////////////
//                 Servie page keys                                  //
//////////////////////////////////////////////////////////////////////


#define kLoginServiceKey @"login"
#define kRegistrationKey @"signup"
#define kCreateRequestKey @"request/create"
#define kGetLatestRequestKey @"request/get"
#define kAcceptBidKey @"bid/accept"
#define kVendorBidsKey @"bid/my-bids"
#define kDeleteRequest @"request/delete"
#define kCreateBid @"bid/create"
#define kCompletedServiceKey @"request/status/update/serviced"
#define kDeleteBid @"bid/delete"
#define kUpdateProfile @"user/profile/update"
#define kUpdatePreferences @"user/setting/update"
#define kGetUserProfile @"user/get"
#define kSendCustomerSupport @"supportmessage/create"
#define kVendorRegister @"vendor/register"








////////////////////////////////////////////////////////////////////////
//                 End of Service Page keys                          //
//////////////////////////////////////////////////////////////////////

@interface ServiceURLProvider : NSObject

+(NSString *)getURLForServiceWithKey:(NSString *)key;

@end
