//
//  HomeViewController.m
//  Neighbour
//
//  Created by Bharath Kongara on 9/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "HomeViewController.h"

#import "CategoryCollectionView.h"
#import "CategoryCollectionViewDelgate.h"
#import "CategoryCollectionViewDatasource.h"
#import "CategoryCollectionViewFlowLayout.h"
#import "CommonHeaderFiles.h"
#import "SettingsTableViewController.h"
#import "ResultsSearchTableViewController.h"
#import "OpenRequestsTableViewController.h"
#import "AcceptedRequestsTableViewController.h"
#import "CompletedRequestsTableViewController.h"
#import "VendorViewController.h"
#import "VendorRegistrationViewController.h"


@interface HomeViewController ()<UINavigationControllerDelegate,ServiceProtocol,MBProgressHUDDelegate,UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIView *bottomControlsView;
@property (nonatomic, weak) IBOutlet UIButton *btnProfile;
@property (nonatomic, weak) IBOutlet UIButton *btnAddRequest;
@property (nonatomic, weak) IBOutlet CategoryCollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIView *categoryContainer;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenRequests;
@property (weak, nonatomic) IBOutlet UIButton *btnCompletedRequests;


@property (nonatomic, strong) UIView *maskOnTableView;
@property (nonatomic,strong) CategoryCollectionViewDatasource *categoryCollectionViewDataSource;
@property (nonatomic,strong) CategoryCollectionViewDelgate *categoryCollectionViewDelegate;
@property (nonatomic,strong) CategoryCollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) User *userData;
@property (nonatomic,assign) BOOL isVendorShown;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) SettingsTableViewController *settingsTableViewController;
@property (nonatomic,strong) MBProgressHUD *HUD;

// Search Related Properties
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) ResultsSearchTableViewController *resultsSearchTableViewController;
@property (nonatomic, strong) VendorViewController *vendorViewController;
@property (nonatomic,strong) OpenRequestsTableViewController *openRequestsTableViewController;
@property (nonatomic,strong) AcceptedRequestsTableViewController *acceptRequestsTableViewController;
@property (nonatomic,strong) CompletedRequestsTableViewController *completedRequestsTableViewController;
@property (nonatomic,strong) VendorRegistrationViewController *vendorRegistrationViewController;
@property (nonatomic,strong) UIStoryboard *vendorStoryBoard;
@property (nonatomic,strong) UIStoryboard *settingsStoryBoard;


@property NSInteger requestorIndex;
@property (nonatomic,strong) UIStoryboard *storyBoard;


@end

@implementation HomeViewController

BOOL isCategoryViewShown ;
UITapGestureRecognizer *tapGestureFordismissingCollectionView;


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


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userData = [User sharedData];
    [self profileControllerSetup];
     self.isVendorShown = self.userData.isVendorViewShown;
    [self initializeDelegatesAndDatasource];
    [self prepareNavBar];
    [self moveCategoryViewOutOfScreenWithAnimationDuration:0.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]}];
    [self createNavigationItems];
    self.definesPresentationContext = true;
    [self setUpSegmentedControls];
    self.resultsSearchTableViewController = [[ResultsSearchTableViewController alloc] init];
    [self initializeAllRequestControllers];
    [self initialTableViewLoad];
}
-(void) viewWillAppear:(BOOL)animated
{
    //[self initialTableViewLoad];
    if(self.userData.userRequestMode  == OpenMode &&  self.userData.reloadingAfterPost)
    {
        [self.openRequestsTableViewController.tableView reloadData];
        self.userData.reloadingAfterPost = NO;
    }
    else if(self.userData.userRequestMode  == ActiveMode &&  self.userData.reloadingAfterPayments)
    {
        [self.acceptRequestsTableViewController.tableView reloadData];
        self.userData.reloadingAfterPayments = NO;
    }
}
-(void) initializeAllRequestControllers
{
    self.storyBoard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    self.openRequestsTableViewController = (OpenRequestsTableViewController *) [self.storyBoard instantiateViewControllerWithIdentifier:@"OpenRequestsTableViewController"];
    self.openRequestsTableViewController.homeViewController = self;
    self.completedRequestsTableViewController = (CompletedRequestsTableViewController *) [self.storyBoard instantiateViewControllerWithIdentifier:@"CompletedRequestsTableViewController"];
    self.completedRequestsTableViewController.homeViewController = self;
}

-(void) setUpSegmentedControls
{
    [self.btnOpenRequests setTitleColor:[UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f] forState:UIControlStateSelected];
    [self.btnCompletedRequests setTitleColor:[UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f]forState:UIControlStateSelected];
    [self.btnOpenRequests setSelected:YES];
    [self.btnOpenRequests setBackgroundColor:[UIColor clearColor]];
    self.btnOpenRequests.adjustsImageWhenHighlighted = NO;
}

-(void) hideSearchBar
{
    CGFloat yOffset = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGPoint point = CGPointMake(0, self.searchController.searchBar.frame.size.height + yOffset);
    self.openRequestsTableViewController.tableView.contentOffset = point;
}

-(void) prepareSearchBarAndSetDelegate
{
   
    self.searchController =[[UISearchController alloc] initWithSearchResultsController:self.resultsSearchTableViewController];
    self.searchController.searchResultsUpdater = self.resultsSearchTableViewController;
    [self.searchController.searchBar sizeToFit];
    self.openRequestsTableViewController.tableView.tableHeaderView =self.searchController.searchBar;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //[self.searchController.searchBar becomeFirstResponder];
    
}

-(void) prepareLoadIndicator
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
}

- (void)initializeDelegatesAndDatasource
{

    [self intializeCategoryView];
    [self initializeAndSetLayout];
    [self setDelegateAndDataSource];
}
-(void) intializeCategoryView
{

    self.categoryCollectionViewDataSource = [[CategoryCollectionViewDatasource alloc] init];
    self.categoryCollectionViewDelegate = [[CategoryCollectionViewDelgate alloc] init];
    self.categoryCollectionViewDelegate.homeViewController =self;

}

- (void)setDelegateAndDataSource
{
    self.collectionView.delegate = self.categoryCollectionViewDelegate;
    self.collectionView.dataSource = self.categoryCollectionViewDataSource;
}

- (void)initializeAndSetLayout
{
    self.flowLayout = [[CategoryCollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = self.flowLayout;
}
-(void) profileControllerSetup
{
    
}
-(void) createNavigationItems
{
    
    UIImage *image = [UIImage imageNamed:@"user_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showVendorButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:236.0f/255.0f green:240.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    [self.navigationItem setRightBarButtonItem:barButtonItem];
    self.navigationController.delegate = self;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.definesPresentationContext = YES;
}

-(void)initialTableViewLoad
{
    
    [self.containerView addSubview:self.openRequestsTableViewController.tableView];
    [self.view bringSubviewToFront:self.openRequestsTableViewController.tableView];
    self.requestorIndex = 0;
}

-(void)loadAcceptedTableView
{
   
   [self.containerView addSubview:self.acceptRequestsTableViewController.tableView];
    
}
-(void)loadCompletedRequestsTableView
{
    
//    self.completedRequestsTableViewController = (CompletedRequestsTableViewController *) [self.storyBoard instantiateViewControllerWithIdentifier:@"CompletedRequestsTableViewController"];
//    self.completedRequestsTableViewController.homeViewController = self;
    [self.containerView addSubview:self.completedRequestsTableViewController.tableView];
}

- (void)prepareNavBar
{
    self.navigationController.navigationBarHidden = NO;
     self.navigationItem.title = @"User Requests";
    self.navigationItem.hidesBackButton = YES;
}

-(void) moveCategoryViewOutOfScreenWithAnimationDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        CGPoint origin = CGPointMake(self.categoryContainer.frame.origin.x, self.view.frame.size.height);
        CGSize size = self.categoryContainer.frame.size;
        CGRect frame = CGRectMake(origin.x, origin.y, size.width,size.height);
        self.categoryContainer.frame =frame;
    } completion:^(BOOL finished) {
        isCategoryViewShown = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)removeRequestSubviews
{
    if (self.requestorIndex == 0)
    {
        [self.acceptRequestsTableViewController.tableView removeFromSuperview];
        [self.completedRequestsTableViewController.tableView removeFromSuperview];
    }
    else if (self.requestorIndex == 1)
    {
        [self.openRequestsTableViewController.tableView removeFromSuperview];
        [self.completedRequestsTableViewController.tableView removeFromSuperview];
        
    }
    else if (self.requestorIndex == 2)
    {
        [self.openRequestsTableViewController.tableView removeFromSuperview];
         [self.acceptRequestsTableViewController.tableView removeFromSuperview];
        
    }
}

#pragma SegmentControlView Actions
- (IBAction)openRequestsTapped:(id)sender {
    
    UIButton *selectedButton = (UIButton *) sender;
    [selectedButton setSelected:YES];
    [selectedButton setBackgroundColor:[UIColor clearColor]];
    selectedButton.adjustsImageWhenHighlighted = NO;
    [self.btnCompletedRequests setSelected:NO];
    
    [self initialTableViewLoad];
    self.requestorIndex = 0;
    self.userData.userRequestMode = OpenMode;
    [self getUserRequests];
}


- (IBAction)completedRequestsTapped:(id)sender {
    
    UIButton *selectedButton = (UIButton *) sender;
    
    [selectedButton setSelected:YES];
    [selectedButton setBackgroundColor:[UIColor clearColor]];
    selectedButton.adjustsImageWhenHighlighted = NO;
    [self.btnOpenRequests setSelected:NO];
    self.requestorIndex = 2;
    self.userData.userRequestMode = CompletedMode;
    [self getUserRequests];
}

- (IBAction)btnProfileTapped:(id)sender
{
    [self moveCategoryViewOutOfScreenWithAnimationDuration:0.3f];
    self.settingsStoryBoard= [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
    self.settingsTableViewController = [self.settingsStoryBoard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
    [self.navigationController pushViewController:self.settingsTableViewController animated:YES];
}

- (IBAction)btnAddRequestTapped:(id)sender
{
    if(!isCategoryViewShown)
        [self displayCategoryView];
    else
    {
        [self moveCategoryViewOutOfScreenWithAnimationDuration:0.3f];
        [self.maskOnTableView removeGestureRecognizer:tapGestureFordismissingCollectionView];
        [self.maskOnTableView removeFromSuperview];
        self.maskOnTableView = nil;

    }
}

- (IBAction)searchClicked:(UIBarButtonItem *)sender {
   
    self.searchController =[[UISearchController alloc] initWithSearchResultsController:self.resultsSearchTableViewController];
    self.searchController.searchResultsUpdater = self.resultsSearchTableViewController;
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.resultsSearchTableViewController.homeController = self;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

-(void) showVendorButtonTapped
{
    
    if(self.userData.isVendor)
    {
        self.vendorStoryBoard = [UIStoryboard storyboardWithName:@"Vendor" bundle:[NSBundle mainBundle]];
        self.vendorViewController = [self.vendorStoryBoard instantiateViewControllerWithIdentifier:@"VendorViewController"];
        self.userData.isVendorViewShown = YES;
        [self.navigationController pushViewController:self.vendorViewController animated:YES];
    }
    else
    {
        self.vendorRegistrationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"VendorRegistrationViewController"];
        [self.navigationController pushViewController:self.vendorRegistrationViewController animated:YES];
    }
}

-(void) dismissCategoryCollectionView
{
    [self moveCategoryViewOutOfScreenWithAnimationDuration:0.3f];
    [self.maskOnTableView removeGestureRecognizer:tapGestureFordismissingCollectionView];
    [self.maskOnTableView removeFromSuperview];
    self.maskOnTableView = nil;
}

-(void) displayCategoryView
{
    [self createAndAddMaskOnTableView];
    [UIView animateWithDuration:0.3  delay:0.1 options:0 animations:^{
        CGSize size = self.categoryContainer.frame.size;
        CGPoint origin = CGPointMake(0, CGRectGetMaxY(self.view.frame)- self.categoryContainer.frame.size.height - self.bottomControlsView.frame.size.height);
        CGRect frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        self.categoryContainer.frame = frame;
    } completion:^(BOOL finished) {
        isCategoryViewShown = YES;
         UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissCategoryCollectionView)];
        gesture.direction = UISwipeGestureRecognizerDirectionDown;
        [self.categoryContainer addGestureRecognizer:gesture];
        [self.collectionView addGestureRecognizer:gesture];
    }];
}

- (void)createAndAddMaskOnTableView
{
    tapGestureFordismissingCollectionView = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(dismissCategoryCollectionView)];
    [self prepareMaskOnTableView];

}

- (void)prepareMaskOnTableView
{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(self.view.frame)- self.categoryContainer.frame.size.height - self.bottomControlsView.frame.size.height);
    self.maskOnTableView = [[UIView alloc] initWithFrame:frame];
    self.maskOnTableView.backgroundColor = [UIColor clearColor];
    [self.maskOnTableView addGestureRecognizer:tapGestureFordismissingCollectionView];
    [self.view addSubview:self.maskOnTableView];
}

#pragma mark - UINavigationControllerDelegate Method

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self dismissCategoryCollectionView];
}
#pragma mark - Service Calls

-(void)getUserRequests
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.HUD];
    self.HUD.delegate = self;
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParametersForUserRequests];
    url = [ServiceURLProvider getURLForServiceWithKey:kGetLatestRequestKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];
    [self.HUD show:YES];
}
-(void) makeServiceCall
{
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParametersForUserRequests];
    url = [ServiceURLProvider getURLForServiceWithKey:kGetLatestRequestKey];
    [self.manager serviceCallWithURL:url andParameters:parameters];

}

-(NSMutableDictionary *) prepareParametersForUserRequests
{
    
    NSMutableArray *requestStatus = [[NSMutableArray alloc] init];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    [parameters setValue:@"1"  forKey:@"roleId"];
    
    if(self.userData.userRequestMode == OpenMode)
        [requestStatus addObject:@"OPEN" ];
    else if(self.userData.userRequestMode == ActiveMode)
        [requestStatus addObject:@"BID_ACCEPT" ];
    else if(self.userData.userRequestMode == CompletedMode)
        [requestStatus addObject:@"SERVICED" ];
    
    [parameters setValue:requestStatus forKey:@"requestStatuses"];

    return parameters;
}

#pragma mark - ServiceProtocol Methods

- (void)serviceCallCompletedWithResponseObject:(id)response
{
    [self.HUD removeFromSuperview];
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSMutableDictionary *userUpdatedData = [response valueForKey:@"data"];
   
    if(self.isVendorShown)
    {
        NSMutableArray *placedRequestsArray = [userUpdatedData valueForKey:@"placedBids"];
        NSMutableArray *vendorRequestsArray = [userUpdatedData valueForKey:@"openBids"];
         NSMutableArray *vendorOwnArray = [userUpdatedData valueForKey:@"servicedRequests"];
        if(placedRequestsArray)
            [self.vendorData saveVendorData:placedRequestsArray];
        
        else if( vendorRequestsArray)
            [self.vendorData saveEachVendorOpenRequestData:vendorRequestsArray];
        if(vendorOwnArray)
            [self.vendorData saveVendorOwnBidsData:vendorOwnArray];
    }
    else
    {
        NSMutableArray *openRequests = [userUpdatedData valueForKey:@"openRequests"];
        NSMutableArray *acceptedRequests = [userUpdatedData valueForKey:@"acceptedRequests"];
        NSMutableArray *completedRequests = [userUpdatedData valueForKey:@"servicedRequests"];
        if(openRequests)
            [self.userData saveUserOpenRequestsData:openRequests];
        if(acceptedRequests)
        {
             [self.userData saveUserAcceptedRequestsData:acceptedRequests];
        }
        
        if(completedRequests)
            [self.userData saveUserCompletedRequestsData:completedRequests];
    }
    [self reloadAppropriateView];
}
- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error!"
                                                        message:@"Could not connect to the server.Please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

-(void) reloadAppropriateView
{
    [self removeRequestSubviews];
    if(self.userData.userRequestMode == OpenMode)
        [self.openRequestsTableViewController.tableView reloadData];
    else if(self.userData.userRequestMode == ActiveMode)
    {
        [self loadAcceptedTableView];
    }
    
    else if(self.userData.userRequestMode == CompletedMode)
    {
        [self loadCompletedRequestsTableView];
    }
    
    
}
@end
