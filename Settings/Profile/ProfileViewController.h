//
//  ProfileViewController.h
//  BidKraft
//
//  Created by Bharath Kongara on 3/29/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ProfilePictureDelegate<NSObject>

-(void) imageCpatured:(UIImage *) image;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic,weak) id<ProfilePictureDelegate> profilePictureDelegate;
@property (nonatomic,strong) NSString *isProfileShownModally;

@end
