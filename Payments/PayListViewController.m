//
//  PayListViewController.m
//  BidKraft
//
//  Created by Raghav Sai on 4/1/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "PayListViewController.h"
#import "PaymentViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import "HomeViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"

@interface PayListViewController ()<UIAlertViewDelegate,ServiceProtocol>

@property (weak, nonatomic) IBOutlet UIButton *btnPayVenmo;
@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *txtComments;
@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnRate;


@property (strong, nonatomic) NSString *payMemo;
//@property (nonatomic,strong) HomeViewController *homeViewController;

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSDictionary *confirmationDetails;
@property BOOL isvenmoPayment;


@end

@implementation PayListViewController


- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (![Venmo isVenmoAppInstalled])
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    else
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Venmo pay action
- (IBAction)payWithVenmo:(id)sender
{
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success)
                             {
                                 [self showPaymentAlert];
                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                                                     message:error.localizedDescription
                                                                                    delegate:self
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                 [alertView show];
  
                             }
                }];

}


- (IBAction)rateButtonTapped:(id)sender
{
    
    [self removeRatingViewFromSuperView];
       NSString *url;
      self.manager = [ServiceManager defaultManager];
    NSMutableDictionary *parameters = [self prepareParmetersForCompletionRequest];
    self.manager.serviceDelegate = self;
    url = [ServiceURLProvider getURLForServiceWithKey:kCompletedServiceKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    
}

-(void)removeRatingViewFromSuperView
{
    [self.ratingView removeFromSuperview];
}

-(NSMutableDictionary *) prepareParmetersForCompletionRequest
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *userReview = [[NSMutableDictionary alloc]init];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:@"1" forKey:@"roleId"];
    [parameters setValue:self.requestIdToBeDeleted forKey:@"requestId"];
    [userReview setValue:[self.userData userId] forKey:@"reviewerUserId"];
    [userReview setValue:@"38" forKey:@"revieweeUserId"];
    [userReview setValue:self.requestIdToBeDeleted forKey:@"requestId"];
    [userReview setValue:[NSNumber numberWithFloat:self.userData.ratingCount] forKey:@"rating"];
    [userReview setValue:self.txtComments.text forKey:@"comment"];
    [parameters setValue:userReview forKey:@"userReview"];
    
    return parameters;
}

- (void)venmoPay
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                        message:@"Bid Confirmed"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag =2;
    alertView.delegate = self;
    [alertView show];
    
    
//    self.manager = [ServiceManager defaultManager];
//    self.manager.serviceDelegate = self;
//    self.isvenmoPayment = YES;
//    NSMutableDictionary *parameters = [self preparePostData:self.bidId];
//    //NSString *url = [ServiceURLProvider getURLForServiceWithKey:kAcceptBidKey];
//    [self.manager serviceCallWithURL:@"https://sandbox-api.venmo.com/v1/payments" andParameters:parameters];

//    [[Venmo sharedInstance] sendPaymentTo:@"7578147843"
//                                   amount:self.bidAmount.floatValue*100 // this is in cents!
//                                     note:self.payMemo
//                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
//                            if (success)
//                            {
//                                
//                                
//                                [self.navigationController popViewControllerAnimated:YES];
//                                
//                            }
//                            else {
//                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
//                                                                                    message:error.localizedDescription
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:nil
//                                                                          otherButtonTitles:@"OK", nil];
//                                [alertView show];
//
//                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
//                            }
//                        }];

    
    
    
}

-(void) prepareParametersForVenmo
{
    
}

- (void)showPaymentAlert
{
    UIAlertView *paymentAlertView = [[UIAlertView alloc] initWithTitle:@"Enter Note"
                                                               message:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"cancel"
                                                     otherButtonTitles:@"ok", nil];
    paymentAlertView.tag = 1;
    paymentAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [paymentAlertView show];
}


//
//-(void)serviceCall
//{
//    self.manager = [ServiceManager defaultManager];
//    self.manager.serviceDelegate = self;
//     self.isvenmoPayment = NO;
//    NSMutableDictionary *parameters = [self preparePostData:self.bidId];
//    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kAcceptBidKey];
//    [self.manager serviceCallWithURL:url andParameters:parameters];
//}

-(NSMutableDictionary *)preparePostData:(NSString *)bidId
{
    NSMutableDictionary *parameters = [[ NSMutableDictionary alloc] init];
     [parameters setObject:@"b22b2a07a93996c180a2c78abf5cd3d290d0130be40b7fb5d229042f3573b099" forKey:@"access_token"];
    [parameters setObject:@"145434160922624933" forKey:@"user_id"];
    [parameters setObject:@"venmo@venmo.com" forKey:@"email"];
    [parameters setObject:@"15555555555" forKey:@"phone"];
    [parameters setObject:self.payMemo forKey:@"note"];
    [parameters setObject:[@(self.bidAmount) stringValue] forKey:@"note"];

    return parameters;
}


#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex>0)
    {
        UITextField *txtPayMemo = [alertView textFieldAtIndex:0];
        self.payMemo = txtPayMemo.text;
        
        [self.view addSubview:self.ratingView];
         //[self.navigationController popViewControllerAnimated:YES];
         //[self.ratingViewDelegate showRatingView];
       // [self venmoPay];
        //[self serviceCall];
    }
    
    if (buttonIndex == 0 && alertView.tag ==2)
    {
       
        self.userData.reloadingAfterPayments = YES;
        //[self.navigationController popViewControllerAnimated:YES];
       
        //[self parseAcceptedRequests];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        self.homeViewController = (HomeViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController showViewController:self.homeViewController sender:self];
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma ServiceProtocol methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSString *status =[responsedata objectForKey:@"status"];
    
    if( [status isEqualToString:@"success"])
    {
        
        NSDictionary *responsedata = [response objectForKey:@"data"];
        NSMutableArray *acceptedRequests =  [responsedata objectForKey:@"acceptedRequests"];
        NSMutableArray *completedRequests = [responsedata valueForKey:@"servicedRequests"];
        
        if(acceptedRequests)
            [self.userData saveUserAcceptedRequestsData:acceptedRequests];
        if(completedRequests)
            [self.userData saveUserCompletedRequestsData:completedRequests];

        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                            message:@"Request Completed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag =2;
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


-(NSDate *)parseDate:(NSDate *)startDate withStartTime:(NSString *)startTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy H:m:s z"];
    
    NSDate *newDate = [[NSDate alloc] init];
    newDate = [df dateFromString:(NSString *)startDate];
    
    NSString *newStartTime = [df stringFromDate:startDate];
//    NSDateFormatter *requiredFormat = [[NSDateFormatter alloc]init];
//    [requiredFormat setDateFormat:@"yyyy-MM-dd"];
//    NSString * requiredStringFormat = [ requiredFormat stringFromDate:newDate];
//    NSLog(@"%@",requiredStringFormat);
//    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithName:@"EST"];
    [formatter setTimeZone:gmt];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [formatter dateFromString:newStartTime];
    return date;
}


@end
