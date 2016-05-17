//
//  ViewController.m
//  Neighbour
//
//  Created by bkongara on 8/28/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#define USER_NAME_ANIMATION_DISTANCE 240
#define PASSWORD_ANIMATION_DISTANCE 190
#define IMAGE_ANIMATION_DISTANCE 100
#define REGISTER_BUTTON_ANIMATION_DISTANCE 150
#define LOGIN_ANIMATION_DISTANCE 134



#import "LoginViewController.h"
#import "QuartzCore/QuartzCore.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "HomeViewController.h"
#import "UserRequests.h"
#import "BidDetails.h"
#import "RegistrationViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"

#import "CommonHeaderFiles.h"



@interface LoginViewController () <UITextFieldDelegate,ServiceProtocol,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIView *loginDetailsContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) RegistrationViewController *registrationController;
@property (strong,nonatomic) FBSDKLoginButton *fbLoginView;
@property (nonatomic,strong) HomeViewController *homeViewController;
@property (nonatomic,strong) UserRequests *usrRequests;
@property (nonatomic,strong) BidDetails *bidDetails;
@property (nonatomic, strong) UserProfile *userProfileData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) MBProgressHUD *HUD;


@end

@implementation LoginViewController

- (UserProfile *)userProfileData
{
    if(!_userProfileData)
        _userProfileData = [UserProfile sharedData];
    
    return _userProfileData;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setUpKeyboardHandlerAndLocationManager];
//    [self prepareButtonsAndTextField];
//    [self makeImageRoundCornerAndMoveCenter];
//    [self facebookLogin];
//    self.txtUserName.delegate = self;
//    self.txtPassword.delegate = self;
//    [self animationWithDuration:1 anddelay:2 andMovementDistance:0];
}

-(void) makeImageRoundCornerAndMoveCenter
{
    [self.imgLogo setCenter:self.view.center];
}

-(void) animationWithDuration:(int)duration anddelay:(int)delay andMovementDistance:(int) movement
{
    dispatch_queue_t myQueue;
    myQueue = dispatch_queue_create("com.neighbour.MyCustomQueue", NULL);
    
    [UIView animateWithDuration:duration  delay:delay options:0 animations:^{
        CGSize size = CGSizeMake(self.imgLogo.frame.size.width , self.imgLogo.frame.size.height);
        CGPoint origin = CGPointMake(self.imgLogo.frame.origin.x, 150);
        CGRect logoRect = CGRectMake(origin.x, origin.y, size.width, size.height);
        self.imgLogo.frame = logoRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6f animations:^{
            self.loginDetailsContainer.alpha = 1.0f;
        } completion:nil];
    }];
}

-(void) setUpKeyboardHandlerAndLocationManager
{
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
}

-(void) prepareButtonsAndTextField
{
    self.navigationController.navigationBarHidden = YES;
    //self.btnLogin.layer.cornerRadius = 5;
    //self.btnRegister.layer.cornerRadius = 5;
     self.txtPassword.secureTextEntry = YES;
}

-(void) prepareLoadIndicator
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 2)
    {
        [self performLogin:nil];
    }
    
}

- (IBAction)performRegisteration:(id)sender
{
    [self loadRegistrationView];
}


- (IBAction)performLogin:(id)sender {
    
    [self.btnRegister setEnabled:NO];
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    [self prepareLoadIndicator];
    NSMutableDictionary *parameters = [self getUserLoginData];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kLoginServiceKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    [self.HUD show:YES];
}


-(NSMutableDictionary *) getUserLoginData
{
    NSString *userName =[[NSString alloc]initWithString:self.txtUserName.text];
    NSString *password = [[NSString alloc] initWithString:self.txtPassword.text];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:userName forKey:@"userName"];
    [parameters setObject:password forKey:@"password"];
     NSString *token = [[self.userData.notificationToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    if(token)
       
        [parameters setObject:token forKey:@"deviceId"];
    
    else
        [parameters setObject:@"" forKey:@"deviceId"];

    [parameters setObject:@"ios" forKey:@"deviceType"];
    return parameters;
}
-(void) loadAppropriateView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.homeViewController = (HomeViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:self.homeViewController animated:YES];
}
#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    [self.HUD removeFromSuperview];
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
    [self initializeModals];
    [self initializeObjects:responsedata];
    [self.btnRegister setEnabled:NO];
     NSDictionary *responseDetails = [responsedata valueForKey:@"data"];
    if([status isEqualToString:@"success"])
    {
        [self.userData saveUserId:[responseDetails valueForKey:@"userId"]];
        [self.userProfileData saveUserId:[responseDetails valueForKey:@"userId"]];
        [self savePreferences:responseDetails];
        
        NSDictionary *address= [responseDetails valueForKey:@"addresses"];
        NSDictionary *userProfile = [responseDetails valueForKey:@"user"];
        [self saveUserProfile:userProfile];
        [self saveAddress:address];
        [self loadAppropriateView];
    }
    else if([status isEqualToString:@"error"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials!"
                                                            message:@"Username or password doesn't match"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView setDelegate:self];
        [alertView show];
    }
    
}
- (void)serviceCallCompletedWithError:(NSError *)error
{
    [self.btnRegister setEnabled:NO];
    NSLog(@"%@",error.description);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!"
                                                        message:@"Could not connect to the server.Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView setDelegate:self];
    [alertView show];
    
}

#pragma mark - save UserProfile Data

-(void) saveUserProfile:(NSDictionary *) response
{
    NSString *cellPhone = [response valueForKey:@"cellPhone"];
     NSString *description = [response valueForKey:@"description"];
    NSString *emailId = [response valueForKey:@"emailId"];
    NSString *userPoints = [response valueForKey:@"userPoints"];
    NSString *vendorPoints = [response valueForKey:@"vendorPoints"];
    NSString *userName = [response valueForKey:@"name"];
    NSString *rating = [response valueForKey:@"rating"];
    
    [self.userProfileData saveFullName:userName];
    
    [self.userProfileData saveUserPoints:userPoints];
    [self.userProfileData saveVendorPoints:vendorPoints];
    [self.userProfileData savePhoneNumber:cellPhone];
    [self.userProfileData saveEmail:emailId];
    [self.userProfileData saveUserDescription:description];
    [self.userProfileData saveUserRating:rating];    
  
}

#pragma mark - save User Preferences
-(void)savePreferences:(NSDictionary *) responseDetails
{
    NSDictionary *userPreferences = [responseDetails valueForKey:@"userPreferences"];
    NSDictionary *requesterPreferences = [userPreferences valueForKey:@"requesterSettings"];
    NSDictionary *vendorPreferences = [userPreferences valueForKey:@"vendorSettings"];
    NSArray *vendorCategories = [userPreferences valueForKey:@"vendorCategories"];
    
    [self.userData saveUserSettingId:[requesterPreferences valueForKey:@"userSettingId"]];
    [self.userData saveRequesterRadius:[requesterPreferences valueForKey:@"requesterRadius"]];
    
    [self.vendorData saveVendorCategories:[vendorCategories mutableCopy]];
    [self.vendorData saveVendorSettingsId:[vendorPreferences valueForKey:@"userSettingId"]];
    [self.vendorData saveVendorRadius:[vendorPreferences valueForKey:@"vendorRadius"]];
}

#pragma mark - save User Address
-(void) saveAddress:(NSDictionary *) addresses
{
    NSDictionary *homeAddress = [addresses valueForKey:@"homeAddress"];
   [self.userData saveUserHomeAddress:[homeAddress valueForKey:@"address"]];
    [self.userData saveUserAddressId:[homeAddress valueForKey:@"userAddressId"]];
    
    [self.userProfileData saveAddress:[homeAddress valueForKey:@"address"]];
    [self.userData saveUserAddressId:[homeAddress valueForKey:@"userAddressId"]];
    
}
-(void) loadRegistrationView
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.registrationController = (RegistrationViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    [self.navigationController pushViewController:self.registrationController animated:YES];
}
-(void) initializeModals
{
    self.userData.isRequestViewShown = NO;
    self.bidDetails = [[BidDetails alloc]init];
    
}
-(void) initializeObjects:(NSDictionary *) responseData
{
     responseData = [responseData valueForKey:@"data"];
    
    BOOL isVendor = [[responseData valueForKey:@"isVendorRegistered"] boolValue];
    
    if(isVendor)
         self.userData.isVendor = YES;
    else
         self.userData.isVendor = NO;
   
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

-(void) facebookLogin{
   
   
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    self.fbLoginView = [[FBSDKLoginButton alloc] init];
    
    //self.fbLoginView.delegate = self;
    
}
- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error
{
    NSLog(@"result %@",result);
}

@end
