//
//  RegistrationViewController.m
//  Neighbour
//
//  Created by Bharath kongara on 10/3/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "RegistrationViewController.h"
#import "User.h"
#import "ServiceManager.h"
#import "RegistrationTableViewCell.h"
#import "ServiceURLProvider.h"
#import "HomeViewController.h"
#import "RegistrationDropDownCell.h"

@interface RegistrationViewController ()<UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate,ServiceProtocol,UIAlertViewDelegate,RegistrationDropDownDelegate>
@property (strong, nonatomic) IBOutlet UIView *tblheaderContainer;
@property (strong, nonatomic) IBOutlet UITableView *registrationTableView;
@property (strong, nonatomic) IBOutlet UIView *tblFooterContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UINavigationItem *registrationCancel;

@property (nonatomic, strong) User *userData;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *flags;
@property (nonatomic, strong) ServiceManager *manager;
@property (nonatomic,strong) HomeViewController *homeViewController;
@property (nonatomic, strong) NSMutableArray *dropDownList;

@end

@implementation RegistrationViewController

NSInteger indexOfCurrentActiveTextField;


- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareData];
    self.registrationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBarHidden = NO;
//    
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
//    
//    UIBarButtonItem *rightBarButton;
//   
//        rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStylePlain target:self action:@selector(closeTapped:)];
//        
//    
//    
//    [self.registrationCancel setRightBarButtonItem:rightBarButton];
    
}


- (void)prepareData
{
    self.textFieldArray = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    
    [self.data addObject:@"UserName"];
    [self.data addObject:@"Password"];
    [self.data addObject:@"Reenter Password"];
    [self.data addObject:@"Full Name"];
    [self.data addObject:@"Email"];
    [self.data addObject:@"Mobile Number"];
    self.btnContinue.layer.cornerRadius = 5.0f;
    self.flags = [[NSMutableArray alloc] initWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RegistrationTableViewCell *cell;
        cell = (RegistrationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RegistrationCell" forIndexPath:indexPath];
        cell.txtInputField.placeholder = [self.data objectAtIndex:indexPath.row];
        cell.txtInputField.delegate = self;
        if(indexPath.row == 1 || indexPath.row == 2 )
            cell.txtInputField.secureTextEntry = YES;
    
        [self.textFieldArray addObject:cell.txtInputField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *returnValue;
            returnValue = self.tblheaderContainer;
    
    returnValue.hidden = NO;
    
    return returnValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat returnValue;
    
        returnValue = self.tblheaderContainer.frame.size.height;
    
    return returnValue;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *returnValue;
            returnValue = self.tblFooterContainer;
    
    returnValue.hidden = NO;
    return returnValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return self.tblFooterContainer.frame.size.height;
    
}

- (IBAction)RegisterationTapped:(id)sender {
    
    
    NSMutableDictionary *parameters = [self prepareParameters];
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    
    NSString *url = [ServiceURLProvider getURLForServiceWithKey:kRegistrationKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}

-(void) closeTapped :(UIBarButtonItem *) button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSMutableDictionary *) prepareParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    UITextField *requiredTextField =(UITextField *) [self.textFieldArray  objectAtIndex:0];
    
    [parameters setObject:requiredTextField.text forKey:@"userName"];
    
    requiredTextField = [self.textFieldArray  objectAtIndex:1];
    [parameters setObject:requiredTextField.text forKey:@"password"];
    requiredTextField = [self.textFieldArray  objectAtIndex:3];
    
    [parameters setObject:requiredTextField.text forKey:@"name"];
    
    requiredTextField = [self.textFieldArray  objectAtIndex:4];
    
    [parameters setObject:requiredTextField.text  forKey:@"emailId"];
    
    requiredTextField = [self.textFieldArray  objectAtIndex:5];

     [parameters setObject:requiredTextField.text  forKey:@"cellPhone"];
    
    return parameters;

}

#pragma mark - Utility Methods
- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

- (void)showAlertWithMessage:(NSString *)message andTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)verifyFields
{
    BOOL returnValue;
    for (int i=0 ; i < self.flags.count; i++)
        [self textFieldDidEndEditing:[self.textFieldArray objectAtIndex:i]];
    
    if([self.flags containsObject:@"0"])
        [self showAlertWithMessage:@"Please fill in all fields in red to continue." andTitle:@"Invalid fields in form"];
    else
        returnValue = YES;
    
    [self resignFirstResponder];
    
    return returnValue;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //indexOfCurrentActiveTextField = [self.textFieldArray indexOfObject:textField];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch ([self.data indexOfObject:textField.placeholder]) {
        case 0:
            
            if(textField.text.length >0)
                [self handleValidationClearOnTextField:textField atIndex:0];
            else
                [self handleValidationIssueOnTextField:textField atIndex:0];
            
            break;
        case 1:
            
            if(textField.text.length > 0)
                [self handleValidationClearOnTextField:textField atIndex:1];
            else
                [self handleValidationIssueOnTextField:textField atIndex:1];
            
            break;
        case 2:
        {
            UITextField *passwordTextField = [self.textFieldArray objectAtIndex:1];
            if(textField.text.length > 0 && [passwordTextField.text isEqualToString:textField.text])
                [self handleValidationClearOnTextField:textField atIndex:2];
            else
                [self handleValidationIssueOnTextField:textField atIndex:2];
            break;
        }
        case 3:
            
            if(textField.text.length>0)
                [self handleValidationClearOnTextField:textField atIndex:3];
            else
                [self handleValidationIssueOnTextField:textField atIndex:3];
            
            break;
        case 4:
            
            if([self validateEmail:textField.text])
                [self handleValidationClearOnTextField:textField atIndex:4];
            else
                [self handleValidationIssueOnTextField:textField atIndex:4];
            
            break;
        case 5:
            
            if(textField.text.length == 10)
                [self handleValidationClearOnTextField:textField atIndex:5];
            else
                [self handleValidationIssueOnTextField:textField atIndex:5];
            
            break;
            
        default:
            break;
    }
    
}

- (void)handleValidationIssueOnTextField:(UITextField *)textField atIndex:(NSInteger)index
{
    [self.flags replaceObjectAtIndex:index withObject:@"0"];
    textField.backgroundColor = [UIColor redColor];
}

- (void)handleValidationClearOnTextField:(UITextField *)textField atIndex:(NSInteger)index
{
    [self.flags replaceObjectAtIndex:index withObject:@"1"];
    textField.backgroundColor = [UIColor whiteColor];
}

#pragma mark ServiceProtocol methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    //NSDictionary *data = (NSDictionary *)[responsedata valueForKey:@"data"];
    NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"status"]];
    NSDictionary *responseDetails = [responsedata valueForKey:@"data"];
    if([status isEqualToString:@"success"])
        
    {
        //[self.userData saveRoleId:[responseDetails valueForKey:@"roleId"]];
        [self.userData saveUserId:[responseDetails valueForKey:@"userId"]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Registeration Completed!"
                                                            message:@"Welcome Have a great journey with us"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView setDelegate:self];
        alertView.tag = 1;
        [alertView show];
    }
    
    else if([status isEqualToString:@"error"])
    {
        
        NSString *errorMessage = [responsedata valueForKey:@"message"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Details!"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        [alertView setDelegate:self];
        alertView.cancelButtonIndex = 2;
        alertView.tag = 2;
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
    alertView.cancelButtonIndex = 2;
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0 && alertView.tag == 1)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        self.homeViewController = (HomeViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self.navigationController pushViewController:self.homeViewController animated:YES];
    }
}
@end
