//
//  VendorTableViewCell.h
//  Neighbour
//
//  Created by Bharath kongara on 10/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VendorRequestMode) {
    VendorRequestedOpen,
    VendorRequestedOwn,
    VendorRequestedCompleted
};

@interface VendorTableViewCell : UITableViewCell

@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,assign) BOOL isTableReload;
@property (nonatomic,strong) NSString *requestDescription;
@property (nonatomic,assign) VendorRequestMode vendorRequestedMode;

-(NSString *) getRequestDate;
-(NSString *) getRequestDescription;
-(void) prepareTableCellData:(VendorTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath;
- (void)prepareCellForTabelView:(UITableView *)collectionView atIndex:(NSIndexPath *)indexPath;
-(void)prepareTableCellData:(VendorTableViewCell *) vendorCell withIndexPath :(NSIndexPath *)indexPath withData:(NSMutableArray *) vendorRequests;
- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withData:(NSMutableArray *) vendorRequests;

@end
