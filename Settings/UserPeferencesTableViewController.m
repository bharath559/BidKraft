//
//  UserPeferencesTableViewController.m
//  Neighbour
//
//  Created by ravi pitapurapu on 12/15/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "UserPeferencesTableViewController.h"
#import "UserSettingsTableViewCell.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "VendorData.h"

@interface UserPeferencesTableViewController ()<ServiceProtocol>

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) UITextField *radius;

@end

@implementation UserPeferencesTableViewController

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
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserSettingsTableViewCell *raduisCell;
    UITableViewCell *cell;
    
    if(indexPath.item == 0)
    {
        raduisCell = [tableView dequeueReusableCellWithIdentifier:@"RadiusCell" forIndexPath:indexPath];
        raduisCell.txtRadius.text = [@([self.userData.requesterRadius integerValue]) stringValue];
        self.radius =  raduisCell.txtRadius;
        return raduisCell;
    }
    else if(indexPath.item == 1)
         cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell" forIndexPath:indexPath];
    
    return cell;
}

- (IBAction)updateBtnTapped:(id)sender
{
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    
    NSMutableDictionary *parameters = [self prepareParametersUserPreferences];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kUpdatePreferences];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}
-(NSMutableDictionary *) prepareParametersUserPreferences
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:@"1" forKey:@"roleId"];
    [parameters setValue:self.userData.userId forKey:@"userId"];
    [parameters setValue:[@([self.radius.text integerValue]) stringValue] forKey:@"requesterRadius"];
    [parameters setValue:[@([self.userData.userSettingId integerValue]) stringValue] forKey:@"userSettingId"];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"User Preferences Updated!"
                                                            message:@"Successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView setDelegate:self];
        [alertView show];

    }
    else if([status isEqualToString:@"error"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"Enetered Fields Doesnt match"
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

@end
