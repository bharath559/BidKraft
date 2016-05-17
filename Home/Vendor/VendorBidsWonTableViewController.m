
#import "VendorBidsWonTableViewController.h"
#import "User.h"
#import "VendorData.h"



@interface VendorBidsWonTableViewController ()

@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) VendorData *vendorData;
@property (nonatomic,strong) NSMutableArray *vendorRequests;

@end

@implementation VendorBidsWonTableViewController


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

-(void) getVendorData
{
    self.vendorRequests = [[ NSMutableArray alloc] init];
    self.vendorRequests = self.vendorData.vendorOwnBids;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.vendorData.vendorRequestMode = VendorBidsOwnMode;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return [self prepareVendorTableForOpenRequests:tableView withIdentifier:cellIdentifier atIndexPath:indexPath];
}

-(VendorTableViewCell *) prepareVendorTableForOpenRequests:(UITableView *) tableView withIdentifier:(NSString *) cellIdentifier atIndexPath:(NSIndexPath *)indexPath
{
    VendorTableViewCell *vendorCell =(VendorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(self.vendorRequests.count>0)
    {
        [vendorCell prepareCellForTabelView:tableView atIndex:indexPath];
        [vendorCell prepareTableCellData:vendorCell withIndexPath : indexPath];
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

//- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
// forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//}


#pragma TableView Delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VendorTableViewCell *tableCell = (VendorTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.vendorBidsOwnedNavControlDelegate getCellBidsOwnedData:[tableCell getRequestDate] withRequestDesc:tableCell.requestDescription onCellData:tableCell];
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
