//
//  ViewController.h
//  Neighbour
//
//  Created by bkongara on 8/28/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface LoginViewController : UIViewController

@property (nonatomic,strong) User *userData;

-(void) makeImageRoundCornerAndMoveCenter;

@end
