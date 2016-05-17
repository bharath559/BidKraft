//
//  RequestTableViewCell.h
//  Neighbour
//
//  Created by bkongara on 9/10/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestedMode) {
    OpenRequests,
    ActiveRequests,
    CompletedRequests
};

@interface RequestTableViewCell :UITableViewCell

- (void)prepareCellForTabelView:(UITableView *)collectionView atIndex:(NSIndexPath *)indexPath;
-(void) prepareTableCellData:(RequestTableViewCell *)cell withIndexPath:(NSIndexPath *) indexPath;

@property (nonatomic,assign) NSInteger requestId;
@property (nonatomic,assign) BOOL isTableReload;
@property (nonatomic,strong) NSString *requestStatus;
@property (nonatomic,assign) RequestedMode requestMode;
//@property (nonatomic,strong)

@end
