//
//  OffersTableViewCell.m
//  Neighbour
//
//  Created by bkongara on 9/11/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "OffersTableViewCell.h"
#import "User.h"
#import "VendorData.h"
#import "VendorBidDetail.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "ProfileViewController.h"
#import "MBProgressHUD.h"



@interface OffersTableViewCell()<ServiceProtocol,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblBidAmount;

@property (nonatomic,strong) UITableView *offersTableView;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) ProfileViewController *profileViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblBidType;
@property (weak, nonatomic) IBOutlet UILabel *lblBestOffers;
@property (weak,nonatomic)  NSMutableArray *imgUserArray;
@property (strong,nonatomic) NSMutableArray *requestArrays;
@property (strong,nonatomic) UserRequests *usrRequest;
@property (nonatomic,strong) BidDetails *bidDetail;
@property (nonatomic,strong) NSMutableArray *bidsArray;
@property BOOL isProfileView;
@property (nonatomic,strong) MBProgressHUD *HUD;


@end
@implementation OffersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) mockData
{
    User *userData = [User sharedData];
    self.requestArrays = userData.usrRequests;
  
}

- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withBids:(NSMutableArray *)listOfBids
{
   
    self.offersTableView = tableView;
    
    BidDetails *requestBidDetail = [listOfBids objectAtIndex:indexPath.item];
    self.lblBidType.text= requestBidDetail.userName;
    [self.btnUserName setTitle:requestBidDetail.userName forState:UIControlStateNormal];
    self.btnUserName.tag = indexPath.item;
    self.btnAccept.tag = indexPath.item;
    //self.btnUserName.titleLabel.text = requestBidDetail.userName;
    [self.lblBidAmount setText: [[@(requestBidDetail.bidAmount)stringValue] stringByAppendingString:@"$/hr"]];
    //[self.lblTime setText:@"5 hrs"];
    //self.lblBestOffers.text = [requestBidDetail.bidAmount stringByAppendingString:@"$/hr"];
    NSString *lowestBid = [[@(requestBidDetail.bidAmount)stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";
    
   // [self.lblBidAmount setText:[dollarString stringByAppendingString:lowestBid]];
    
    self.lblBidAmount.text = [dollarString stringByAppendingString:lowestBid];
    self.bidOffererId  = requestBidDetail.offererUserId;
    [self timeDifference:requestBidDetail];
    
}
//-(void) prepareLoadIndicator
//{
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.userProfileViewDelegate.view addSubview:self.HUD];
//    self.HUD.delegate = self;
//}

- (void)prepareCellForVendorTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withBids:(NSMutableArray *)listOfBids{
    
    VendorBidDetail *requestBidDetail = [listOfBids objectAtIndex:indexPath.item];
    self.lblBidType.text= requestBidDetail.offererName;
    [self.btnUserName setTitle:requestBidDetail.offererName forState:UIControlStateNormal];
    self.lblBestOffers.text = [[@(requestBidDetail.bidAmount) stringValue]  stringByAppendingString:@"$/hr"];
    
    NSString *lowestBid = [[@(requestBidDetail.bidAmount)stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";

    [self.lblBidAmount setText:[dollarString stringByAppendingString:lowestBid]];
    [self timeDifferenceForVendor:requestBidDetail];
}

-(void) timeDifferenceForVendor:(VendorBidDetail *) requestBidDetail
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *date1 = [[NSDate alloc] init];
    date1 = [df dateFromString:(NSString *)requestBidDetail.createdDate];
    
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    self.lblTimeAgo.text = [[@(hoursBetweenDates) stringValue] stringByAppendingString:@" hrs ago"];
}

-(void) timeDifference:(BidDetails *) requestBidDetail
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *date1 = [[NSDate alloc] init];
    date1 = [df dateFromString:(NSString *)requestBidDetail.bidCreatedDate];
    
    NSDate* date2 = [NSDate date];
    NSTimeInterval distanceBetweenDates = [date2 timeIntervalSinceDate:date1];
    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    self.lblTimeAgo.text = [[@(hoursBetweenDates) stringValue] stringByAppendingString:@" hrs ago"];
}

- (IBAction)userNameTapped:(id)sender
{
   
    UIButton *button =(UIButton *)sender;
    OffersTableViewCell *cell =(OffersTableViewCell *)[self.offersTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParmeters:cell.bidOffererId];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kGetUserProfile];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    
}

- (IBAction)btnBidAccept:(id)sender
{
    
    UIButton *button =(UIButton *)sender;
    OffersTableViewCell *cell =(OffersTableViewCell *)[self.offersTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:button.tag inSection:0]];
    NSMutableDictionary *paymentDetails = [[NSMutableDictionary alloc]init];
    [paymentDetails setObject:[@(cell.bidAmount) stringValue] forKey:@"bidAmountPay"];
       [paymentDetails setObject:[@(cell.bidId) stringValue] forKey:@"bidId"];
    [self.paymentDetailsDelegate getPaymentDetails:paymentDetails];
    
}

-(NSMutableDictionary *) prepareParmeters:(NSString *) userId
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:userId forKey:@"userId"];
    return parameters;
}

#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    //NSDictionary *data = [response valueForKey:@"data"];
    NSLog(@"data%@",responsedata);
    //NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
    [self.userProfileViewDelegate getProfileView:response];
    
}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}



@end
