//
//  Reachability.h
//  Qwyvr
//
//  Created by ravi pitapurapu on 9/12/14.
//  Copyright (c) 2014 Qwyvr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reachability : NSObject

+ (void)monitorNetworkAndPostReachablityNotification;

@end
