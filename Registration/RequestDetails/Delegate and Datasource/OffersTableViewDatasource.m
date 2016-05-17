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
#import "VendorData.h"


@interface OffersTableViewDatasource ()
@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) NSMutableArray *bidDetails;
@property (nonatomic,strong) UserRequests *usrRequest;
@property (nonatomic,strong) VendorBidRequest *vendorRequest;

@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;

@end
@implementation OffersTableViewDatasource

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (VendorData *)vendorData
{
    if(!_vendorData)
        _vendorData = [VendorData sharedData];
    
    return _vendorData;
}


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
  
    self.userRequests = [[NSMutableArray alloc] init];
    
    if(!self.userData.isVendorViewShown)
    {
        if(self.userData.userRequestMode == OpenMode)
            self.userRequests = self.userData.userOpenRequests;
        else if(self.userData.userRequestMode == ActiveMode)
            self.userRequests = self.userData.userAcceptedRequests;
        else if(self.userData.userRequestMode == CompletedMode)
            self.userRequests = self.userData.userCompletedRequests;
    }
    else
    {
        if(self.vendorData.vendorRequestMode == VendorOpenMode)
            self.userRequests = self.vendorData.vendorOpenRequests;
        else if(self.vendorData.vendorRequestMode == VendorPlacedBidsMode)
            self.userRequests = self.vendorData.vendorBids;
    }
}

-(void) recognizeRequests
{
    
    for(int i=0;i<self.userRequests.count;i++)
    {
        if(!self.userData.isVendorViewShown)
        {
            self.usrRequest = [self.userRequests objectAtIndex:i];
            if( self.usrRequest.requestId == self.requestId)
            {
                self.bidDetails = self.usrRequest.bidsArray;
                break;
            }
        }
        else
        {
             self.vendorRequest = [self.userRequests objectAtIndex:i];
            if( self.vendorRequest.requestId == self.requestId)
            {
                self.bidDetails = self.vendorRequest.bidsArray;
                break;
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.bidDetails.count == 0)
    {
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        messageLabel.textColor = [UIColor redColor];
        messageLabel.text = @"No data is currently available";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        tableView.backgroundView = messageLabel;
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self prepareDataObjects];
    [self recognizeRequests];
    
    //self.noBidsView.alpha = 1;
    
    return self.bidDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"OffersTableCell";
   
    OffersTableViewCell *cell = (OffersTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.userProfileViewDelegate = self.requestDetailController;
    cell.paymentDetailsDelegate = self.requestDetailController;
    cell.requestId = self.requestId;
    
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    if(!self.userData.isVendorViewShown)
    {
        [cell prepareCellForTabelView:tableView atIndex:indexPath withBids:self.bidDetails];
        cell.btnAccept.tag = indexPath.row;
        BidDetails *requestBidDetail = [self.usrRequest.bidsArray objectAtIndex:indexPath.row];
        cell.bidId = requestBidDetail.bidId;
        cell.btnAccept.layer.cornerRadius = 4;
        cell.bidAmount =requestBidDetail.bidAmount;
        cell.ratingView.rating = [requestBidDetail.offererRating floatValue];
       // cell.ratingView.rating = requestBidDetail
        
        if(self.userData.userRequestMode == ActiveMode || self.userData.userRequestMode == CompletedMode)
            cell.btnAccept.alpha =0;
        return cell;
    }
    else
    {
        [cell prepareCellForVendorTabelView:tableView atIndex:indexPath withBids:self.bidDetails];
        cell.btnAccept.tag = indexPath.row;
        VendorBidDetail *requestBidDetail = [self.usrRequest.bidsArray objectAtIndex:indexPath.row];
        cell.bidId = requestBidDetail.bidId;
        cell.btnAccept.alpha = 1;
    }
    
     return cell;
}
@end
