

#import "OpenRequestsTableViewController.h"
#import "User.h"
#import "RequestTableViewCell.h"
#import "RequestDetailViewController.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "ResultsSearchTableViewController.h"
#import "PayListViewController.h"


@interface OpenRequestsTableViewController ()<ServiceProtocol>

@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UserRequests *usrRequest;
@property (nonatomic,strong) NSString *bidId;

@property (nonatomic, strong) ResultsSearchTableViewController *resultsSearchTableViewController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation OpenRequestsTableViewController


- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

-(void)awakeFromNib
{
     [super awakeFromNib];
     self.userData.userRequestMode = OpenMode;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.userData.userRequestMode = OpenMode;
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    self.userRequests = [[[self.userData.userOpenRequests mutableCopy] arrayByAddingObjectsFromArray:[self.userData.userAcceptedRequests mutableCopy]]mutableCopy];
    if(self.userRequests.count == 0)
    {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return self.userRequests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundView = nil;
    static NSString* cellIdentifier;
    cellIdentifier = @"RequestCell";
     return [self prepareUserRequestsCell:self.tableView WithIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(RequestTableViewCell *) prepareUserRequestsCell:(UITableView *) tableView WithIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    RequestTableViewCell *cell =(RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(self.userRequests.count>0)
    {
        [cell prepareCellForTabelView:tableView atIndex:indexPath];
        [cell prepareTableCellData:cell withIndexPath :indexPath];
        
    }
    else
    {
        cell.textLabel.text = @"No Sources available.";
        cell.detailTextLabel.text = @"Please add sources and fund account.";
    }
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25.0f;
    if([cell.requestStatus isEqualToString:@"Open"])
    {
        cell.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:84.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }
    else if([cell.requestStatus isEqualToString:@"Accepted"])
    {
        cell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if([tableCell.requestStatus isEqualToString:@"Open"])
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
        self.requestDetailController = (RequestDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
        self.requestDetailController.requestId =  tableCell.requestId;
        [self.homeViewController.navigationController pushViewController:self.requestDetailController animated:YES];
    }
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *returnValue;
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    if([tableCell.requestStatus isEqualToString:@"Open"])
    {
        
        UITableViewRowAction *deleteAction;
        deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                          title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                              [self performDelete:indexPath onTableView:tableView];
                                                          }];
        deleteAction.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:2.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
        returnValue = @[deleteAction];

    }
    else if([tableCell.requestStatus isEqualToString:@"Accepted"])
    {
        UITableViewRowAction *completeAction;
        completeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                            title:@"Completed" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                [self performComplete:indexPath onTableView:tableView];
                                                            }];
        completeAction.backgroundColor =[UIColor colorWithRed:25.0f/255.0f green:123.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
        returnValue = @[completeAction];
    }
    
    return returnValue;
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void) performDelete:(NSIndexPath *)indexPath onTableView:(UITableView *)tableView
{
    [self.userRequests removeObjectAtIndex:indexPath.section];
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.requestIdToBeDeleted = tableCell.requestId ;
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParmeters];
    self.indexPath = indexPath;
    url = [ServiceURLProvider getURLForServiceWithKey:kDeleteRequest];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}

-(void) performComplete:(NSIndexPath *) indexPath onTableView:(UITableView *) tableView
{
    self.indexPath = indexPath;
    //self.commentsForVendor.layer.borderWidth = 0.7;
//    self.commentsForVendor.layer.borderColor = [UIColor grayColor].CGColor;
//    self.commentsForVendor.layer.cornerRadius = 6.5;
    RequestTableViewCell *cell =(RequestTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self getRequestDetails:cell.requestId];
    NSMutableDictionary *paymentDetails = [[NSMutableDictionary alloc]init];
    
    [paymentDetails setObject:[@(self.usrRequest.lowestBid) stringValue] forKey:@"bidAmountPay"];
    [paymentDetails setObject:self.usrRequest.acceptedBidId forKey:@"bidId"];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    PayListViewController *payListViewController = [storyBoard instantiateViewControllerWithIdentifier:@"PayListViewController"];
    payListViewController.bidAmount = self.usrRequest.lowestBid;
    payListViewController.bidId = self.usrRequest.acceptedBidId ;
    payListViewController.requestId = [@(cell.requestId) stringValue];
    payListViewController.homeViewController = self.homeViewController;
    //payListViewController.ratingViewDelegate = self;
    payListViewController.requestIdToBeDeleted = [@(cell.requestId) stringValue];
    [self.homeViewController.navigationController pushViewController:payListViewController animated:YES];
    //[self.homeViewController.view addSubview:self.ratingView];
}
-(void) getRequestDetails:(NSInteger ) requestId
{
    UserRequests *userRequest;
    
    for(int i=0;i<self.userRequests.count;i++)
    {
        if(!self.userData.isVendorViewShown)
        {
            userRequest = [self.userRequests objectAtIndex:i];
            if( userRequest.requestId == requestId)
            {
                self.usrRequest = userRequest;
                break;
            }
        }
    }
}

-(NSMutableDictionary *) prepareParmeters
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    return parameters;
    
}

#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if([status isEqualToString:@"success"])
    {
        NSDictionary *data = [response valueForKey:@"data"];
        NSMutableArray *openRequests = [data valueForKey:@"openRequests"];
        NSMutableArray *acceptedRequests = [data valueForKey:@"acceptedRequests"];
        if(acceptedRequests)
            [self.userData saveUserAcceptedRequestsData:acceptedRequests];
        if(openRequests)
            [self.userData saveUserOpenRequestsData:openRequests];
        [self.tableView reloadData];
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
