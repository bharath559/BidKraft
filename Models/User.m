//
//  User.m
//  Neighbour
//
//  Created by Bharath kongara on 9/15/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "User.h"
#import "SystemLevelConstants.h"
@interface User()

@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation User


+ (User *)sharedData
{
    static User *userData;
    @synchronized(self)
    {
        if (!userData)
            userData = [[User alloc] init];
        return userData;
    }
}

- (NSUserDefaults *)defaults
{
    if(!_defaults)
        _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}

-(void) saveUserData:(NSDictionary *) responseData
{
    NSMutableDictionary *userData = [responseData valueForKey:@"data"];
    NSMutableArray *requestsArray = [userData valueForKey:@"requests"];
    self.usrRequests = [[NSMutableArray alloc] init];
    
    for( int i=0;i<requestsArray.count ;i++)
    {
        NSMutableDictionary *request = [requestsArray objectAtIndex:i];
        self.usrRequest = [self getRequests:request];
        NSMutableArray *bidDetails = [request valueForKey:@"bids"];
        self.usrRequest.bidsArray = [[NSMutableArray alloc] init];
        for(int j=0;j<bidDetails.count;j++)
        {
           NSMutableDictionary *eachBid = [bidDetails objectAtIndex:j];
            [self getBid:eachBid];
        }
        [self.usrRequests addObject:self.usrRequest];
    }
    NSLog(@"UserDetails %@",self.usrRequests);
}
-(void) saveUserOpenRequestsData:(NSMutableArray *) responseData
{
    
    self.userOpenRequests = [[NSMutableArray alloc] init];
    
    for( int i=0;i<responseData.count ;i++)
    {
        NSMutableDictionary *request = [responseData objectAtIndex:i];
        self.usrRequest = [self getRequests:request];
        NSMutableArray *bidDetails = [request valueForKey:@"bids"];
        self.usrRequest.bidsArray = [[NSMutableArray alloc] init];
        for(int j=0;j<bidDetails.count;j++)
        {
            NSMutableDictionary *eachBid = [bidDetails objectAtIndex:j];
            [self getBid:eachBid];
        }
        [self.userOpenRequests addObject:self.usrRequest];
    }
    NSLog(@"UserDetails %@",self.userOpenRequests);
}

-(void) saveUserAcceptedRequestsData:(NSMutableArray *) responseData
{
    
    self.userAcceptedRequests = [[NSMutableArray alloc] init];
    
    for( int i=0;i<responseData.count ;i++)
    {
        NSMutableDictionary *request = [responseData objectAtIndex:i];
        self.usrRequest = [self getRequests:request];
        NSMutableArray *bidDetails = [request valueForKey:@"bids"];
        self.usrRequest.bidsArray = [[NSMutableArray alloc] init];
        for(int j=0;j<bidDetails.count;j++)
        {
            NSMutableDictionary *eachBid = [bidDetails objectAtIndex:j];
            [self getBid:eachBid];
        }
        [self.userAcceptedRequests addObject:self.usrRequest];
    }
    NSLog(@"UserDetails %@",self.userAcceptedRequests);
}
-(void) saveUserCompletedRequestsData:(NSMutableArray *) responseData
{
    
    self.userCompletedRequests = [[NSMutableArray alloc] init];
    
    for( int i=0;i<responseData.count ;i++)
    {
        NSMutableDictionary *request = [responseData objectAtIndex:i];
        self.usrRequest = [self getRequests:request];
        NSMutableArray *bidDetails = [request valueForKey:@"bids"];
        self.usrRequest.bidsArray = [[NSMutableArray alloc] init];
        for(int j=0;j<bidDetails.count;j++)
        {
            NSMutableDictionary *eachBid = [bidDetails objectAtIndex:j];
            [self getBid:eachBid];
        }
        [self.userCompletedRequests addObject:self.usrRequest];
    }
    NSLog(@"UserDetails %@",self.userCompletedRequests);
}


-(UserRequests *) getRequests:(NSMutableDictionary *) request
{
    self.usrRequest = [[UserRequests alloc]init];
    self.usrRequest.requestCreatedDate = (NSDate *)[request objectForKey:@"createdDate"];
    self.usrRequest.bidEndDateTime = (NSDate *)[request objectForKey:@"bidEndDateTime"];
    self.usrRequest.acceptedBidId = (NSString *)[request objectForKey:@"acceptedBidId"];
    self.usrRequest.bidTimeLeft = [request objectForKey:@"bidTimeLeft"];

    self.usrRequest.userName = [request  objectForKey:@"requesterUserName"];
    self.usrRequest.jobTitle = [request objectForKey:@"jobTitle"];
    self.usrRequest.tags = (NSMutableArray *)[request objectForKey:@"tags"];
    self.usrRequest.requestStatus = [request objectForKey:@"requestStatus"];
    self.usrRequest.requestDescription = [request objectForKey:@"description"];
    self.usrRequest.requestId =[ [request objectForKey:@"requestId"] intValue];
    self.usrRequest.requestStartDate = (NSDate *)[request objectForKey:@"requestStartDate"];
    self.usrRequest.requestStartFromTime = [request objectForKey:@"requestStartTime"];
    self.usrRequest.categoryId = [(NSString *)[request objectForKey:@"categoryId"] integerValue];
     self.usrRequest.categoryName =[request objectForKey:@"categoryName"];
    self.usrRequest.lowestBid = [[request objectForKey:@"leastBidAmount"] floatValue];
    self.usrRequest.totalBids = [(NSString *)[request objectForKey:@"totalBids"] integerValue];

    return self.usrRequest;
}

-(BidDetails *)getBid:(NSMutableDictionary *) eachBid
{
    
    self.usrRequest.bidDetail = [[BidDetails alloc] init];
    self.usrRequest.bidDetail.bidCreatedDate = (NSDate *)[eachBid objectForKey:@"createdDate"];
    self.usrRequest.bidDetail.offererName = [eachBid objectForKey:@"offererName"];
    self.usrRequest.bidDetail.offererUserId = [eachBid objectForKey:@"offererUserId"];
    self.usrRequest.bidDetail.offererRating =  [eachBid objectForKey:@"offererRating"];
    self.usrRequest.bidDetail.userName = [eachBid objectForKey:@"userName"];
    self.usrRequest.bidDetail.bidId = [[eachBid objectForKey:@"bidId"] intValue];
    self.usrRequest.bidDetail.bidAmount = [[eachBid objectForKey:@"bidAmount"] floatValue];
    [self.usrRequest.bidsArray addObject:self.usrRequest.bidDetail];
    return self.usrRequest.bidDetail;
}

- (void)saveUserId:(NSString *)userId
{
    [self.defaults setObject:userId forKey:kUserID];
    self.userId = userId;
}

- (NSString *)userId
{
    if(!_userId)
    {
        NSString *uid = [self.defaults stringForKey:kUserID];
        if(uid)
            _userId = uid;
    }
    
    return _userId;
}

- (void)saveBadgeCount:(NSString *)badgeCount
{
    //[self.defaults setObject:badgeCount  forKey:kqwyvr_badgeCount];
    self.badgeCount = badgeCount;
}

- (void)saveUserSettingId:(NSString *)settingsId
{
    [self.defaults setObject:settingsId forKey:kNeighbor_userSettingId];
    self.userSettingId = settingsId;

}
- (NSString *)userSettingId
{
    if(!_userSettingId)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_userSettingId];
        if(uid)
            _userSettingId = uid;
    }
    
    return _userSettingId;
}
- (void)saveRequesterRadius:(NSString *)radius
{
    [self.defaults setObject:radius forKey:kNeighbor_userRadius];
    self.requesterRadius = radius;
}
- (NSString *)requesterRadius
{
    if(!_requesterRadius)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_userRadius];
        if(uid)
            _requesterRadius = uid;
    }
    
    return _requesterRadius;
}
- (void)saveUserLattitude:(NSString *)lattitude
{
    
}
- (void)saveUserLongitude:(NSString *)longitude
{
    
}
- (void)saveUserHomeAddress:(NSString *)homeAddress
{
    [self.defaults setObject:homeAddress forKey:kNeighbor_userHomeAddress];
    self.homeAddress = homeAddress;

}
- (NSString *)homeAddress
{
    if(!_homeAddress)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_userHomeAddress];
        if(uid)
            _homeAddress = uid;
    }
    
    return _homeAddress;
}

- (void)saveUserAddressId:(NSString *)userAddressId
{
    [self.defaults setObject:userAddressId forKey:kNeighbor_userAddressId];
    self.userAddressId = userAddressId;

}
- (NSString *)userAddressId
{
    if(!_userAddressId)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_userAddressId];
        if(uid)
            _userAddressId = uid;
    }
    
    return _userAddressId;
}


@end
