//
//  ProfileViewController.m
//  BidKraft
//
//  Created by Bharath Kongara on 3/29/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "ProfileViewController.h"
#import <MapKit/MapKit.h>
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "UserProfile.h"
#import "User.h"
#import "ASStarRatingView.h"
#import "ProfileData.h"
#import "SZTextView.h"



@interface ProfileViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ServiceProtocol,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userPoints;
@property (weak, nonatomic) IBOutlet UILabel *vendorPoints;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet SZTextView *userDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;

@property (weak, nonatomic) IBOutlet SZTextView *txtUserEmail;
@property (weak, nonatomic) IBOutlet SZTextView *txtUserPhoneNumber;

@property (weak, nonatomic) IBOutlet SZTextView *txtUserAddress;
@property (weak, nonatomic) IBOutlet UINavigationItem *profileNavigationItem;
@property (weak, nonatomic) IBOutlet ASStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic,strong) UIImageView *temptumb;
@property (nonatomic,strong) UIImageView *fullview;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic, strong) UserProfile *userProfileData;
@property (nonatomic, strong) User *userData;
@property (nonatomic,strong) NSString *lattitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) UITextView *address;
@property (nonatomic,strong) ProfileData *profileData;
@property (nonatomic,strong) UIBarButtonItem *rightBarButton;

@end

@implementation ProfileViewController

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
- (ProfileData *)profileData
{
    if(!_profileData)
        _profileData = [ProfileData sharedData];
    
    return _profileData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTextViews];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
    
    if(self.isProfileShownModally)
    {
        self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTapped:)];
        self.btnPicture.userInteractionEnabled = NO;
        [self setProfileData];
    }
    else
    {
         self.rightBarButton  = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTapped:)];
         self.btnPicture.userInteractionEnabled = YES;
         [self setUserProfileData];
    }
    
    [self.profileNavigationItem setRightBarButtonItem:self.rightBarButton];
    self.imgProfile.layer.cornerRadius = (self.imgProfile.frame.size.width)/2;
    self.imgProfile.clipsToBounds = YES;
    
    //[self.navigationItem setRightBarButtonItem:anotherButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
   
    self.imgProfile.layer.cornerRadius = (self.imgProfile.frame.size.width)/2;
    self.imgProfile.clipsToBounds = YES;
    self.txtUserAddress.delegate = self;
    self.userDescription.delegate = self;
    
    //[self setUserProfileData];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
     [self disableEditing];
}

-(void) setUpTextViews
{
    self.userDescription.placeholder =@"User Description";
    self.txtUserEmail.placeholder = @"Email";
    self.txtUserName.placeholder = @"User Name";
    self.txtUserPhoneNumber.placeholder = @"Phone Number";
    self.txtUserAddress.placeholder = @"Address";
    
}

-(void) setProfileData
{
    long userPOints = [[self.profileData userPoints] longLongValue];
    long vendorPoints = [[self.profileData vendorPoints] longLongValue];
    
    if(![[self.profileData fullname] isEqualToString:@""])
        self.txtUserName.text = [self.profileData fullname];
    if(![[self.profileData email] isEqualToString:@""])
        self.txtUserEmail.text = [self.profileData email];
    
    
 if(![[self.profileData phoneNumber] isEqualToString:@""])
    self.txtUserPhoneNumber.text = [self.profileData phoneNumber];
    
 if(![[self.profileData address] isEqualToString:@""] && [self.profileData address])
    self.txtUserAddress.text = @"Address";
if(![[self.profileData userDescription] isEqualToString:@""])
    self.userDescription.text = [self.profileData userDescription];

    self.userPoints.text = [[@(userPOints) stringValue] stringByAppendingString:@"  User Points"];
    self.vendorPoints.text = [[@(vendorPoints) stringValue] stringByAppendingString:@" Vendor Points"];
    self.ratingView.rating = [self.profileData.userRating floatValue];
    
    //self.imgProfile.image = self.userProfileData.profilePicture;
}


-(void) setUserProfileData
{
    long userPOints = [[self.userProfileData userPoints] longLongValue];
    long vendorPoints = [[self.userProfileData vendorPoints] longLongValue];
    
    self.txtUserName.text = [self.userProfileData fullname];
    
     if(![[self.userProfileData email]isEqualToString:@""])
        self.txtUserEmail.text = [self.userProfileData email];
    
    if(![[self.userProfileData phoneNumber] isEqualToString:@""])
    
       self.txtUserPhoneNumber.text = [self.userProfileData phoneNumber];
    
    if(![[self.userProfileData address] isEqualToString:@""] && [self.userProfileData address])
        self.txtUserAddress.text = [self.userProfileData address];
    
    if(![[self.userProfileData userDescription] isEqualToString:@""] )
        self.userDescription.text = [self.userProfileData userDescription];
    
    self.userPoints.text = [[@(userPOints) stringValue] stringByAppendingString:@"  User Points"];
    self.vendorPoints.text = [[@(vendorPoints) stringValue] stringByAppendingString:@" Vendor Points"];
    self.ratingView.rating = [self.userProfileData.userRating floatValue];
    
    //self.imgProfile.image = self.userProfileData.profilePicture;
}
     
-(void) disableEditing
{
    [self.txtUserEmail setEditable:NO];
    self.txtUserName.enabled = NO;
    [self.txtUserPhoneNumber setEditable:NO];
    [self.txtUserAddress setEditable:NO];
    [self.userDescription setEditable:NO];
}
-(void) enableEditing
{
    [self.txtUserEmail setEditable:YES];
    self.txtUserName.enabled = YES;
    [self.txtUserPhoneNumber setEditable:YES];
    [self.txtUserAddress setEditable:YES];
    [self.userDescription setEditable:YES];
}

- (IBAction)captureImage:(id)sender {
   
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Choose From photos", @"Take Picture", nil];
    [actionSheet showInView:self.view];
    
}
#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.allowsEditing = YES;
    
    if([buttonTitle isEqualToString:@"Take Picture"])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
    else if( [buttonTitle isEqualToString:@"Choose From photos"])
    {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self.imgProfile setImage:chosenImage];
    [[self profilePictureDelegate] imageCpatured:chosenImage];
    [self.userProfileData saveProfilePicture:chosenImage];
    [self.imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) convertAddressToLatLong
{
    CLGeocoder  *geocoder = [[CLGeocoder alloc] init];
    //NSMutableDictionary *parametersList =[[NSMutableDictionary alloc]init];
    [geocoder geocodeAddressString:self.txtUserAddress.text
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if(error)
                     {
                       
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Address!"
                                                                             message:@"Enter valid address"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Ok"
                                                                   otherButtonTitles:nil, nil];
                         [alertView show];
                     }
                     else
                     {
                         for (CLPlacemark* aPlacemark in placemarks)
                         {
                             NSString *url;
                             CLLocation *location = [aPlacemark location];
                             CLLocationCoordinate2D coordinate = location.coordinate;
                             self.lattitude = [[NSString alloc ]initWithFormat:@"%f",coordinate.latitude];
                             self.longitude = [[NSString alloc ]initWithFormat:@"%f",coordinate.longitude];
                             self.manager = [ServiceManager defaultManager];
                             self.manager.serviceDelegate = self;
                             NSMutableDictionary *parameters = [self prepareParameters];
                             url = [ServiceURLProvider getURLForServiceWithKey:kUpdateProfile];
                             [self.manager serviceCallWithURL:url andParameters:parameters];
                         }
                     }
                 }];
}

-(void) editTapped :(UIBarButtonItem *) button
{
    [self enableEditing];
    UIBarButtonItem *rightBarButton;
    rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitTapped:)];
    [self.profileNavigationItem setRightBarButtonItem:rightBarButton];
    
}
-(void) submitTapped :(UIBarButtonItem *) button
{
   
    [self convertAddressToLatLong];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableDictionary *) prepareParameters
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.userData.userId forKey:@"userId"];
    [parameters setValue:self.txtUserName.text forKey:@"name"];
    [parameters setValue:self.userDescription.text forKey:@"description"];
    [parameters setValue:self.txtUserPhoneNumber.text forKey:@"cellPhone"];
    [parameters setValue:self.txtUserEmail.text forKey:@"emailId"];
    
    
    NSMutableDictionary *homeAddress = [[NSMutableDictionary alloc] init];
    [homeAddress setValue:[self.userData userAddressId]   forKey:@"userAddressId"];
    [homeAddress setValue:self.lattitude forKey:@"latitude"];
    [homeAddress setValue:self.longitude forKey:@"longitude"];
    [homeAddress setValue:self.txtUserAddress.text forKey:@"address"];
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setValue:homeAddress forKey:@"homeAddress"];
    
    [parameters setValue:addressDictionary forKey:@"addresses"];
    
    return parameters;
    
}
-(void) closeTapped :(UIBarButtonItem *) button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSMutableDictionary *) prepareParametersForProfile
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    return parameters;
    
}

#pragma UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
}
- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = (int)[mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    return length;
}

#pragma mark - ServiceProtocol Methods


- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if([status isEqualToString:@"success"])
    {
        self.rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTapped:)];
        [self.profileNavigationItem setRightBarButtonItem:self.rightBarButton];
        [self disableEditing];
        NSString *updated = [response valueForKey:@"message"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@" Updated!"
                                                            message:updated.description
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    else
    {
        NSString *error = [response valueForKey:@"message"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@" Error!"
                                                            message:error.description
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
