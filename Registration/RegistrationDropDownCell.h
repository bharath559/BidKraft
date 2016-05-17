//
//  RegistrationDropDownCellTableViewCell.h
//  Neighbour
//
//  Created by ravi pitapurapu on 11/5/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@protocol RegistrationDropDownDelegate <NSObject>

-(void) valueSelected:(UITableViewCell *) tableCell;

@end

@interface RegistrationDropDownCell : UITableViewCell

@property (weak, nonatomic) IBOutlet IQDropDownTextField *txtInputField;
@property (nonatomic, strong) NSMutableArray *sourcesPickerData;
@property (nonatomic,weak) id<RegistrationDropDownDelegate> dropDownDelegate;

-(void) preparePickerData;
-(void) prepareToolBar;


@end
