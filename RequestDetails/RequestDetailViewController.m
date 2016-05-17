//
//  RequestDetailViewController.m
//  Neighbour
//
//  Created by bkongara on 9/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "OffersTabelViewDelegate.h"
#import "OffersTableViewDatasource.h"
#import "OffersTableViewCell.h"
#import "User.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"

@interface RequestDetailViewController ()<ServiceProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tblOffersView;
@property (weak, nonatomic) IBOutlet UILabel *requestDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestStartDate;
@property (strong,nonatomic) OffersTabelViewDelegate *tblOffersViewDelegate;
@property (strong,nonatomic) OffersTableViewDatasource *tblOffersViewDataSource;

@property (strong,nonatomic) NSMutableArray *requestArray;
@property (strong,nonatomic) UserRequests *usrRequest;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *user;



@end

@implementation RequestDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [self initializeDelegatesAndDatasource];
    self.ratingView.delegate = self;
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.editable = YES;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = NO;
    [self setRequestData];
   
}

-(void) setRequestData
{
    User *user = [User sharedData];
    self.requestArray = user.usrRequests;
    
    
    for(int i=0;i<self.requestArray.count;i++)
    {
          UserRequests *userRequest = [self.requestArray objectAtIndex:i];
        if( userRequest.requestId == self.requestId)
        {
            self.usrRequest = userRequest;
            break;
        }
    }
    
    self.requestDescription.text = self.usrRequest.requestDescription;
    self.lblRequestStartDate.text =[self getDateStringFromNSDate:(NSDate *)self.usrRequest.requestCreatedDate];
    
}
-(NSString *) getDateStringFromNSDate:(NSDate *)requestDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)requestDate];
    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
    [requiredFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * requiredStringFormat = [ requiredFormat stringFromDate:newDate];
    return requiredStringFormat;
}

-(void) initializeDelegatesAndDatasource
{
    self.tblOffersViewDataSource = [[OffersTableViewDatasource alloc]init];
    self.tblOffersViewDelegate = [[OffersTabelViewDelegate alloc]init];
    [self setDelegatesAndDataSource];
    
}
-(void) setDelegatesAndDataSource
{
    self.tblOffersView.delegate = self.tblOffersViewDelegate;
    self.tblOffersView.dataSource = self.tblOffersViewDataSource;
    self.tblOffersViewDataSource.requestId = self.requestId;
    
}

- (IBAction)dismissRequestDetailView:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)acceptBid:(UIButton *)sender
{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    OffersTableViewCell *cell = (OffersTableViewCell *)[self.tblOffersView cellForRowAtIndexPath:indexPath];
    NSInteger bidId = cell.bidId;
        self.manager = [ServiceManager defaultManager];
        self.manager.serviceDelegate = self;
    
    NSMutableDictionary *parameters = [self preparePostData:bidId];
    
        NSString *url = [ServiceURLProvider getURLForServiceWithKey:kAcceptBidKey];
        [self.manager serviceCallWithURL:url andParameters:parameters];

}
-(NSMutableDictionary *) preparePostData:(NSInteger) bidId
{
    NSMutableDictionary *parameters = [[ NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bidId] forKey:@"bidId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)self.requestId] forKey:@"requestId"];
    return parameters;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ServiceProtocol methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSString *status =[responsedata objectForKey:@"status"];
    
    if( [status isEqualToString:@"success"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                            message:@"Bid accepted"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

@end
