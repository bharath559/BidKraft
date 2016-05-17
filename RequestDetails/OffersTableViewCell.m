//
//  OffersTableViewCell.m
//  Neighbour
//
//  Created by bkongara on 9/11/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "OffersTableViewCell.h"
#import "User.h"


@interface OffersTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lblBidType;
@property (weak, nonatomic) IBOutlet UILabel *lblBestOffers;
@property (weak,nonatomic)  NSMutableArray *imgUserArray;
@property (strong,nonatomic) NSMutableArray *requestArrays;
@property (strong,nonatomic) UserRequests *usrRequest;
@property (nonatomic,strong) BidDetails *bidDetail;
@property (nonatomic,strong) NSMutableArray *bidsArray;


@end
@implementation OffersTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) mockData
{
    User *userData = [User sharedData];
    self.requestArrays = userData.usrRequests;
  
}

- (void)prepareCellForTabelView:(UITableView *)tableView atIndex:(NSIndexPath *)indexPath withBids:(NSMutableArray *)listOfBids{
   

    NSInteger index = indexPath.section * [self.requestArrays count] + indexPath.item;
    BidDetails *requestBidDetail = [listOfBids objectAtIndex:index];
    self.lblBidType.text= requestBidDetail.userName;
    self.lblBestOffers.text = [[@(requestBidDetail.bidAmount) stringValue] stringByAppendingString:@"$/hr"];
    
}


@end
