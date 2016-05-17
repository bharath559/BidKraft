//
//  CompletedRequestsTableView.m
//  Neighbour
//
//  Created by Bharath Kongara on 12/2/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "CompletedRequestsTableViewController.h"
#import "RequestDetailViewController.h"
#import "ResultsSearchTableViewController.h"



@interface CompletedRequestsTableViewController () <ServiceProtocol>

@property (nonatomic,strong) NSMutableArray *userRequests;
@property (nonatomic,strong) User *userData;
@property (nonatomic,strong) ServiceManager *manager;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger requestIdToBeDeleted;
@property (nonatomic,strong) RequestDetailViewController *requestDetailController;
@property (nonatomic, strong) ResultsSearchTableViewController *resultsSearchTableViewController;

@end

@implementation CompletedRequestsTableViewController

- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setDelagatesAndDataSources];
    [self setDelagatesAndDataSources];
}
-(void)setDelagatesAndDataSources
{
    self.userRequests = self.userData.userCompletedRequests;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL)animated
{
    self.userData.userRequestMode = CompletedMode;
    self.userRequests = self.userData.userCompletedRequests;
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
    return self.userRequests.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self regitsterForTableCell];
    static NSString* cellIdentifier;
    
    cellIdentifier = @"RequestCell";
    //RequestTableViewCell *cell =(RequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    return [self prepareUserRequestsCell:self.tableView WithIdentifier:cellIdentifier atIndexPath:indexPath];
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
    cell.backgroundColor = [UIColor colorWithRed:243.0f/255.0f green:156.0f/255.0f blue:18.0f/255.0f alpha:1.0f];

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
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    self.requestDetailController = (RequestDetailViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
    self.requestDetailController.requestId =  tableCell.requestId;
    [self.homeViewController.navigationController pushViewController:self.requestDetailController animated:YES];
}

@end
