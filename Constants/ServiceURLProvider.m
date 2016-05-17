//
//  ServiceURLProvider.m
//  Qwyvr
//
//  Created by ravi pitapurapu on 9/13/14.
//  Copyright (c) 2014 Qwyvr. All rights reserved.
//

#import "ServiceURLProvider.h"

#define base_url @"http://rikers.cs.odu.edu:8080/bidding/"
#define aws_url  @"http://54.88.17.100:8080/bidding/"
#define test_aws_url  @"http://128.82.5.42:8080/bidding/"

@interface ServiceURLProvider ()


@end

@implementation ServiceURLProvider

+(NSString *)getURLForServiceWithKey:(NSString *)key
{
    NSString *returnString = [NSString stringWithFormat:@"%@%@",aws_url,key];
    return returnString;
}

@end
