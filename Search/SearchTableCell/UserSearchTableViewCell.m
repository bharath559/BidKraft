//
//  UserSearchTableViewCell.m
//  BidKraft
//
//  Created by Bharath Kongara on 5/20/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "UserSearchTableViewCell.h"
#import "User.h"
#import "UserRequests.h"

@interface UserSearchTableViewCell()

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;
@property (nonatomic,strong) NSMutableArray *userRequestsArray;
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSMutableArray *bidsArray;
@property (nonatomic,strong) NSString *acceptBidAmount;

@end

@implementation UserSearchTableViewCell

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}


- (void)mockData
{
    
    self.imageNamesArray = [[NSMutableArray alloc] init];
    [self.imageNamesArray addObject:@"rigid_baby"];
    [self.imageNamesArray addObject:@"pet"];
    [self.imageNamesArray addObject:@"textbook"];
    [self.imageNamesArray addObject:@"tutor"];
    [self prepareTableData];
    
}

-(void) prepareTableData
{
    self.userRequestsArray = [[ NSMutableArray alloc] init];
    self.userRequestsArray = self.userData.searchResults;
}

- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
    if(!self.imageNamesArray)
        [self mockData];
    [self prepareTableData];
    NSInteger index = indexPath.section;
    UserRequests *usrRequest = [self.userRequestsArray objectAtIndex:index];
    int categoryId = (int)usrRequest.categoryId;
    self.categoryImage.image = [UIImage imageNamed:[self.imageNamesArray objectAtIndex:(categoryId-1)]];
    [self prepareImageAtIndexPath:indexPath];
}

- (void)prepareImageAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.categoryImage.layer.masksToBounds = YES;
    self.categoryImage.layer.cornerRadius = (self.categoryImage.frame.size.width)/2;
    self.categoryImage.clipsToBounds = YES;
}

-(void) prepareTableCellData:(UserSearchTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath
{
    UserRequests *usrRequest = [self.userRequestsArray objectAtIndex:indexPath.section];
    NSString *lowestBid = [@(usrRequest.lowestBid) stringValue];
    cell.requestId = [[usrRequest valueForKey:@"requestId"] integerValue];
    cell.jobTitle.text = [usrRequest valueForKey:@"jobTitle"];
    if(self.userData.userRequestMode == ActiveMode || self.userData.userRequestMode == CompletedMode)
    {
        [self getBidAmount:usrRequest];
        NSString *acceptBid = [self.acceptBidAmount stringByAppendingString:@"/hr"];
        NSString *dollarString =@"$";
        cell.jobTitle.text = [dollarString stringByAppendingString:acceptBid];
    }
    else if(self.userData.userRequestMode == OpenRequest)
    {
        
        if([lowestBid isEqualToString:@"0"])
            cell.bidAmount.text = @"No Bids";
        else
        {
            NSString *acceptBid = [lowestBid stringByAppendingString:@"/hr"];
            NSString *dollarString =@"$";
            cell.bidAmount.text = [dollarString stringByAppendingString:acceptBid];
        }
    }
}

-(void) getBidAmount:(UserRequests *) usrRequest
{
    self.bidsArray = usrRequest.bidsArray;
    self.acceptBidAmount = [NSString stringWithFormat:@"%@",[self.bidsArray valueForKey:@"bidAmount"][0]];
}

#pragma String utilities

-(NSString *) getDateStringFromNSDate:(NSDate *)requestDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)requestDate];
    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
    [requiredFormat setDateFormat:@"MM/dd"];
    NSString * requiredStringFormat = [ requiredFormat stringFromDate:newDate];
    return requiredStringFormat;
}

-(NSString *) getTimeStringFromNSDate:(NSDate *)requestDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)requestDate];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeString = [formatter stringFromDate:newDate];
    return timeString;
}


@end
