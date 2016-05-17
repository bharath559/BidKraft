//
//  VendorViewController.m
//  Neighbour
//
//  Created by Raghav Sai on 12/2/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "VendorViewController.h"
#import "VendorOpenRequestsTableViewController.h"
#import "VendorPlacedBidsTableViewController.h"
#import "VendorBidsWonTableViewController.h"
#import "MBProgressHUD.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"
#import "VendorData.h"
#import "VendorSearchTableViewController.h"
#import "ResultsSearchTableViewController.h"
#import "RequestTableViewCell.h"
#import "RequestDetailViewController.h"
#import "VendorTableViewCell.h"
#import "JobDetailViewController.h"

@interface VendorViewController () <ServiceProtocol,MBProgressHUDDelegate,VendorOpenRequestsProtocol,VendorPlacedBidsProtocol,VendorBidsOwnedProtocol>


@property (nonatomic,strong) VendorOpenRequestsTableViewController *vendorOpenRequestsTableViewController;
@property (nonatomic,strong) VendorPlacedBidsTableViewController *vendorPlacedBidsTableViewController;
@property (nonatomic,strong) VendorBidsWonTableViewController *vendorBidsOwnedTableViewController;
@property (nonatomic,strong) VendorPlacedBidsTableViewController *vendorPlacedBidViewController;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) UIStoryboard *storyBoard;
@property (nonatomic,strong) VendorSearchTableViewController *searchTableViewController;
@property (nonatomic,strong) ResultsSearchTableViewController *resultsTableViewController;
@property (nonatomic,strong) UISearchController *searchController;
@property int vendorRequestorIndex;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;
@property (nonatomic,strong) JobDetailViewController *jobDetailViewController;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenRequests;
@property (weak, nonatomic) IBOutlet UIButton *btnPlacedBids;
@property (weak, nonatomic) IBOutlet UIButton *btnBidsOwn;

@end

@implementation VendorViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getVendorPlacedBids];
    [self setUpSegmentedControls];
    [self instantiateAllTableViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.vendorData.vendorRequestMode == VendorOpenMode && self.vendorData.reloadingAfterBidPlaced)
    {
        [self.vendorOpenRequestsTableViewController.tableView reloadData];
    }
    [self prepareNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setUpSegmentedControls
{
    [self.btnPlacedBids setTitleColor:[UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [self.btnOpenRequests setTitleColor:[UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [self.btnBidsOwn setTitleColor:[UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]forState:UIControlStateSelected];
    self.vendorRequestorIndex = 0;
    [self.btnOpenRequests setSelected:YES];
    [self.btnOpenRequests setBackgroundColor:[UIColor clearColor]];
    self.btnOpenRequests.adjustsImageWhenHighlighted = NO;
    
}

- (void)prepareNavBar
{
    
    self.navigationItem.hidesBackButton = YES;
    [self createNavigationItems];
    self.navigationItem.title = @"Vendor Jobs";
    [self prepareSearchBarAndSetDelegate];
}

-(void) prepareSearchBarAndSetDelegate
{
    self.searchTableViewController = [[VendorSearchTableViewController alloc] init];
  
}


-(void) createNavigationItems
{

    UIImage *image = [UIImage imageNamed:@"vendor_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
   
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.definesPresentationContext = YES;

  
}


-(void) buttonTapped
{
    self.userData.isVendorViewShown = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)instantiateAllTableViewControllers
{
    self.storyBoard = [UIStoryboard storyboardWithName:@"Vendor" bundle:[NSBundle mainBundle]];
}
#pragma subview removal method

-(void)removeSubviews
{
    if(self.vendorRequestorIndex == 0)
    {
        [self.vendorPlacedBidsTableViewController.tableView removeFromSuperview];
        [self.vendorBidsOwnedTableViewController.tableView removeFromSuperview];
    }
    else if (self.vendorRequestorIndex == 1)
    {
        [self.vendorOpenRequestsTableViewController.tableView removeFromSuperview];
        [self.vendorBidsOwnedTableViewController.tableView removeFromSuperview];
    }
    else if (self.vendorRequestorIndex == 2)
    {
        [self.vendorOpenRequestsTableViewController.tableView removeFromSuperview];
        [self.vendorPlacedBidsTableViewController.tableView removeFromSuperview];
    }
}

#pragma loading vendor table methods

-(void)loadVendorOpenRequestsTable
{
    self.vendorData.vendorRequestMode = VendorOpenMode;
    self.vendorOpenRequestsTableViewController.vendorOpenRequestsNavControlDelegate = self;
    self.vendorOpenRequestsTableViewController = (VendorOpenRequestsTableViewController *)[self.storyBoard instantiateViewControllerWithIdentifier:@"VendorOpenRequestsTableViewController"];
    [self.containerView addSubview:self.vendorOpenRequestsTableViewController.tableView];
}

-(void)loadVendorPlacedBidsTable
{
    self.vendorData.vendorRequestMode = VendorPlacedBidsMode;
    self.vendorPlacedBidsTableViewController.vendorPlacedBidsNavControlDelegate = self;
    self.vendorPlacedBidsTableViewController = (VendorPlacedBidsTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VendorPlacedBidsTableViewController"];
    [self.containerView addSubview:self.vendorPlacedBidsTableViewController.tableView];
}

-(void)loadVendorOwnedBidsTable
{
    self.vendorData.vendorRequestMode = VendorBidsOwnMode;
    self.vendorBidsOwnedTableViewController.vendorBidsOwnedNavControlDelegate = self;
    self.vendorBidsOwnedTableViewController = (VendorBidsWonTableViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"VendorBidsOwnedTableViewController"];
    [self.containerView addSubview:self.vendorBidsOwnedTableViewController.tableView];
}

#pragma vendor segment action methods

- (IBAction)vendorOpenRequestsTapped:(id)sender
{
    self.vendorRequestorIndex = 0;
    UIButton *selectedButton = (UIButton *) sender;
    [selectedButton setSelected:YES];
    [selectedButton setBackgroundColor:[UIColor clearColor]];
    selectedButton.adjustsImageWhenHighlighted = NO;
    [self.btnBidsOwn setSelected:NO];
    [self.btnPlacedBids setSelected:NO];
    [self removeSubviews];
    [self getVendorPlacedBids];
}

- (IBAction)vendorPlacedBidsTapped:(id)sender
{
    self.vendorRequestorIndex = 1;
    UIButton *selectedButton = (UIButton *) sender;
    [selectedButton setSelected:YES];
    [selectedButton setBackgroundColor:[UIColor clearColor]];
    selectedButton.adjustsImageWhenHighlighted = NO;
    [self.btnBidsOwn setSelected:NO];
    [self.btnOpenRequests setSelected:NO];
    [self removeSubviews];
    [self getVendorPlacedBids];
}

- (IBAction)vendorBidsOwnedTapped:(id)sender
{
    self.vendorRequestorIndex = 2;
    UIButton *selectedButton = (UIButton *) sender;
    [selectedButton setSelected:YES];
    [selectedButton setBackgroundColor:[UIColor clearColor]];
    selectedButton.adjustsImageWhenHighlighted = NO;
    [self.btnPlacedBids setSelected:NO];
    [self.btnOpenRequests setSelected:NO];
    [self removeSubviews];
    [self getVendorPlacedBids];
}

- (IBAction)serachTapped:(UIBarButtonItem *)sender
{
    self.searchController =[[UISearchController alloc] initWithSearchResultsController:self.searchTableViewController];
    self.searchController.searchResultsUpdater = self.searchTableViewController;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchTableViewController.homeController = self;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

-(void) getVendorPlacedBids
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
    
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParmeters];
    if(self.vendorRequestorIndex == 0 || self.vendorRequestorIndex == 2)
        url = [ServiceURLProvider getURLForServiceWithKey:kGetLatestRequestKey];
    else
        url = [ServiceURLProvider getURLForServiceWithKey:kVendorBidsKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    [self.HUD show:YES];
    
}

-(NSMutableDictionary *) prepareParmeters
{
    
    NSMutableArray *requestStatus = [[NSMutableArray alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:@"2" forKey:@"roleId"];
    
    if(self.vendorRequestorIndex == 0)
    {
        [requestStatus addObject:@"OPEN" ];
        [parameters setValue:requestStatus forKey:@"requestStatuses"];
    }
    else if (self.vendorRequestorIndex == 2)
    {
        [requestStatus addObject:@"SERVICED" ];
        [requestStatus addObject:@"BID_ACCEPT" ];
        [parameters setValue:requestStatus forKey:@"requestStatuses"];
    }
    
    
    return parameters;
}


#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    [self.HUD removeFromSuperview];
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSMutableDictionary *userUpdatedData = [response valueForKey:@"data"];
    
        NSMutableArray *placedRequestsArray = [userUpdatedData valueForKey:@"placedBids"];
        NSMutableArray *vendorRequestsArray = [userUpdatedData valueForKey:@"openBids"];
        NSMutableArray *vendorOwnArray = [userUpdatedData valueForKey:@"servicedRequests"];
    

    if(self.vendorRequestorIndex == 0)
    {
        [self.vendorData saveEachVendorOpenRequestData:vendorRequestsArray];
        [self loadVendorOpenRequestsTable];
    }
    else if (self.vendorRequestorIndex == 1)
    {
        [self.vendorData saveVendorData:placedRequestsArray];
        [self loadVendorPlacedBidsTable];
    }
    else if (self.vendorRequestorIndex == 2)
    {
        [self.vendorData saveVendorOwnBidsData:vendorOwnArray];
        [self loadVendorOwnedBidsTable];
        
    }

}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    [self.HUD removeFromSuperview];
    NSLog(@"%@",error.description);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!"
                                                        message:@"Could not connect to the server.Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];

}
#pragma VendorOpenRequestsProtocol Methods

-(void)getCellData:(NSString *)requestDate withRequestDesc:(NSString *)requestDescription withRequestID:(NSInteger)requestID onCellData:(VendorTableViewCell *) cell
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.jobDetailViewController = (JobDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    self.jobDetailViewController.requestId =  cell.requestId;
    [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
}


#pragma VendorPlacedBidsProtocol Methods

-(void)getCellDataPlacedBids:(NSString *)requestDate withRequestDesc:(NSString *)requestDescription onCellData:(VendorTableViewCell *) cell
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.jobDetailViewController = (JobDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    self.jobDetailViewController.requestId =  cell.requestId;
    [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
}

#pragma VendorBidsOwnedProtocol Methods

-(void)getCellBidsOwnedData:(NSString *)requestDate withRequestDesc:(NSString *)requestDescription onCellData:(VendorTableViewCell *) cell
{ UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    self.jobDetailViewController = (JobDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"JobDetailViewController"];
    self.jobDetailViewController.requestId =  cell.requestId;
    [self.navigationController pushViewController:self.jobDetailViewController animated:YES];
   
}
@end
