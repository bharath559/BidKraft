//
//  RequestPaymentViewController.m
//  Neighbour
//
//  Created by Raghav Sai on 11/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "RequestPaymentViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "HomeViewController.h"
#import <EventKit/EventKit.h>

@interface RequestPaymentViewController ()<ServiceProtocol,UIAlertViewDelegate>

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) NSDictionary *confirmationDetails;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) HomeViewController *homeViewController;

@end

@implementation RequestPaymentViewController

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)serviceCall
{
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self preparePostData:self.cellBidID];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kAcceptBidKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}

-(NSMutableDictionary *)preparePostData:(NSInteger)bidId
{
    NSMutableDictionary *parameters = [[ NSMutableDictionary alloc] init];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)bidId] forKey:@"bidId"];
    [parameters setObject:[NSString stringWithFormat:@"%ld", (long)self.requestID] forKey:@"requestId"];
    [parameters setObject:[self.userData userId] forKey:@"userId"];
    return parameters;
}


#pragma ServiceProtocol methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSString *status =[responsedata objectForKey:@"status"];
    
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
        alertView.delegate = self;
        [alertView show];
    }
    
}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0)
    {
        [self parseAcceptedRequests];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        self.homeViewController = (HomeViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController showViewController:self.homeViewController sender:self];
        //[self.navigationController popViewControllerAnimated:YES];
    }
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
        //NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
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
            if (errorRemainder)
                NSLog(@"error = %@", errorRemainder);
        }
        
    }];
    
}

-(void)parseAcceptedRequests
{
    int indexValue=-1;
    for (UserRequests *parse in self.userData.userAcceptedRequests)
    {
        if(parse.bidDetail.bidId == self.cellBidID)
        {
            indexValue++;
            NSLog(@"%ld",(long)parse.bidDetail.bidId);
            break;
        }
    }
    UserRequests *getData = [self.userData.userAcceptedRequests objectAtIndex:indexValue];
    NSLog(@"%@",getData.requestStartDate);
    NSLog(@"%@",getData.requestStartFromTime);
    NSLog(@"%@",getData.requestDescription);
    NSDate *eventDate=[self parseDate:getData.requestStartDate withStartTime:getData.requestStartFromTime];
    
    [self addEventToCalender:getData.requestDescription withEventDate:eventDate];
    [self addRemainder:getData.requestDescription withRemainderDate:eventDate];
    
}

-(NSDate *)parseDate:(NSDate *)startDate withStartTime:(NSString *)startTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)startDate];
    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
    [requiredFormat setDateFormat:@"yyyy-MM-dd"];
    NSString * requiredStringFormat = [ requiredFormat stringFromDate:newDate];
    NSLog(@"%@",requiredStringFormat);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithName:@"EST"];
    [formatter setTimeZone:gmt];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",requiredStringFormat,startTime]];
    return date;
}
@end
