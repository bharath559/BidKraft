//
//  SettingsTableCell.h
//  BidKraft
//
//  Created by Bharath Kongara on 5/13/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryTitle;
@property (weak, nonatomic) IBOutlet UISwitch *controlSwitch;

@end


