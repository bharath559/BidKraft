//
//  VendorSearchTableViewCell.h
//  BidKraft
//
//  Created by Bharath Kongara on 5/20/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VendorRequestsMode) {
    VendorsRequestedOpen,
    VendorsRequestedOwn,
    VendorsRequestedCompleted
};


@interface VendorSearchTableViewCell : UITableViewCell



@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,assign) BOOL isTableReload;
@property (nonatomic,strong) NSString *requestDescription;
@property (nonatomic,assign) VendorRequestsMode vendorRequestedMode;

-(void) prepareTableCellData:(VendorSearchTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath;
- (void)prepareCellForTabelView:(UITableView *)collectionView atIndex:(NSIndexPath *)indexPath;

@end
