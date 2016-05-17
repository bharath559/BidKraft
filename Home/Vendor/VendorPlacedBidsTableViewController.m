
#import "VendorPlacedBidsTableViewController.h"
#import "VendorData.h"
#import "VendorTableViewCell.h"
#import "ServiceManager.h"
#import "ServiceURLProvider.h"
#import "User.h"


@interface VendorPlacedBidsTableViewController ()<ServiceProtocol>

@property (nonatomic,strong) NSMutableArray *vendorRequests;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) NSString *bidToBeDeleted;



@end

@implementation VendorPlacedBidsTableViewController

- (VendorData *)vendorData
{
    if(!_vendorData)
        _vendorData = [VendorData sharedData];
    
    return _vendorData;
}

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vendorData.vendorRequestMode = VendorPlacedBidsMode;

}
-(void) getVendorData
{
    self.vendorRequests = [[ NSMutableArray alloc] init];
    self.vendorRequests = self.vendorData.vendorBids;
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
    static NSString* cellIdentifier;
    cellIdentifier = @"VendorTableViewCell";
    return [self prepareVendorTableForPlacedOwn:tableView withIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(VendorTableViewCell *) prepareVendorTableForPlacedOwn:(UITableView *) tableView withIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    
    self.tableView.backgroundView = nil;

    VendorTableViewCell *vendorCell =(VendorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    vendorCell.vendorRequestedMode = VendorRequestedOwn;
    if(self.vendorData.vendorBids.count>0)
    {
        [vendorCell prepareCellForTabelView:tableView atIndex:indexPath withData:self.vendorData.vendorBids];
        [vendorCell prepareTableCellData:vendorCell withIndexPath : indexPath withData:self.vendorData.vendorBids];
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
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *returnValue;
    
    UITableViewRowAction *deleteAction;
    deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                      title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                          [self performDelete:indexPath onTableView:tableView];
                                                      }];
    deleteAction.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:2.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
    returnValue = @[deleteAction];
    
    return returnValue;
}

-(void) performDelete:(NSIndexPath *)indexPath onTableView:(UITableView *)tableView
{
    [self.vendorRequests removeObjectAtIndex:indexPath.section];
    VendorTableViewCell *tableCell = (VendorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    self.bidToBeDeleted = [@(tableCell.requestId) stringValue];
    NSString *url;
    self.manager = [ServiceManager defaultManager];
    self.manager.serviceDelegate = self;
    NSMutableDictionary *parameters = [self prepareParmeters];
    url = [ServiceURLProvider getURLForServiceWithKey:kDeleteBid];
    [self.manager serviceCallWithURL:url andParameters:parameters];
}
-(NSMutableDictionary *) prepareParmeters
{
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:self.bidToBeDeleted forKey:@"requestId"];
    [parameters setValue:[self.userData userId] forKey:@"offererUserId"];
    return parameters;
    
}

#pragma mark - ServiceProtocol Methods


- (void)serviceCallCompletedWithResponseObject:(id)response
{
    NSDictionary *responsedata = (NSDictionary *)response;
    NSLog(@"data%@",responsedata);
    NSString *status = [response valueForKey:@"status"];
    if( [status isEqualToString:@"success"])
    {
        
        NSDictionary *responsedata = [response objectForKey:@"data"];
        NSMutableArray *placedBids=  [responsedata objectForKey:@"placedBids"];
        NSMutableArray *openRequests =  [responsedata objectForKey:@"openBids"];
        
        if(openRequests)
            [self.vendorData saveEachVendorOpenRequestData:openRequests];
        if(placedBids)
            [self.vendorData saveVendorData:placedBids];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation!"
                                                            message:@"Bid Deleted"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 2;
        alertView.delegate = self;
        [alertView show];
    }
    else if([status isEqualToString:@"error"])
    {
        
        NSString *status = [[NSString alloc] initWithString:[responsedata valueForKey:@"message"]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:status
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 2;
        alertView.delegate = self;
        [alertView show];
    }
    
}

- (void)serviceCallCompletedWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag ==2)
    {
        [self.tableView reloadData];
    }
}

#pragma TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    VendorTableViewCell *tableCell = (VendorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.vendorPlacedBidsNavControlDelegate getCellDataPlacedBids:[tableCell getRequestDate] withRequestDesc:tableCell.requestDescription onCellData:tableCell];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

@end
