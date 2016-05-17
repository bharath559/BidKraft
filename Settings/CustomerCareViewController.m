//
//  CustomerCareViewController.m
//  BidKraft
//
//  Created by Bharath Kongara on 4/10/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "CustomerCareViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"

@interface CustomerCareViewController ()<UITextFieldDelegate,UITextViewDelegate,ServiceProtocol>

@property (weak, nonatomic) IBOutlet UITextView *topText;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UITextView *txtIssueDescription;

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;


@end

@implementation CustomerCareViewController

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
    
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;

    UIBarButtonItem *rightBarButton;
   
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitTapped:)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    //[self.navigationItem setRightBarButtonItem:anotherButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    self.txtSubject.delegate = self;
    self.txtIssueDescription.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(void) submitTapped:(UIButton *) button
{
    
    if( ![self.txtSubject.text isEqualToString:@""]  || ![self.txtIssueDescription.text isEqualToString:@""])
    {
        NSMutableDictionary *parameters = [self prepareParametersCustomerService];
        NSString *url = [ServiceURLProvider getURLForServiceWithKey:kSendCustomerSupport];
        [self.manager serviceCallWithURL:url andParameters:parameters];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Subject or Description is empy"
                                                            message:@"check fileds"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        
        
        [alertView setDelegate:self];
        [alertView show];
        
    }
}

-(NSMutableDictionary *) prepareParametersCustomerService
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:self.txtSubject.text forKey:@"subject"];
    [parameters setValue:self.txtIssueDescription.text forKey:@"message"];
    
    return parameters;
}

#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
    if([status isEqualToString:@"success"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message Posted to Customer Care!"
                                                            message:@"We will get back to you in 2 to 3 days"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        
        alertView.tag = 1;
        
        [alertView setDelegate:self];
        [alertView show];
        
    }
    else if([status isEqualToString:@"error"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Parameters!"
                                                            message:@"Check for subject or description"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView setDelegate:self];
        [alertView show];
        
    }
    
}
- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!"
                                                        message:error.description
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView setDelegate:self];
    [alertView show];
    
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag ==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}



@end
