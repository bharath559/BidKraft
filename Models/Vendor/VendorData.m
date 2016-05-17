//
//  VendorData.m
//  Neighbour
//
//  Created by Bharath kongara on 10/6/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "VendorData.h"
#import "BidDetails.h"
#import "SystemLevelConstants.h"

@implementation VendorData

+ (VendorData *)sharedData
{
    static VendorData *vendorData;
    @synchronized(self)
    {
        if (!vendorData)
            vendorData = [[VendorData alloc] init];
        return vendorData;
    }
}
- (NSUserDefaults *)defaults
{
    if(!_defaults)
        _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}

-(void) saveVendorData:(NSMutableArray *) responseData
{
  
    self.vendorBids = [[NSMutableArray alloc] init];

    for(int i=0;i<responseData.count;i++)
    {
        NSMutableDictionary *eachrequest = [responseData objectAtIndex:i];
       self.vendorBidRequest =  [self saveEachVendorData:eachrequest];
        [self.vendorBids addObject:self.vendorBidRequest];
    }
    NSLog(@"vendors Requests%@",self.vendorBids);
}

-(VendorBidRequest *) saveEachVendorData:(NSDictionary *) eachrequest
{
    NSDictionary *request = eachrequest;
    NSMutableArray *bidDetails = [eachrequest valueForKey:@"bids"];
    self.vendorBidRequest = [[VendorBidRequest alloc] init];
    self.vendorBidRequest.categoryId =[[request objectForKey:@"categoryId"] integerValue];
    self.vendorBidRequest.categoryName =[request objectForKey:@"categoryName"] ;
    self.vendorBidRequest.createdDate = [request objectForKey:@"createdDate"];
    self.vendorBidRequest.bidEndDateTime = (NSDate *)[request objectForKey:@"bidEndDateTime"];
    self.vendorBidRequest.jobTitle =[request objectForKey:@"jobTitle"];
    self.vendorBidRequest.tags = (NSMutableArray *)[request objectForKey:@"tags"];
    self.vendorBidRequest.userName = [request objectForKey:@"requesterUserName"];
    self.vendorBidRequest.requesterId = [request objectForKey:@"requesterUserId"];


    self.vendorBidRequest.requestDescription = [request objectForKey:@"description"];
    self.vendorBidRequest.requestStatus = [request objectForKey:@"requestStatus"];
    self.vendorBidRequest.leastBidAmount =[[request objectForKey:@"leastBidAmount"] integerValue];
    self.vendorBidRequest.numberOfHours =[[request objectForKey:@"numberOfHours"] integerValue];
    self.vendorBidRequest.requestId =[[request objectForKey:@"requestId"] integerValue];
    self.vendorBidRequest.requestStatusId =(NSInteger)[request objectForKey:@"requestStatusId "];
    self.vendorBidRequest.totalBids =[[request objectForKey:@"totalBids"] integerValue];
    self.vendorBidRequest.requestStartDate = [request objectForKey:@"requestStartDate"];
    self.vendorBidRequest.requestStartFromTime = [request objectForKey:@"requestStartTime"];
    
    [self saveVendorBid:bidDetails];
    
    return self.vendorBidRequest;
}

-(void ) saveVendorBid:(NSMutableArray *) bidDetails
{
    self.vendorBidRequest.bidsArray = [[NSMutableArray alloc] init];
   
    for(int i=0;i<bidDetails.count;i++)
    {
        self.vendorBidRequest.vendorPlacedBid = [[VendorBidDetail alloc] init];
        NSDictionary *bidDetail = [bidDetails objectAtIndex:i];
        self.vendorBidRequest.vendorPlacedBid .bidAmount = [[bidDetail objectForKey:@"bidAmount"] floatValue];
        self.vendorBidRequest.vendorPlacedBid .bidId = (NSInteger )[bidDetail objectForKey:@"offererUserId"];
        self.vendorBidRequest.vendorPlacedBid .offererName = [bidDetail objectForKey:@"userName"];
        self.vendorBidRequest.vendorPlacedBid .createdDate = [bidDetail objectForKey:@"createdDate"];
        [self.vendorBidRequest.bidsArray addObject:self.vendorBidRequest.vendorPlacedBid];
    }
   
}


-(void) saveEachVendorOpenRequestData:(NSMutableArray *) responseArray
{
    self.vendorOpenRequests = [[NSMutableArray alloc] init];
    for( int i=0;i<responseArray.count ;i++)
    {
        NSMutableDictionary *request = [responseArray objectAtIndex:i];
        self.vendorBidRequest = [self getRequests:request];
        NSMutableArray *bidDetails = [request valueForKey:@"bids"];
        self.vendorBidRequest.bidsArray = [[NSMutableArray alloc] init];
        [self saveVendorBid:bidDetails];
        [self.vendorOpenRequests addObject:self.vendorBidRequest];
    }
    NSLog(@"UserDetails %@",self.vendorOpenRequests);
}

-(VendorBidRequest *) getRequests:(NSMutableDictionary *) request
{
   
    self.vendorBidRequest = [[VendorBidRequest alloc] init];
    self.vendorBidRequest.categoryId =[[request objectForKey:@"categoryId"] integerValue];
     self.vendorBidRequest.categoryName =[request objectForKey:@"categoryName"] ;
    self.vendorBidRequest.createdDate = [request objectForKey:@"createdDate"];
    self.vendorBidRequest.requestDescription = [request objectForKey:@"description"];
    self.vendorBidRequest.userName = [request objectForKey:@"requesterUserName"];
    self.vendorBidRequest.requesterId = [request objectForKey:@"requesterUserId"];

    
    self.vendorBidRequest.bidEndDateTime = (NSDate *)[request objectForKey:@"bidEndDateTime"];
    self.vendorBidRequest.jobTitle = [request objectForKey:@"jobTitle"];
    self.vendorBidRequest.tags = (NSMutableArray *)[request objectForKey:@"tags"];

    self.vendorBidRequest.bidTimeLeft = [request objectForKey:@"bidTimeLeft"];

    self.vendorBidRequest.requestStatus = [request objectForKey:@"requestStatus"];
    self.vendorBidRequest.leastBidAmount =[[request objectForKey:@"leastBidAmount"] integerValue];
    self.vendorBidRequest.numberOfHours =[[request objectForKey:@"numberOfHours"] integerValue];
    self.vendorBidRequest.requestId =[[request objectForKey:@"requestId"] integerValue];
    self.vendorBidRequest.requestStatusId =(NSInteger)[request objectForKey:@"requestStatusId "];
    self.vendorBidRequest.totalBids =[[request objectForKey:@"totalBids"] integerValue];
    self.vendorBidRequest.requestStartDate = [request objectForKey:@"requestStartDate"];
    self.vendorBidRequest.requestStartFromTime = [request objectForKey:@"requestStartTime"];
    return self.vendorBidRequest;
}

-(BidDetails *)getBid:(NSMutableDictionary *) eachBid
{
    self.usrRequest.bidDetail = [[BidDetails alloc] init];
    self.usrRequest.bidDetail.bidCreatedDate = (NSDate *)[eachBid objectForKey:@"createdDate"];
    self.usrRequest.bidDetail.offererName = [eachBid objectForKey:@"offererName"];
    self.usrRequest.bidDetail.offererUserId = [eachBid objectForKey:@"offererUserId"];
    self.usrRequest.bidDetail.userName = [eachBid objectForKey:@"userName"];
    self.usrRequest.bidDetail.bidId = [[eachBid objectForKey:@"bidId"] intValue];
    self.usrRequest.bidDetail.bidAmount =[[eachBid objectForKey:@"bidAmount"] floatValue];
    [self.usrRequest.bidsArray addObject:self.usrRequest.bidDetail];
    return self.usrRequest.bidDetail;
}

-(void) saveVendorOwnBidsData:(NSMutableArray *) responseData
{
    
    self.vendorOwnBids = [[NSMutableArray alloc] init];
    
    for(int i=0;i<responseData.count;i++)
    {
        NSMutableDictionary *eachrequest = [responseData objectAtIndex:i];
        self.vendorBidRequest =  [self saveEachVendorData:eachrequest];
        [self.vendorOwnBids addObject:self.vendorBidRequest];
    }
    NSLog(@"vendors Requests%@",self.self.vendorOwnBids);
}

- (void)saveVendorSettingsId:(NSString *)settingsId
{
    [self.defaults setObject:settingsId forKey:kNeighbor_vendorSettingId];
    self.userSettingId = settingsId;
    
}
- (NSString *)userSettingId
{
    if(!_userSettingId)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_vendorSettingId];
        if(uid)
            _userSettingId = uid;
    }
    
    return _userSettingId;
}
- (void)saveVendorRadius:(NSString *)radius
{
    [self.defaults setObject:radius forKey:kNeighbor_vendorRadius];
    self.vendorRadius = radius;
}
- (NSString *)vendorRadius
{
    if(!_vendorRadius)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_vendorRadius];
        if(uid)
            _vendorRadius = uid;
    }
    
    return _vendorRadius;
}
- (void)saveVendorCategories:(NSMutableArray *)categories
{
    [self.defaults setObject:categories forKey:kNeighbor_vendorCategories];
    self.vendorCategories = categories;
}
- (NSMutableArray *)vendorCategories
{
    if(!_vendorCategories)
    {
        NSMutableArray *categoryArray = (NSMutableArray *)[self.defaults stringForKey:kNeighbor_vendorCategories];
        if(categoryArray)
            _vendorCategories = categoryArray;
    }
    
    return _vendorCategories;
}

@end
