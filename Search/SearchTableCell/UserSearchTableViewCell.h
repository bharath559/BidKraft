//
//  UserSearchTableViewCell.h
//  BidKraft
//
//  Created by Bharath Kongara on 5/20/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestsMode) {
    OpenRequest,
    ActiveRequest,
    CompletedRequest
};

@interface UserSearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *bidAmount;

@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,assign) BOOL isTableReload;


- (void)prepareCellForTabelView:(UITableView *)collectionView atIndex:(NSIndexPath *)indexPath;
-(void) prepareTableCellData:(UserSearchTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath;

@end
