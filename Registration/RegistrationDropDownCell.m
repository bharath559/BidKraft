//
//  RegistrationDropDownCellTableViewCell.m
//  Neighbour
//
//  Created by ravi pitapurapu on 11/5/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "RegistrationDropDownCell.h"

@implementation RegistrationDropDownCell

- (void)awakeFromNib {
    
    [self prepareToolBar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) prepareToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    
    [toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    
    toolbar.userInteractionEnabled = YES;
    self.txtInputField.inputAccessoryView = toolbar;
    self.txtInputField.isOptionalDropDown = NO;
}
-(void) preparePickerData
{
    self.sourcesPickerData = [[NSMutableArray alloc] init];
    [self.sourcesPickerData addObject:@"Vendor"];
    [self.sourcesPickerData addObject:@"Requester"];
    [self.sourcesPickerData addObject:@"Both"];
    [self.txtInputField setItemList:self.sourcesPickerData];
}

-(void) doneClicked:(id) sender
{
    [self.dropDownDelegate valueSelected: sender];
}

@end
