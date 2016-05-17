//
//  VendorRegistrationViewController.m
//  BidKraft
//
//  Created by Bharath Kongara on 6/19/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "VendorRegistrationViewController.h"
#import "SettingsTableCell.h"
#import "RadiusTableViewCell.h"
#import "AddressTableViewCell.h"
#import <MapKit/MapKit.h>
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "PhoneTableViewCell.h"
#import "VendorViewController.h"

@interface VendorRegistrationViewController ()<ServiceProtocol,UITextFieldDelegate>

@property (weak, nonatomic) UITextField *radiusTextField;
@property (strong,nonatomic) NSMutableArray *categorySetting;
@property (weak, nonatomic) SZTextView *txtAddressView;

@property (nonatomic,strong) NSString *lattitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic, strong) User *userData;
@property (nonatomic,strong) UITextField *vendorOfficeAddress;

@property (strong, nonatomic) IBOutlet UIView *footerView;



@end

@implementation VendorRegistrationViewController

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;
    self.categorySetting = [[NSMutableArray alloc] init];
    
    for(int i=0;i<4;i++)
        [self.categorySetting addObject:@"NO"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 2)
        return 4;
    else if(section == 3)
        return 2;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RadiusTableViewCell *radiusCell;
    SettingsTableCell *scell;
    AddressTableViewCell *addressCell;
    UITableViewCell *cell;
    PhoneTableViewCell *pcell;
    
    
    if(indexPath.section == 0)
    {
        pcell = (PhoneTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"PhoneTableViewCell" forIndexPath:indexPath];
        self.vendorOfficeAddress = pcell.txtPhoneNumnber;
        self.vendorOfficeAddress.delegate = self;
        return pcell;
           
    }
    else if(indexPath.section == 1)
    {
        addressCell = (AddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];
        
        addressCell.txtAddressView.placeholder = @"Address";
        self.txtAddressView = addressCell.txtAddressView;
        
        return addressCell;
    }
    else if(indexPath.section == 2)
    {
        
        scell = (SettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsTableCell" forIndexPath:indexPath];
        
        if(indexPath.section == 2 && indexPath.row == 0)
        {
            scell.imageView.image =[UIImage  imageNamed:@"rigid_baby.png"];
            scell.lblCategoryTitle.text= @"Child Care";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 2 && indexPath.row == 1)
        {
            scell.imageView.image =[UIImage  imageNamed:@"pet.png"];
            scell.lblCategoryTitle.text= @"Pet Care";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 2 && indexPath.row == 2)
        {
            scell.imageView.image =[UIImage  imageNamed:@"textbook.png"];
            scell.lblCategoryTitle.text= @"Sell Books";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 2 && indexPath.row == 3)
        {
            scell.imageView.image =[UIImage  imageNamed:@"tutor.png"];
            scell.lblCategoryTitle.text= @"Tutor";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        
        return scell;
    }
    else if(indexPath.section == 3)
    {
        
        if(indexPath.section == 3 && indexPath.row == 0)
        {
            radiusCell = (RadiusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RadiusTableViewCell" forIndexPath:indexPath];
            self.radiusTextField = radiusCell.txtRadius;
            
            return radiusCell;
            
        }
        else if(indexPath.section == 3 && indexPath.row == 1)
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell" forIndexPath:indexPath];
            return cell;
        }
       
    }
    return scell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   
    if(section ==0)
        return @"Work Phone Number";
    else if(section == 1)
        return @"Address";
    else if (section == 2)
        return @"Categories";
    else if (section == 3)
        return @"Radius";

    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(indexPath.section == 1)
    {
        return 120;
    }
    
    return 44;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
- (IBAction)categorySettingsChanged:(UISwitch *)sender {
    
    if(!sender.on)
        self.categorySetting[sender.tag - 1] = @"NO";
    else
        self.categorySetting[sender.tag  - 1] = @"YES";
}

- (IBAction)vendorRegisterTapped:(id)sender {
    
    [self convertAddressToLatLong];
    
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

-(void) convertAddressToLatLong
{
    CLGeocoder  *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.txtAddressView.text
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
                             url = [ServiceURLProvider getURLForServiceWithKey:kVendorRegister];
                             [self.manager serviceCallWithURL:url andParameters:parameters];
                         }
                     }
                 }];
}
-(NSMutableDictionary *) prepareParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.userData.userId forKey:@"userId"];
    [parameters setValue:self.vendorOfficeAddress.text forKey:@"workPhone"];
    [parameters setValue:self.radiusTextField.text forKey:@"vendorRadius"];
    
    NSMutableDictionary *homeAddress = [[NSMutableDictionary alloc] init];
    [homeAddress setValue:self.lattitude forKey:@"latitude"];
    [homeAddress setValue:self.longitude forKey:@"longitude"];
    [homeAddress setValue:self.txtAddressView.text forKey:@"address"];
    
    [parameters setValue:homeAddress forKey:@"address"];
    
    
    parameters = [self prepareCategoriesData:parameters];
    
    return parameters;
}

-(NSMutableDictionary *)prepareCategoriesData:(NSMutableDictionary *) parmeters
{
    NSMutableArray *categoryList = [[NSMutableArray alloc] init];
    for(int m=0;m<self.categorySetting.count;m++)
    {
        NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
        if([self.categorySetting[m] isEqual:@"YES"])
        {
            NSNumber *categoryId = [[NSNumber alloc] initWithInt:m+1];
            [categoryObject setObject:categoryId forKey:@"categoryId"];
            [categoryList addObject:categoryObject];
        }
    }
    [parmeters setValue:categoryList forKey:@"vendorCategories"];
    return parmeters;
}

#pragma mark - ServiceProtocol Methods


- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if([status isEqualToString:@"success"])
    {
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
