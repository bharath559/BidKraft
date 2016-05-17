//
//  UserProfile.h
//  Neighbour
//
//  Created by Bharath kongara on 10/20/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *email;
@property (nonatomic,strong) UIImage *profilePicture;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *middleName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *vendorPoints;
@property (nonatomic, strong) NSString *userPoints;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, strong) NSString *userRating;




+ (UserProfile *)sharedData;

- (void)saveUserId:(NSString *)userId;
- (void)savePhoneNumber:(NSString *)phoneNumber;
- (void)saveFirstName:(NSString *)firstName;
- (void)saveMiddleName:(NSString *)middleName;
- (void)saveLastName:(NSString *)lastName;
- (void)saveEmail:(NSString *)email;
- (void)saveAddress:(NSString *)address;
- (void)saveFullName:(NSString *)fullname;
- (void)saveUserRating:(NSString *)userRating;
- (void)saveProfilePicture:(UIImage *) profilePicture;

- (void)saveVendorPoints:(NSString *)vendorPoints;
- (void)saveUserPoints:(NSString *)userPoints;
- (void)saveUserDescription:(NSString *)userDescription;


@end
