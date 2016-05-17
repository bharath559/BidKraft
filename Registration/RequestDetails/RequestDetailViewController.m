//
//  RequestDetailViewController.m
//  Neighbour
//
//  Created by bkongara on 9/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <EventKit/EventKit.h>

#import "RequestDetailViewController.h"
#import "OffersTabelViewDelegate.h"
#import "OffersTableViewDatasource.h"
#import "RequestPaymentViewController.h"
#import "User.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "HomeViewController.h"
#import "VendorData.h"
#import "ProfileViewController.h"
#import "PayListViewController.h"
#import "UserProfile.h"
#import "MBProgressHUD.h"
#import "ProfileData.h"


@interface RequestDetailViewController ()<ServiceProtocol,UIAlertViewDelegate,MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblOffersView;
@property (weak, nonatomic) IBOutlet UITextView *txtRequestDescriptioin;
@property (weak, nonatomic) IBOutlet UILabel *lblRequestStartDate;
@property (weak, nonatomic) IBOutlet UILabel *lblJobTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnTableControl;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblLowestBid;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeLeftTxt;
@property (weak, nonatomic) IBOutlet UIView *noBidsView;

@property (strong,nonatomic) OffersTabelViewDelegate *tblOffersViewDelegate;
@property (strong,nonatomic) OffersTableViewDatasource *tblOffersViewDataSource;
@property (strong,nonatomic) NSMutableArray *requestArray;
@property (strong,nonatomic) UserRequests *usrRequest;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) HomeViewController *homeViewController;
@property (strong,nonatomic) RequestPaymentViewController *requestPaymentView;
@property (strong,nonatomic) VendorData *vendorData;
@property (strong,nonatomic) VendorBidRequest *vendorRequest;
@property (strong,nonatomic) UIStoryboard *storyBoard;
@property (strong,nonatomic) ProfileViewController *profileViewController;
@property (nonatomic,strong) UserProfile *userProfileData;
@property (nonatomic,strong) ProfileData *profileData;

@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) NSString *eventIdentifier;
@property (nonatomic,strong) NSString *remainderIdentifier;

@property BOOL showBidHistory;
@end

@implementation RequestDetailViewController

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
- (UserProfile *)userProfileData
{
    if(!_userProfileData)
        _userProfileData = [UserProfile sharedData];
    
    return _userProfileData;
}
- (ProfileData *)profileData
{
    if(!_profileData)
        _profileData = [ProfileData sharedData];
    
    return _profileData;
}

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
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
    [self initializeDelegatesAndDatasource];
    [self setRequestData];
    self.tblOffersView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //[self addEventsAndRemainders];
   
}

-(void) setRequestData
{
    self.requestArray = [[NSMutableArray alloc] init];
    UserRequests *userRequest;
   
    if(self.userData.userRequestMode == OpenMode)
        self.requestArray = self.userData.userOpenRequests;
    else if(self.userData.userRequestMode == ActiveMode)
        self.requestArray = self.userData.userAcceptedRequests;
    else if(self.userData.userRequestMode == CompletedMode)
        self.requestArray = self.userData.userCompletedRequests;
    for(int i=0;i<self.requestArray.count;i++)
    {
        
        if(!self.userData.isVendorViewShown)
        {
             userRequest = [self.requestArray objectAtIndex:i];
            if( userRequest.requestId == self.requestId)
            {
                self.usrRequest = userRequest;
                break;
            }
        }
    }
   
    self.txtRequestDescriptioin.text = self.usrRequest.requestDescription;
    self.lblRequestStartDate.text =[self getDateStringFromNSDate:(NSDate *)self.usrRequest.requestStartDate];
    self.lblJobTitle.text = self.usrRequest.jobTitle;
    
    NSString *lowestBid = [[@(self.usrRequest.lowestBid) stringValue] stringByAppendingString:@"/hr"];
    NSString *dollarString =@"$";
    self.lblLowestBid.text = [dollarString stringByAppendingString:lowestBid];
    [self timeLeftForBiding];
}

-(void) timeLeftForBiding
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *date1 = [[NSDate alloc] init];
    date1 = [df dateFromString:(NSString *)self.usrRequest.bidEndDateTime];
    
//    NSDate* date2 = [NSDate date];
//    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
//    double secondsInAnHour = 3600;
    //NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
   
    
    NSString *bidTime = self.usrRequest.bidTimeLeft ;
    
    
    if([bidTime isEqualToString:@"0"])
       self.lblTimeLeft.text = @"Bidding Ended";
    else
    {
        self.lblTimeLeft.text = bidTime;
    }
        //self.lblTimeLeft.text = [[@(hoursBetweenDates) stringValue] stringByAppendingString:@"  hrs"];
    if(self.userData.userRequestMode == CompletedMode)
    {
        self.lblTimeLeft.text = @"Request Ended";
        self.lblTimeLeftTxt.alpha = 1;
    }
     else if(self.userData.userRequestMode == ActiveMode)
     {
        self.lblTimeLeft.text = @"Accepted";
         self.lblTimeLeftTxt.alpha = 0;
     }
    
}
-(NSString *) getDateStringFromNSDate:(NSDate *)requestDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)requestDate];
    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
    [requiredFormat setDateFormat:@"MM/dd/yyy HH:mm:ss"];
    NSString * requiredStringFormat = [ requiredFormat stringFromDate:newDate];
    return requiredStringFormat;
}
-(void) initializeDelegatesAndDatasource
{
    self.tblOffersViewDataSource = [[OffersTableViewDatasource alloc]init];
    self.tblOffersViewDelegate = [[OffersTabelViewDelegate alloc]init];
    self.tblOffersViewDataSource.noBidsView = self.noBidsView;
    [self setDelegatesAndDataSource];
    
}
-(void) setDelegatesAndDataSource
{
    self.tblOffersView.delegate = self.tblOffersViewDelegate;
    self.tblOffersView.dataSource = self.tblOffersViewDataSource;
    self.tblOffersViewDataSource.requestDetailController = self;
    self.tblOffersViewDataSource.requestId = self.requestId;
    self.tblOffersView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
//- (IBAction)accordianAction:(id)sender
//{
//    if (self.showBidHistory == NO)
//    {
//        [UIView animateWithDuration:0.53
//                              delay:0
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             self.tblOffersView.frame = CGRectMake(self.tblOffersView.frame.origin.x, self.tblOffersView.frame.origin.y, self.tblOffersView.frame.size.width, 100);
//                             self.tblOffersViewDataSource.offersTableView = self.tblOffersView;
//                         }
//                         completion:^(BOOL finished){
//                             self.showBidHistory = YES;
//                             
//                             [self.btnTableControl setBackgroundImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
//                         }];
//    }
//    else
//    {
//        [UIView animateWithDuration:0.53
//                              delay:0
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             self.tblOffersView.frame = CGRectMake(self.tblOffersView.frame.origin.x, self.tblOffersView.frame.origin.y, self.tblOffersView.frame.size.width, 0);
//                         }
//                         completion:^(BOOL finished){
//                             self.showBidHistory = NO;
//                             [self.btnTableControl setBackgroundImage:[UIImage imageNamed:@"up_arrow"] forState:UIControlStateNormal];
//
//                             self.btnTableControl.titleLabel.text = @"Down";
//                         }];
//    }
//    
//}


- (IBAction)dismissRequestDetailView:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)acceptBid:(UIButton *)sender
{

    self.requestPaymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestPaymentViewController"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    OffersTableViewCell *cell = (OffersTableViewCell *)[self.tblOffersView cellForRowAtIndexPath:indexPath];
    self.requestPaymentView.cellBidID = cell.bidId;
    self.requestPaymentView.requestID = self.requestId;
    self.requestPaymentView.bidAmount = cell.bidAmount;
    [self.navigationController pushViewController:self.requestPaymentView animated:YES];

}

-(void) prepareLoadIndicator
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getProfileView:(NSDictionary *) profileResponse
{
    
    NSDictionary *data = [profileResponse valueForKey:@"data"];
    [self saveUserData:data];
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.profileViewController = (ProfileViewController *) [self.storyBoard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    self.profileViewController.isProfileShownModally =@"YES";
    
    UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:self.profileViewController];
    [self  presentViewController:navcontroller animated:YES completion:nil];
}

-(void) saveUserData:(NSDictionary *) response
{
    NSString *cellPhone = [response valueForKey:@"cellPhone"];
    NSString *description = [response valueForKey:@"description"];
    NSString *emailId = [response valueForKey:@"emailId"];
    NSString *userPoints = [response valueForKey:@"userPoints"];
    NSString *vendorPoints = [response valueForKey:@"vendorPoints"];
    NSString *userRatings = [response valueForKey:@"rating"];
    NSString *userName = [response valueForKey:@"name"];
    
    [self.profileData saveUserPoints:userPoints];
    [self.profileData saveVendorPoints:vendorPoints];
    [self.profileData savePhoneNumber:cellPhone];
    [self.profileData saveEmail:emailId];
    [self.profileData saveUserDescription:description];
    [self.profileData saveUserRating:userRatings];
    [self.profileData saveFullName:userName];
    
}

#pragma mark - Paymentprotocol method
- (void)getPaymentDetails:(NSMutableDictionary *)paymentDetails
{
    [self serviceCall:paymentDetails];
}

-(void)serviceCall:(NSMutableDictionary *) paymentDetails
{
    [self prepareLoadIndicator];
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self preparePostData:[paymentDetails objectForKey:@"bidId"]];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kAcceptBidKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    [self.HUD show:YES];
}

-(NSMutableDictionary *)preparePostData:(NSString *)bidId
{
    NSMutableDictionary *parameters = [[ NSMutableDictionary alloc] init];
    [parameters setObject:bidId forKey:@"bidId"];
    [parameters setObject:[@(self.requestId) stringValue] forKey:@"requestId"];
    [parameters setObject:[self.userData userId] forKey:@"userId"];
    return parameters;
}
#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    [self.HUD removeFromSuperview];
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
        if( [status isEqualToString:@"success"])
        {
            
            NSDictionary *responsedata = [response objectForKey:@"data"];
            NSMutableArray *openRequests =  [responsedata objectForKey:@"openRequests"];
            NSMutableArray *acceptedRequests =  [responsedata objectForKey:@"acceptedRequests"];
            
            if(openRequests)
                [self.userData saveUserOpenRequestsData:openRequests];
            if(acceptedRequests)
                [self.userData saveUserAcceptedRequestsData:acceptedRequests];
            
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                                message:@"Bid accepted"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            alertView.tag = 2;
            alertView.delegate = self;
            [alertView show];
        }
}
- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
#pragma Calender Events and Remainders and methods

-(void)addEventToCalender:(NSString *)eventDescription withEventDate:(NSDate *)eventDate
{
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = eventDescription;
        event.startDate = eventDate;
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        [event setCalendar:[store defaultCalendarForNewEvents]];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        //NSString *savedEventId = event.eventIdentifier; //this is so you can access this event later
    }];
}

-(void)addRemainder:(NSString *)remainderDescription withRemainderDate:(NSDate *)remainderDate
{
    EKEventStore *remainderEvent = [[EKEventStore alloc] init];
    [remainderEvent requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        if (!granted)
            return;
        if(remainderEvent!=nil)
        {
            EKReminder *reminder = [EKReminder
                                    reminderWithEventStore:remainderEvent];
            reminder.title = remainderDescription;
            reminder.calendar = [remainderEvent defaultCalendarForNewReminders];
            NSDate *remainderStartDate = remainderDate;
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:remainderStartDate];
            [reminder addAlarm:alarm];
            NSError *errorRemainder = nil;
            [remainderEvent saveReminder:reminder commit:YES error:&errorRemainder];
           // NSString *saveRemainder = remainderEvent.eventStoreIdentifier;
            if (errorRemainder)
                NSLog(@"error = %@", errorRemainder);
        }
        
    }];
}

-(void)addEventsAndRemainders
{

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    
    NSDate *current = [[NSDate alloc] init];
    current = [NSDate date];
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)self.usrRequest.requestStartDate];
    
    NSString *requiredString = [df stringFromDate:newDate];
    
    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
    [requiredFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateRequired = [df dateFromString:requiredString];
    
    [self addEventToCalender:self.usrRequest.requestDescription withEventDate:dateRequired];
    [self addRemainder:self.usrRequest.requestDescription withRemainderDate:dateRequired];
    
}


#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 0 && alertView.tag ==2)
    {
        [self addEventsAndRemainders];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        self.homeViewController = (HomeViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController showViewController:self.homeViewController sender:self];
    }
}

-(void) initializeObjects:(NSDictionary *) responseData
{
    responseData = [responseData valueForKey:@"data"];
    NSMutableArray *openRequests = [responseData valueForKey:@"openRequests"];
    NSMutableArray *acceptedRequests = [responseData valueForKey:@"acceptedRequests"];
    NSMutableArray *completedRequests = [responseData valueForKey:@"servicedRequests"];
    if(openRequests)
        [self.userData saveUserOpenRequestsData:openRequests];
    if(acceptedRequests)
        [self.userData saveUserAcceptedRequestsData:acceptedRequests];
    if(completedRequests)
        [self.userData saveUserCompletedRequestsData:completedRequests];
    
}
@end
