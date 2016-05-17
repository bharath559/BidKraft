//
//  AcceptedRequestsTableView.m
//  Neighbour
//
//  Created by Raghav Sai on 11/29/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "AcceptedRequestsTableViewController.h"
#import "User.h"
#import "RequestTableViewCell.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "RequestDetailViewController.h"
#import "PayListViewController.h"
#import "ResultsSearchTableViewController.h"

@interface AcceptedRequestsTableViewController () <ServiceProtocol,RatingViewProtocal>

@property (strong, nonatomic) IBOutlet UIView *ratingView;
@property (weak, nonatomic) IBOutlet UITextView *commentsForVendor;

@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;
@property (nonatomic,strong) UserRequests *usrRequest;
@property (nonatomic,strong) NSString *bidId;
@property (nonatomic, strong) ResultsSearchTableViewController *resultsSearchTableViewController;


@end

@implementation AcceptedRequestsTableViewController

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
     self.manager = [ServiceManager defaultManager];
    self.userData.userRequestMode = OpenMode;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.userRequests = self.userData.userAcceptedRequests;
    self.userData.userRequestMode = ActiveMode;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    else
    {
        self.tableView.backgroundView = nil;
    }
    return self.userRequests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if(self.userRequests.count > 0)
        return 1;
//    else
//    {
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"No data is currently available";
//        messageLabel.textColor = [UIColor whiteColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        self.tableView.backgroundView = messageLabel;
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        return 0;
//    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self regitsterForTableCell];
    static NSString* cellIdentifier;
    self.tableView.backgroundView = nil;
    
    cellIdentifier = @"RequestCell";
    //RequestTableViewCell *cell =(RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return [self prepareUserRequestsCell:self.tableView WithIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(RequestTableViewCell *) prepareUserRequestsCell:(UITableView *) tableView WithIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    RequestTableViewCell *cell =(RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if(self.userRequests.count>0)
    {
        // cell.isTableReload = self.isTableReload;
        
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
//    if(indexPath.section <2)
//    {
//        cell.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:84.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
//    }
    //else
    //{
        cell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    //}

    
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self prepareDataObjects];
    UITableViewRowAction *completeAction;
    completeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                      title:@"Complete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                          [self performComplete:indexPath onTableView:tableView];
                                                      }];
    completeAction.backgroundColor =[UIColor colorWithRed:25.0f/255.0f green:123.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
  
    return @[completeAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.requestDetailController = (RequestDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
    self.requestDetailController.requestId =  tableCell.requestId;
    [self.homeViewController.navigationController pushViewController:self.requestDetailController animated:YES];
    
}

-(void) performComplete:(NSIndexPath *) indexPath onTableView:(UITableView *) tableView
{
    self.indexPath = indexPath;
    self.tableView = tableView;
    self.commentsForVendor.layer.borderWidth = 0.7;
    self.commentsForVendor.layer.borderColor = [UIColor grayColor].CGColor;
    self.commentsForVendor.layer.cornerRadius = 6.5;
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
//    for(int i=0;i<self.usrRequest.bidsArray.count;i++)
//    {
//        bidDetail = [self.usrRequest.bidsArray objectAtIndex:i];
//        if( [bidDetail.bidAmount integerValue] == self.usrRequest.lowestBid)
//            self.bidId = [@(bidDetail.bidId) stringValue];
//    }
    
}
-(void)removeRatingViewFromSuperView
{
    [self.ratingView removeFromSuperview];
    [self.userRequests removeObjectAtIndex:self.indexPath.row];
}

- (IBAction)rateVendorAction:(id)sender
{
    [self removeRatingViewFromSuperView];
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    self.requestIdToBeDeleted = tableCell.requestId ;
    NSString *url;
    NSMutableDictionary *parameters = [self prepareParmetersForCompletionRequest];
    self.manager.serviceDelegate = self;
    url = [ServiceURLProvider getURLForServiceWithKey:kCompletedServiceKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}
- (IBAction)skipVendorAction:(id)sender
{
    [self removeRatingViewFromSuperView];
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[self.tableView cellForRowAtIndexPath:self.indexPath];
    self.requestIdToBeDeleted = tableCell.requestId ;
    NSString *url;
    NSMutableDictionary *parameters = [self prepareParmetersForCompletionSkipRequest];
    url = [ServiceURLProvider getURLForServiceWithKey:kCompletedServiceKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}

-(NSMutableDictionary *) prepareParmetersForCompletionRequest
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *userReview = [[NSMutableDictionary alloc]init];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:@"1" forKey:@"roleId"];
    [userReview setValue:[self.userData userId] forKey:@"reviewerUserId"];
    [userReview setValue:[self.userData userId] forKey:@"revieweeUserId"];
    [userReview setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [userReview setValue:[NSNumber numberWithFloat:self.userData.ratingCount] forKey:@"rating"];
    [userReview setValue:self.commentsForVendor.text forKey:@"comment"];
    [parameters setValue:userReview forKey:@"userReview"];
    
    return parameters;
}

-(NSMutableDictionary *) prepareParmetersForCompletionSkipRequest
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *userReview = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:@"1" forKey:@"roleId"];
    [userReview setValue:[self.userData userId] forKey:@"reviewerUserId"];
    [userReview setValue:@"38" forKey:@"revieweeUserId"];
    [userReview setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [userReview setValue:@"0" forKey:@"rating"];
    [userReview setValue:@"" forKey:@"comment"];
    [parameters setValue:userReview forKey:@"userReview"];
    
    return parameters;
}

-(void) performDelete:(NSIndexPath *) indexPath onTableView:(UITableView *) tableView
{
    [self.userRequests removeObjectAtIndex:indexPath.row];
    RequestTableViewCell *tableCell = (RequestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.requestIdToBeDeleted = tableCell.requestId ;
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParmeters];
    self.indexPath = indexPath;
    self.tableView = tableView;
    url = [ServiceURLProvider getURLForServiceWithKey:kDeleteRequest];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}

-(void) prepareDataObjects
{
    self.userRequests = [[ NSMutableArray alloc] init];
    self.userRequests = self.userData.userAcceptedRequests;
}

#pragma mark - RatingViewProtocol Methods
-(void) showRatingView
{
    [self.view addSubview:self.ratingView];
}


-(NSMutableDictionary *) prepareParmeters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    return parameters;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
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
//        NSMutableArray *vendorOpenRequests = [data valueForKey:@"openBids"];
        if(acceptedRequests)
            [self.userData saveUserAcceptedRequestsData:acceptedRequests];
        if(openRequests)
            [self.userData saveUserOpenRequestsData:openRequests];
        
        [self.tableView reloadData];
       //[self.tableView deleteRowsAtIndexPaths:@[self.indexPath]
                              //withRowAnimation:UITableViewRowAnimationLeft];
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
