//
//  VendorTableViewController.m
//  Neighbour
//
//  Created by ravi pitapurapu on 12/16/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "VendorPreferencesTableViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "VendorData.h"
#import "SettingsTableCell.h"
#import "RadiusTableViewCell.h"

@interface VendorPreferencesTableViewController ()<ServiceProtocol,UITableViewDelegate>

@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableSet *categorySettings;
@property (nonatomic,strong) NSMutableArray *categorySetting;
@property (weak, nonatomic) UITextField *radiusTextField;

@end

@implementation VendorPreferencesTableViewController

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
    self.categorySettings = [[NSMutableSet alloc] init];
    self.categorySetting = [[NSMutableArray alloc] init];
    for(int i=0;i<4;i++)
    {
        [self.categorySetting addObject:@"NO"];
    }
    for(NSDictionary *eachDict in [self.vendorData vendorCategories])
    {
        self.categorySetting[[[eachDict valueForKey:@"categoryId"] integerValue ] - 1] = @"YES";
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 1)
    {
         return 4;
    }
    return 1;
}

- (IBAction)categorySettingChanged:(UISwitch *)sender
{
    if(!sender.on)
    {
        
        self.categorySetting[sender.tag - 1] = @"NO";
//        [self.categorySettings addObject:[@(sender.tag) stringValue]];
    }
    else
    {
        self.categorySetting[sender.tag  - 1] = @"YES";
//        if([self.categorySettings containsObject:[@(sender.tag) stringValue]])
//            [self.categorySettings removeObject:[@(sender.tag) stringValue]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    RadiusTableViewCell *radiusCell;
    SettingsTableCell *scell;
    
    if(indexPath.section == 0)
    {
        radiusCell = (RadiusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RadiusTableViewCell" forIndexPath:indexPath];
        radiusCell.txtRadius.text= [@([self.vendorData.vendorRadius integerValue]) stringValue];
        self.radiusTextField = radiusCell.txtRadius;
        
        return radiusCell;
        //radiusTextField.textf
    }
    
    else if(indexPath.section == 1)
    {
        BOOL isCategoryFound = NO;
        scell = (SettingsTableCell *)[tableView dequeueReusableCellWithIdentifier:@"SettingsTableCell" forIndexPath:indexPath];
        for(NSDictionary *eachDict in [self.vendorData vendorCategories])
        {
            if([[eachDict valueForKey:@"categoryId"] integerValue] == (indexPath.row+1))
            {
                isCategoryFound = YES;
                break;
            }
        }
        
        if(isCategoryFound)
         scell.controlSwitch.on = true;
        
         if(indexPath.section == 1 && indexPath.row == 0)
        {
            scell.imageView.image =[UIImage  imageNamed:@"rigid_baby.png"];
            scell.lblCategoryTitle.text= @"Child Care";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 1 && indexPath.row == 1)
        {
            scell.imageView.image =[UIImage  imageNamed:@"pet.png"];
            scell.lblCategoryTitle.text= @"Pet Care";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 1 && indexPath.row == 2)
        {
            scell.imageView.image =[UIImage  imageNamed:@"textbook.png"];
            scell.lblCategoryTitle.text= @"Sell Books";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        else if(indexPath.section == 1 && indexPath.row == 3)
        {
            scell.imageView.image =[UIImage  imageNamed:@"tutor.png"];
            scell.lblCategoryTitle.text= @"Tutor";
            scell.controlSwitch.tag = indexPath.row+1;
        }
        return scell;
    }
    else if(indexPath.section == 2)
        cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateCell" forIndexPath:indexPath];
    
    return cell;
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (section == 1)
        {
            return @"Categories";
        }
    return @"";
}
- (IBAction)updateBtnTapped:(id)sender
{
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParametersVendorPreferences];
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kUpdatePreferences];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    
}
-(NSMutableDictionary *) prepareParametersVendorPreferences
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:@"2" forKey:@"roleId"];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:[@([self.radiusTextField.text integerValue]) stringValue]  forKey:@"vendorRadius"];
    [parameters setValue:[self.vendorData userSettingId] forKey:@"userSettingId"];
    
    parameters = [self prepareCategoriesData:parameters];
    return parameters;
}

-(NSMutableDictionary *)prepareCategoriesData:(NSMutableDictionary *) parmeters
{
    
//    NSMutableArray *copyOfCategories = [NSMutableArray arrayWithArray:self.vendorData.vendorCategories];
//    NSMutableArray *allSetObjects = [[self.categorySettings allObjects] mutableCopy];
//    
//    NSMutableSet *addedCategories = [[NSMutableSet alloc] init];
    NSMutableArray *categoryList = [[NSMutableArray alloc] init];
    if([self.vendorData vendorCategories].count >0)
    {
        
        for(int l=0;l<self.categorySetting.count;l++)
        {
            
            for(NSDictionary *eachDict in   self.vendorData.vendorCategories)
            {
                if([[eachDict valueForKey:@"categoryId"] intValue] == l+1)
                {
                    NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
                    
                    if([self.categorySetting[l] isEqual:@"NO"])
                    {
                        [categoryObject setObject:[eachDict valueForKey:@"categoryId"] forKey:@"categoryId"];
                        [categoryObject setObject:[eachDict valueForKey:@"vendorCategoryId"] forKey:@"vendorCategoryId"];
                        [categoryObject setObject:[NSNumber numberWithBool:YES] forKey:@"deleted"];
                        [categoryList addObject:categoryObject];
                    }

                }
                else
                {
                    if([self.categorySetting[l] isEqual:@"YES"])
                    {
                        NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
                        NSNumber *categoryId = [[NSNumber alloc] initWithInt:l+1];
                        [categoryObject setObject:[categoryId stringValue]  forKey:@"categoryId"];
                        [categoryList addObject:categoryObject];
                    }
                }
            }
        }
        
//        for(int l=0;l<self.categorySetting.count;l++)
//        {
//            BOOL isCategoryPresent = NO;
//            for(NSDictionary *eachDict in   self.vendorData.vendorCategories)
//                {
//                    if([[eachDict valueForKey:@"categoryId"] intValue] == l+1 )
//                    {
//                        NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
//                        [categoryObject setObject:[eachDict valueForKey:@"categoryId"] forKey:@"categoryId"];
//                        [categoryObject setObject:[eachDict valueForKey:@"vendorCategoryId"] forKey:@"vendorCategoryId"];
//                        
//                        isCategoryPresent = YES;
//                        if([self.categorySetting[l] isEqual:@"NO"])
//                            [categoryObject setObject:[NSNumber numberWithBool:NO] forKey:@"deleted"];
//                        if([self.categorySetting[l] isEqual:@"YES"])
//                            [categoryObject setObject:[NSNumber numberWithBool:YES] forKey:@"deleted"];
//                        [categoryList addObject:categoryObject];
//                        
//                        break;
//                    }
//                    
//                }
//                if([self.categorySetting[l] isEqual:@"NO"] && !isCategoryPresent)
//                {
//                    NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
//                    [categoryObject setObject:[@(l+1) stringValue] forKey:@"categoryId"];
//                    [categoryList addObject:categoryObject];
//                }
//
//                
//            }
        
      
        [parmeters setValue:categoryList forKey:@"vendorCategories"];
        
//        for(NSString *eachCategory in self.categorySetting)
//        {
//           
//            for(NSDictionary *eachDict in   self.vendorData.vendorCategories)
//            {
//                if([eachCategory isEqual:[eachDict valueForKey:@"categoryId"]])
//                {
//                    isCategoryPresent = YES;
//                    NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
//                    [categoryObject setObject:[eachDict valueForKey:@"categoryId"] forKey:@"categoryId"];
//                    [categoryObject setObject:[eachDict valueForKey:@"vendorCategoryId"] forKey:@"vendorCategoryId"];
//                    [categoryObject setObject:[@(true) stringValue] forKey:@"deleted"];
//                    [categoryList addObject:categoryObject];
//                    
//                    break;
//                }
//            }
//            
//            if(!isCategoryPresent)
//            {
//                
//                
//                NSMutableDictionary *categoryObject =[[NSMutableDictionary alloc]init];
//                [categoryObject setObject:eachCategory forKey:@"categoryId"];
//                [categoryList addObject:categoryObject];
//            }
//         
//            [parmeters setValue:copyOfCategories forKey:@"vendorCategories"];
//        }
    }
    else
    {
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
    }
    return parmeters;
}

#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
    NSDictionary *responseDetails = [responsedata valueForKey:@"data"];
    if([status isEqualToString:@"success"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Updated VendorSettings!"
                                                            message:@"Successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        
        NSDictionary *userPreferences = [responseDetails valueForKey:@"userPreferences"];
        NSArray *categorySettings = [userPreferences valueForKey:@"vendorCategories"];
        
        [self.vendorData saveVendorCategories:[categorySettings mutableCopy]];
        
        [alertView setDelegate:self];
        [alertView show];
        
    }
    else if([status isEqualToString:@"error"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Parameters!"
                                                            message:@"Check categories and radius"
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
