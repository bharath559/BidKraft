//
//  VendorSearchTableViewCell.m
//  BidKraft
//
//  Created by Bharath Kongara on 5/20/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "VendorSearchTableViewCell.h"
#import "VendorBidRequest.h"
#import "VendorData.h"
#import "User.h"

@interface VendorSearchTableViewCell()

@property (nonatomic,strong) NSString *bidAmount;
@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;
@property (nonatomic,strong) NSMutableArray *userRequestsArray;
@property (nonatomic,assign) NSInteger categoryId;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *bidsArray;

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblBidAmount;
@property (nonatomic,strong) User *userData;



@end

@implementation VendorSearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

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
    
    self.userRequestsArray = self.userData.searchResults;
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
-(void) prepareTableCellData:(VendorSearchTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath
{
    
    VendorBidRequest *usrRequest = [self.userRequestsArray objectAtIndex:indexPath.section];
    NSInteger lowestBid = (NSInteger)usrRequest.leastBidAmount;
    NSString *reformatBid = [[@(lowestBid) stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";
    cell.lblBidAmount.text = [dollarString stringByAppendingString:reformatBid];
    cell.requestId = [[usrRequest valueForKey:@"requestId"] integerValue];
    cell.requestDescription = usrRequest.requestDescription;
    cell.jobTitle.text = usrRequest.jobTitle;
    //cell.timeSlotBtn1.text = usrRequest.requestStartFromTime;
    if(self.vendorData.vendorRequestMode == VendorBidsOwnMode)
    {
        [self getBidAmount:usrRequest];
        NSString *reformatBid = [self.bidAmount stringByAppendingString:@"/hr"];
        NSString *dollarString =@"$";
        cell.lblBidAmount.text = [dollarString stringByAppendingString:reformatBid];
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

@end
