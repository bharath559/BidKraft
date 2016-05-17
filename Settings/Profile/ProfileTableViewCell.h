//
//  ProfileTableViewCell.h
//  Qwyvr
//
//  Created by Bharath kongara on 10/15/14.
//  Copyright (c) 2014 Qwyvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblProfileProperty;

@property (weak, nonatomic) IBOutlet UITextField *txtProfilePropertyValue;

@end
