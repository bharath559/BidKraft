//
//  Reachability.m
//  Qwyvr
//
//  Created by ravi pitapurapu on 9/12/14.
//  Copyright (c) 2014 Qwyvr. All rights reserved.
//

#import "Reachability.h"

#import "AFHTTPRequestOperationManager.h"
#import "SystemLevelConstants.h"


@implementation Reachability

+ (void)monitorNetworkAndPostReachablityNotification
{
    NSURL *baseURL = [NSURL URLWithString:@"http://www.BidKraft.com/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [operationQueue setSuspended:NO];
                NSLog(@"Network Reachable via WWAN");
                break;

            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                NSLog(@"Network Reachable via WiFi");
                break;

            case AFNetworkReachabilityStatusNotReachable:
                [operationQueue setSuspended:YES];
                NSLog(@"Network Not Reachable");
                dispatch_async(dispatch_get_main_queue(),^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityStatus_NoNetwork object:nil];
                });
                break;

            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}

@end
