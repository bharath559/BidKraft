//
//  CreateRequestViewController.m
//  Neighbour
//
//  Created by Bharath Kongara on 3/22/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "CreateRequestViewController.h"
#import "IQDropDownTextField.h"
#import "HomeViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "NSDate+Utilities.h"

@interface CreateRequestViewController ()<UIAlertViewDelegate,AMTagListDelegate,ServiceProtocol,UITextViewDelegate,UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet  IQDropDownTextField *btnRequestedDate;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *btnBiddingEnds;
@property (weak, nonatomic) IBOutlet UINavigationItem *currentNavigationItem;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTag;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtRequestEndTime;
@property (weak, nonatomic) IBOutlet UITextField *txtJobTitle;


@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic, strong) AMTagView *selection;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSDictionary *responsedata;
@property (nonatomic,strong) NSArray *tagList;

@end

@implementation CreateRequestViewController


- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Create Request";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitTapped)];
    
    [self.navigationItem setRightBarButtonItem:anotherButton];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];

    [self configureDropDown];
    [self designTags];
    [self designUI];
    self.txtDescription.delegate = self;
    self.tagList = [[NSMutableArray alloc] init];
}
-(void) viewWillAppear:(BOOL)animated
{
    if([self.categoryType isEqualToString:@"Baby Sitting"])
    {
       self.tagList =@[@"Child Care",@"Baby"];
    }
    else if([self.categoryType isEqualToString:@"Pet Care"])
    {
        self.tagList =@[@"Pet Care",@"Pet"];
        
    }
    else if([self.categoryType isEqualToString:@"Tutor"])
    {
       self.tagList =@[@"Tutoring",@"Classes"];
        
    }
    else if([self.categoryType isEqualToString:@"Sell Books"])
    {
        self.tagList =@[@"Books",@"College"];
    }
}

#pragma design UI Elements

- (void)designUI
{
    self.btnAddTag.layer.cornerRadius = self.btnAddTag.frame.size.width/2.0;
    //[self.txtDescription setContentOffset: CGPointMake(0,-220) animated:NO];
    //self.txtDescription.contentInset = UIEdgeInsetsMake(2.0,1.0,0,0.0);
}
- (void)designTags
{
    [[AMTagView appearance] setTagLength:05];
    [[AMTagView appearance] setTextPadding:5];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:[UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f]];
    
    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"close"]];
    self.tagListView.tagListDelegate = self;
    
    __weak CreateRequestViewController* weakSelf = self;
    [self.tagListView setTapHandler:^(AMTagView *view) {
        weakSelf.selection = view;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:[NSString stringWithFormat:@"Delete %@?", [view tagText]]
                                                       delegate:weakSelf
                                              cancelButtonTitle:@"Nope"
                                              otherButtonTitles:@"Sure!", nil];
        alert.tag = 2;
        [alert show];
    }];
    
}

-(void) configureDropDown
{
    self.btnRequestedDate.dropDownMode = IQDropDownModeDatePicker;
    self.btnBiddingEnds.dropDownMode = IQDropDownModeDatePicker;
    [self.btnBiddingEnds setBorderStyle:UITextBorderStyleNone];
    [self.txtRequestEndTime setBorderStyle:UITextBorderStyleNone];
    [self.btnRequestedDate setBorderStyle:UITextBorderStyleNone];
    
    
    self.btnRequestedDate.minimumDate = [NSDate date];
    self.btnBiddingEnds.minimumDate = [NSDate date];
    [self.btnRequestedDate setDatePickerMode:UIDatePickerModeDateAndTime];
    [self.btnBiddingEnds setDatePickerMode:UIDatePickerModeDateAndTime];
    
    self.txtRequestEndTime.dropDownMode = IQDropDownModeDatePicker;
    self.txtRequestEndTime.minimumDate = [NSDate date];
    [self.txtRequestEndTime setDatePickerMode:UIDatePickerModeDateAndTime];
    
    self.txtRequestEndTime.delegate = self;
    self.btnRequestedDate.delegate  = self;
    self.btnBiddingEnds.delegate = self;
}

-(void) submitTapped
{
    
    
    if([self.txtDescription.text  isEqual: @""] || self.btnRequestedDate.text == nil || self.txtRequestEndTime.text == nil || self.btnBiddingEnds.text == nil || [self.btnRequestedDate.text isEqual:@""] || [self.txtRequestEndTime.text isEqual:@""] || [self.btnBiddingEnds.text isEqual:@""] )
    {
        UIAlertView *addTagAlert = [[UIAlertView alloc]initWithTitle:@"Incorrect Fields" message:@"Please enter all field correctly" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [addTagAlert show];
    }
    else
    {
        self.manager = [ServiceManager defaultManager];
        self.manager.serviceDelegate = self;
        NSMutableDictionary *parameters = [self prepareParmeters];
        NSString *url = [ServiceURLProvider getURLForServiceWithKey:kCreateRequestKey];
        
        [self.manager serviceCallWithURL:url andParameters:parameters];
    }
    
}

-(NSMutableDictionary *) prepareParmeters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
       [parameters setObject:self.categoryId forKey:@"categoryId"];
        [parameters setObject:self.userData.userId forKey:@"requesterUserId"];
        [parameters setObject:self.txtDescription.text forKey:@"description"];
        [parameters setObject:[self makeRequiredDateFormat:self.btnRequestedDate.text] forKey:@"requestStartDate"];
        [parameters setObject:[self makeRequiredDateFormat:self.txtRequestEndTime.text] forKey:@"requestEndDate"];
        [parameters setObject:[self makeRequiredDateFormat:self.btnBiddingEnds.text] forKey:@"bidEndDateTime"];
    
    
        if([self.txtJobTitle.text isEqualToString:@""])
        {
            if([self.categoryType isEqualToString:@"Baby Sitting"]){
               [parameters setObject:@"Need Baby Sitter" forKey:@"jobTitle"];
            }
            else if([self.categoryType isEqualToString:@"Pet Care"]){
               [parameters setObject:@"Need Pet Care" forKey:@"jobTitle"];
            }
            else if([self.categoryType isEqualToString:@"Tutor"]){
              [parameters setObject:@"Need Tutor" forKey:@"jobTitle"];
            }
            else if([self.categoryType isEqualToString:@"Sell Books"]){
              [parameters setObject:@"Sell Books" forKey:@"jobTitle"];
            }
        }
        else
            [parameters setObject:self.txtJobTitle.text forKey:@"jobTitle"];
        
        [parameters setObject:self.tagList forKey:@"tags"];
    //[self.tagListView tags]
    return parameters;
}

-(NSString *) makeRequiredDateFormat:(NSString *)oldDateFormat
{
    
    NSDateFormatter *datesFormatter = [[NSDateFormatter alloc] init];
    //[datesFormatter setDateFormat:@"MMM dd, yyyy, HH:mm:ss z"];
    [datesFormatter setDateStyle:NSDateFormatterMediumStyle];
    [datesFormatter setTimeStyle:NSDateFormatterLongStyle];
    [datesFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    
    NSDate *formattedDateString = [datesFormatter dateFromString:oldDateFormat];
    NSLog(@"formattedDateString: %@", formattedDateString);
//    NSString *stringAfterTrimmed = oldDateFormat;
//    NSDate *newDate = [[NSDate alloc] init];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/yyy"];
   // newDate = [dateFormatter dateFromString:stringAfterTrimmed];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"E, dd MMM yyyy HH:m:ss z"];
    NSString  *requiredDateString = [df stringFromDate:formattedDateString];
    return requiredDateString;
}

#pragma UITextFieldDelegate methods


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        
        NSDateFormatter *datesFormatter = [[NSDateFormatter alloc] init];
        //[datesFormatter setDateFormat:@"MMM dd, yyyy, HH:mm:ss z"];
        [datesFormatter setDateStyle:NSDateFormatterMediumStyle];
        [datesFormatter setTimeStyle:NSDateFormatterLongStyle];
        [datesFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
        
        NSDate * currentDate = [NSDate date];
        
        NSDate *formattedDateString = [datesFormatter dateFromString:textField.text];
       // NSComparisonResult result = [currentDate compare:formattedDateString];
        
        NSDate * twoHoursDate = [currentDate dateByAddingHours:2];
        
        NSComparisonResult resultComparision = [twoHoursDate compare:formattedDateString];
        if(resultComparision == NSOrderedAscending)
        {
           // [textField setText:textField.text];
            NSDate * requestEndDate = [formattedDateString dateByAddingHours:2];
            NSString *requestedEndDateString = [datesFormatter stringFromDate:requestEndDate];
            
            NSInteger diffDays = [currentDate distanceInDaysToDate:formattedDateString];
            
            NSDate *bindingEndDate = [formattedDateString dateByAddingDays:diffDays/2];
            NSString *bindingEndDateString = [datesFormatter stringFromDate:bindingEndDate];
            
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                       fromDate:currentDate
                                                         toDate:formattedDateString
                                                        options:0];
            
            NSLog(@"Difference in date components: %li/%li/%li", (long)components.day, (long)components.month, (long)components.year);
            
            self.btnBiddingEnds.text = bindingEndDateString;
            self.txtRequestEndTime.text = requestedEndDateString;
            
        }
        else if(resultComparision == NSOrderedDescending)
        {
            [textField setText:@""];
            textField.placeholder =@"Requested Date";
            UIAlertView *invalidDateAlert = [[UIAlertView alloc]initWithTitle:@"Invalid Date" message:@"Please Select Date More than two hours from now" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            invalidDateAlert.tag = 4;
            //invalidDateAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [invalidDateAlert show];
        }
    }
}


#pragma UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void) textViewDidBeginEditing:(UITextView *) textView
{
    [textView setText:@""];
    textView.contentInset = UIEdgeInsetsMake(-10.0,0.0,0,0.0);
}

#pragma Add Tags
- (IBAction)addTags:(id)sender
{
    [self.btnBiddingEnds resignFirstResponder];
    [self.btnRequestedDate resignFirstResponder];
    [self.txtRequestEndTime resignFirstResponder];
    
    UIAlertView *addTagAlert = [[UIAlertView alloc]initWithTitle:@"Tags" message:@"Create your own tag" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    addTagAlert.tag = 1;
    addTagAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addTagAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if(alertView.tag == 1 && buttonIndex > 0)
    {
        NSString *tagText = [[alertView textFieldAtIndex:0] text];
        [self.tagListView addTag:tagText];
    }
    else if (alertView.tag == 2 && buttonIndex > 0)
    {
        [self.tagListView removeTag:self.selection];
    }
    else if(alertView.tag == 3)
    {
        NSMutableDictionary *userData = [self.responsedata valueForKey:@"data"];
        NSMutableArray *requestsArray = [userData valueForKey:@"requests"];
        [self.userData saveUserOpenRequestsData:requestsArray];
        self.userData.reloadingAfterPost = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma AMTagListDelegate delegate

- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size
{
    // Don't add a 'bad' tag
    return ![text isEqualToString:@"bad"];
}

#pragma mark - ServiceProtocol Methods


- (void)serviceCallCompletedWithResponseObject:(id)response
{
    self.responsedata = (NSDictionary *)response;
    NSString *status = [response valueForKey:@"status"];
    
    if( [status isEqualToString:@"success"])
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                            message:@"Request Posted"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag =3;
        [alertView setDelegate:self];
        [alertView show];
        
    }
    else
    {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error!"
                                                            message:[response valueForKey:@"message"]
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
