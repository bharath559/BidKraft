//
//  RequestTableViewCell.m
//  Neighbour
//
//  Created by bkongara on 9/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "RequestTableViewCell.h"
#import "User.h"
#import "UserRequests.h"


@interface RequestTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *lblLeastBidValue;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;
@property (nonatomic,strong) NSMutableArray *userRequestsArray;
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSMutableArray *bidsArray;
@property (nonatomic,strong) NSString *acceptBidAmount;

@end

@implementation RequestTableViewCell

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [self prepareTableData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
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

- (void)prepareForReuse
{
    [super prepareForReuse];
}

-(void) prepareTableData
{
    self.userRequestsArray = [[ NSMutableArray alloc] init];
    if(self.userData.userRequestMode == OpenMode)
        self.userRequestsArray = [[[self.userData.userOpenRequests mutableCopy] arrayByAddingObjectsFromArray:[self.userData.userAcceptedRequests mutableCopy]]mutableCopy];
    else if(self.userData.userRequestMode == ActiveMode)
        self.userRequestsArray = self.userData.userAcceptedRequests;
    else if(self.userData.userRequestMode == CompletedMode)
        self.userRequestsArray = self.userData.userCompletedRequests;
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

-(void) prepareTableCellData:(RequestTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath
{
    UserRequests *usrRequest = [self.userRequestsArray objectAtIndex:indexPath.section];
    NSString *lowestBid = [@(usrRequest.lowestBid) stringValue];
    cell.requestId = [[usrRequest valueForKey:@"requestId"] integerValue];
    cell.lblDescription.text = [usrRequest valueForKey:@"jobTitle"];
    cell.requestStatus = usrRequest.requestStatus;
    if(self.userData.userRequestMode == ActiveMode || self.userData.userRequestMode == CompletedMode)
    {
        [self getBidAmount:usrRequest];
        NSString *acceptBid = [self.acceptBidAmount stringByAppendingString:@"/hr"];
        NSString *dollarString =@"$";
        cell.lblLeastBidValue.text = [dollarString stringByAppendingString:acceptBid];
    }
    else if(self.userData.userRequestMode == OpenRequests)
    {
        
        if([lowestBid isEqualToString:@"0"])
            cell.lblLeastBidValue.text = @"No Bids";
        else
        {
            NSString *acceptBid = [lowestBid stringByAppendingString:@"/hr"];
            NSString *dollarString =@"$";
            cell.lblLeastBidValue.text = [dollarString stringByAppendingString:acceptBid];
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
