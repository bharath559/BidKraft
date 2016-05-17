//
//  VendorSearchTableViewController.m
//  Neighbour
//
//  Created by ravi pitapurapu on 12/2/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "VendorSearchTableViewController.h"
#import "User.h"
#import "VendorTableViewCell.h"
#import "VendorData.h"
#import "VendorBidRequest.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "PaymentTableViewCell.h"
#import "VendorSearchTableViewCell.h"
#import "JobDetailViewController.h"


@interface VendorSearchTableViewController ()

@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *vendorRequests;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) NSArray *searchResults;
@property (nonatomic,strong) JobDetailViewController *jobDetailViewController;



@end

@implementation VendorSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:1.0];

    [self.tableView registerNib:[UINib nibWithNibName:@"VendorTableCell" bundle:nil] forCellReuseIdentifier:@"VendorSearchTableViewCell"];
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
        [self prepareDataObjects];
    }
    
    return self;
}

-(void) prepareDataObjects
{
    
    self.vendorRequests = [[ NSMutableArray alloc] init];
    if(self.vendorData.vendorRequestMode == VendorOpenMode)
        self.vendorRequests = self.vendorData.vendorOpenRequests;
    else if(self.vendorData.vendorRequestMode == VendorPlacedBidsMode)
        self.vendorRequests = self.vendorData.vendorBids;
    else if(self.vendorData.vendorRequestMode == VendorBidsOwnMode)
        self.vendorRequests = self.vendorData.vendorOwnBids;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return  self.userData.searchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (VendorSearchTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier;
    cellIdentifier = @"VendorSearchTableViewCell";
    VendorSearchTableViewCell *vendorCell =(VendorSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [vendorCell prepareCellForTabelView:tableView atIndex:indexPath];
    [vendorCell prepareTableCellData:vendorCell withIndexPath : indexPath];
    vendorCell.layer.masksToBounds = YES;
    vendorCell.layer.cornerRadius = 25.0f;
    vendorCell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    vendorCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return vendorCell;
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
    
    VendorSearchTableViewCell *tableCell = (VendorSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.jobDetailViewController = (JobDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    self.jobDetailViewController.requestId =  tableCell.requestId;
    self.jobDetailViewController.vendorSearchViewController = self;
    [self.homeController.navigationController pushViewController:self.jobDetailViewController animated:YES];
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
        self.searchResults = [[self.vendorRequests  filteredArrayUsingPredicate:testPredicate] mutableCopy];
        self.vendorRequests= [self.searchResults mutableCopy];
        self.userData.searchResults = [self.searchResults mutableCopy];
        [self.tableView reloadData];
    }
}

@end
