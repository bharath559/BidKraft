//
//  OffersTableViewCell.h
//  Neighbour
//
//  Created by bkongara on 9/11/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OffersTableViewCell : UITableViewCell
- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withBids:(NSMutableArray *) listOfBids;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;

@property (nonatomic,assign) NSInteger bidId;

@end
