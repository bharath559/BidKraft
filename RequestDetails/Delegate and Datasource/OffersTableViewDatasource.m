//
//  RequestDetailTableDatasource.m
//  Neighbour
//
//  Created by bkongara on 9/11/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "OffersTableViewDatasource.h"
#import "OffersTableViewCell.h"
#import "User.h"

@interface OffersTableViewDatasource ()
@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) NSMutableArray *bidDetails;
@property (nonatomic,strong) UserRequests *usrRequest;


@end
@implementation OffersTableViewDatasource

- (id)init
{
    self = [super init];
    if(self)
    {
        //Custom actions here
        [self prepareDataObjects];
    }
    
    return self;
}
-(void) prepareDataObjects
{
    User *user = [User sharedData];
    self.userRequests = user.usrRequests;
    
}

-(void) recognizeRequests
{
    for(int i=0;i<self.userRequests.count;i++)
    {
        self.usrRequest = [self.userRequests objectAtIndex:i];
        if( self.usrRequest.requestId == self.requestId)
        {
            self.bidDetails = self.usrRequest.bidsArray;
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self recognizeRequests];
    return self.bidDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"OffersTableCell";
    OffersTableViewCell *cell = (OffersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell prepareCellForTabelView:tableView atIndex:indexPath withBids:self.bidDetails];
    cell.btnAccept.tag = indexPath.row;
    BidDetails *requestBidDetail = [self.usrRequest.bidsArray objectAtIndex:indexPath.row];
    cell.bidId = requestBidDetail.bidId;
    cell.btnAccept.layer.cornerRadius = 4;
    return cell;
}


@end
