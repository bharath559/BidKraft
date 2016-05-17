
#import "VendorOpenRequestsTableViewController.h"
#import "VendorData.h"
#import "VendorTableViewCell.h"
#import "User.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "MBProgressHUD.h"



@interface VendorOpenRequestsTableViewController () <ServiceProtocol>

@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *vendorRequests;
@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) ServiceManager *manager;


@end

@implementation VendorOpenRequestsTableViewController

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
    self.vendorData.vendorRequestMode = VendorOpenMode;
  
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

-(void) getVendorData
{
    self.vendorRequests = [[ NSMutableArray alloc] init];
    self.vendorRequests = self.vendorData.vendorOpenRequests;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self getVendorData];
    
    if(self.vendorRequests.count == 0)
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
    return self.vendorRequests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.backgroundView = nil;
    static NSString* cellIdentifier;
    cellIdentifier = @"VendorTableViewCell";
    return [self prepareVendorTableForOpenRequests:tableView withIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(VendorTableViewCell *) prepareVendorTableForOpenRequests:(UITableView *) tableView withIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    VendorTableViewCell *vendorCell =(VendorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(self.vendorRequests.count>0)
    {
        [vendorCell prepareCellForTabelView:tableView atIndex:indexPath];
        [vendorCell prepareTableCellData:vendorCell withIndexPath:indexPath];
    }
    else
    {
        vendorCell.textLabel.text = @"No Sources available.";
        vendorCell.detailTextLabel.text = @"Please add sources and fund account.";
    }
    vendorCell.layer.masksToBounds = YES;
    vendorCell.layer.cornerRadius = 25.0f;
    if(indexPath.section <2)
    {
        vendorCell.backgroundColor = [UIColor colorWithRed:211.0f/255.0f green:84.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }
    else
    {
        vendorCell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
    }
    return vendorCell;
    return vendorCell;
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VendorTableViewCell *tableCell = (VendorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.vendorOpenRequestsNavControlDelegate getCellData:[tableCell getRequestDate] withRequestDesc:[tableCell getRequestDescription] withRequestID:tableCell.requestId onCellData:tableCell];
    
}

//
//- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
// forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSArray *returnValue;
//    [self prepareDataObjects];
//    
//    UITableViewRowAction *cancelAction;
//    
//    cancelAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                      title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//                                                          [self performDelete:indexPath onTableView:tableView];
//                                                      }];
//    cancelAction.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:2.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
//    
//    //returnValue = @[cancelAction];
//    
//    return returnValue;
//}

-(void)prepareDataObjects
{
    self.userRequests = [[ NSMutableArray alloc] init];
    self.userRequests = self.vendorData.vendorOpenRequests;
}

-(NSMutableDictionary *) prepareParmeters
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[NSNumber numberWithInteger:self.requestIdToBeDeleted] forKey:@"requestId"];
    [parameters setValue:[self.userData userId] forKey:@"userId"];
    return parameters;
    
}

-(void) performDelete:(NSIndexPath *) indexPath onTableView:(UITableView *) tableView
{
    [self.userRequests removeObjectAtIndex:indexPath.row];
    VendorTableViewCell *tableCell = (VendorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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

#pragma mark - ServiceProtocol Methods


- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if([status isEqualToString:@"success"])
    {
        
        NSDictionary *data = [response valueForKey:@"data"];
        NSMutableArray *vendorOpenRequests = [data valueForKey:@"openBids"];
        [self.vendorData saveEachVendorOpenRequestData:vendorOpenRequests];
        [self.tableView deleteRowsAtIndexPaths:@[self.indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];

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
