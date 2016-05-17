//
//  ResultsSearchTableViewController.m
//  Neighbour
//
//  Created by ravi pitapurapu on 11/24/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "ResultsSearchTableViewController.h"
#import "RequestTableViewCell.h"
#import "User.h"
#import "VendorTableViewCell.h"
#import "VendorData.h"
#import "VendorBidRequest.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "PaymentTableViewCell.h"
#import "UserSearchTableViewCell.h"
#import "RequestDetailViewController.h"



@interface ResultsSearchTableViewController () <ServiceProtocol>


@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *vendorRequests;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSArray *searchResults;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;



@end

@implementation ResultsSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataObjects];
    self.tableView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableCell" bundle:nil] forCellReuseIdentifier:@"UserSearchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (id)init
{
    self = [super init];
    if(self)
    {
        //Custom actions here
        [self prepareDataObjects];
    }
    
    return self;
}

-(void) prepareDataObjects
{
    
    self.userRequests = [[ NSMutableArray alloc] init];
    if(self.userData.userRequestMode == OpenMode)
        self.userRequests = self.userData.userOpenRequests;
    else if(self.userData.userRequestMode == ActiveMode)
        self.userRequests = self.userData.userAcceptedRequests;
    else if(self.userData.userRequestMode == CompletedMode)
        self.userRequests = self.userData.userCompletedRequests;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.userData.searchResults.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier;
        cellIdentifier = @"UserSearchCell";
        return [self prepareUserRequestsCell:tableView WithIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(UserSearchTableViewCell *) prepareUserRequestsCell:(UITableView *) tableView WithIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    UserSearchTableViewCell *cell =(UserSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.isTableReload = self.isTableReload;
    [cell prepareCellForTabelView:tableView atIndex:indexPath];
    [cell prepareTableCellData:cell withIndexPath :indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25.0f;
    cell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserSearchTableViewCell *tableCell = (UserSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.requestDetailController = (RequestDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
    self.requestDetailController.requestId =  tableCell.requestId;
    self.requestDetailController.resultsSearchController = self;
    [self.homeController.navigationController pushViewController:self.requestDetailController animated:YES];
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(NSMutableDictionary *) prepareParmeters
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if(self.self.vendorData.vendorRequestMode == VendorPlacedBidsMode)
        [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    else
        [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    
    return parameters;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchText = searchController.searchBar.text;
    [self prepareDataObjects];
    NSPredicate *testPredicate = [NSPredicate predicateWithFormat:@"categoryName contains[cd] %@ OR tags contains[cd] %@ OR jobTitle contains [cd] %@", searchText, searchText,searchText];
    if([searchText isEqualToString:@""])
    {
        
    }
    else
    {
        self.searchResults = [[self.userRequests  filteredArrayUsingPredicate:testPredicate] mutableCopy];
        self.userRequests= [self.searchResults mutableCopy];
        self.userData.searchResults = [self.searchResults mutableCopy];
        [self.tableView reloadData];
    }
}
#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if(status)
    {
        [self.tableView deleteRowsAtIndexPaths:@[self.indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
    }
    
}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}

@end
