//
//  VendorTableViewCell.m
//  Neighbour
//
//  Created by Bharath kongara on 10/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "VendorTableViewCell.h"
#import "User.h"
#import "VendorBidRequest.h"
#import "VendorData.h"

@interface VendorTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalBids;
@property (weak, nonatomic) IBOutlet UILabel *lblNewBids;
@property (weak, nonatomic) IBOutlet UILabel *timeSlotBtn1;
@property (weak, nonatomic) IBOutlet UILabel *lblLeastBidValue;
@property (weak, nonatomic) IBOutlet UILabel *lblBidDate;
@property (nonatomic,strong) NSString *bidAmount;
@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;
@property (nonatomic,strong) NSMutableArray *userRequestsArray;
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *bidsArray;

@end

@implementation VendorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self prepareTableData];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (VendorData *)vendorData
{
    if(!_vendorData)
        _vendorData = [VendorData sharedData];
    
    return _vendorData;
}


- (void)mockData
{
    
    self.imageNamesArray = [[NSMutableArray alloc] init];
    [self.imageNamesArray addObject:@"rigid_baby"];
    [self.imageNamesArray addObject:@"pet"];
    [self.imageNamesArray addObject:@"tutor"];
    [self.imageNamesArray addObject:@"textbook"];
    [self prepareTableData];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

-(void) prepareTableData
{
    self.userRequestsArray = [[ NSMutableArray alloc] init];
    
    if(self.vendorData.vendorRequestMode == VendorOpenMode)
        self.userRequestsArray = self.vendorData.vendorOpenRequests;
    else if(self.vendorData.vendorRequestMode == VendorPlacedBidsMode)
        self.userRequestsArray = self.vendorData.vendorBids;
    else if(self.vendorData.vendorRequestMode == VendorBidsOwnMode)
        self.userRequestsArray = self.vendorData.vendorOwnBids;
}

- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath
{
   
    [self mockData];
    UserRequests *usrRequest = [self.userRequestsArray objectAtIndex:indexPath.section];
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

-(void) prepareTableCellData:(VendorTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath
{
    
    VendorBidRequest *usrRequest = [self.userRequestsArray objectAtIndex:indexPath.section];
    NSInteger lowestBid = (NSInteger)usrRequest.leastBidAmount;
    NSString *reformatBid = [[@(lowestBid) stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";
    cell.lblLeastBidValue.text = [dollarString stringByAppendingString:reformatBid];
    NSInteger totalBids = (NSInteger)usrRequest.totalBids;
    NSString *totalBidsText = @"Total:";
    cell.lblTotalBids.text=[totalBidsText stringByAppendingString:[@(totalBids) stringValue]];
    cell.lblBidDate.text = [self getDateStringFromNSDate:(NSDate *)usrRequest.requestStartDate];
    cell.requestId = [[usrRequest valueForKey:@"requestId"] integerValue];
     cell.requestDescription = usrRequest.requestDescription;
    cell.timeSlotBtn1.text = usrRequest.jobTitle;
    //cell.timeSlotBtn1.text = usrRequest.requestStartFromTime;
    if(self.vendorData.vendorRequestMode == VendorBidsOwnMode)
    {
        [self getBidAmount:usrRequest];
        NSString *reformatBid = [self.bidAmount stringByAppendingString:@"/hr"];
        NSString *dollarString =@"$";
        cell.lblLeastBidValue.text = [dollarString stringByAppendingString:reformatBid];
    }
}


-(void) getBidAmount:(VendorBidRequest *) usrRequest
{
    self.bidsArray = usrRequest.bidsArray;
    self.bidAmount = [NSString stringWithFormat:@"%@",[self.bidsArray valueForKey:@"bidAmount"][0]];
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
-(void)prepareTableCellData:(VendorTableViewCell *) vendorCell withIndexPath :(NSIndexPath *)indexPath withData:(NSMutableArray *) vendorRequests
{
    
    
    //NSInteger index = (indexPath.section * vendorRequests.count)+ indexPath.section;
    VendorBidRequest *vendorRequest = [vendorRequests objectAtIndex:indexPath.section];
    NSInteger lowestBid = (NSInteger)vendorRequest.leastBidAmount;
    
    NSString *reformatBid = [[@(lowestBid) stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";
    vendorCell.lblLeastBidValue.text = [dollarString stringByAppendingString:reformatBid];
    NSInteger totalBids = (NSInteger)vendorRequest.totalBids;
    NSString *totalBidsText = @"Total:";
    vendorCell.lblTotalBids.text=[totalBidsText stringByAppendingString:[@(totalBids) stringValue]];
    vendorCell.lblBidDate.text = [self getDateStringFromNSDate:(NSDate *)vendorRequest.requestStartDate];
    int categoryId = (int)vendorRequest.categoryId;
    vendorCell.categoryImage.image = [UIImage imageNamed:[self.imageNamesArray objectAtIndex:(categoryId-1)]];
    vendorCell.requestId = vendorRequest.requestId;
    vendorCell.requestDescription = vendorRequest.requestDescription;
    vendorCell.timeSlotBtn1.text = vendorRequest.jobTitle;
    
}

- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withData:(NSMutableArray *) vendorRequests
{
    if(!self.imageNamesArray)
        [self mockData];
    
    //NSInteger index = (indexPath.section * vendorRequests.count )+ indexPath.section;
    VendorBidRequest *vendorRequest = [vendorRequests objectAtIndex:indexPath.section];
    int categoryId = (int)vendorRequest.categoryId;
    self.categoryImage.image = [UIImage imageNamed:[self.imageNamesArray objectAtIndex:(categoryId-1)]];
    [self prepareImageAtIndexPath:indexPath];
    
}
-(NSString *) getRequestDate
{
    return self.lblBidDate.text;
}
-(NSString *) getRequestDescription
{
    return [NSString stringWithFormat:@"%@",self.requestDescription];
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
