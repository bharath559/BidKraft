//
//  ProfileData.m
//  BidKraft
//
//  Created by Bharath Kongara on 4/24/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "ProfileData.h"
#import "SystemLevelConstants.h"

@interface ProfileData()

@property (nonatomic, strong) NSUserDefaults *defaults;


@end

@implementation ProfileData


+ (ProfileData *)sharedData
{
    static ProfileData *sharedData;
    @synchronized(self)
    {
        if (!sharedData)
            sharedData = [[ProfileData alloc] init];
        return sharedData;
    }
}

- (NSUserDefaults *)defaults
{
    if(!_defaults)
        _defaults = [NSUserDefaults standardUserDefaults];
    
    return _defaults;
}


- (void)saveFirstName:(NSString *)firstName
{
    [self.defaults setObject:firstName  forKey:kNeighbor_profilefirstName];
    self.firstName = firstName;
}

- (NSString *)firstName
{
    if(!_firstName)
    {
        NSString *fname = [self.defaults stringForKey:kNeighbor_profilefirstName];
        _firstName = fname;
    }
    
    return _firstName;
}

- (void)saveMiddleName:(NSString *)middleName
{
    [self.defaults setObject:middleName  forKey:kNeighbor_profilemiddleName];
    self.middleName = middleName;
}

- (NSString *)middleName
{
    if(!_middleName)
    {
        NSString *mname = [self.defaults stringForKey:kNeighbor_profilemiddleName];
        _middleName = mname;
    }
    
    return _middleName;
}

- (void)saveLastName:(NSString *)lastName
{
    [self.defaults setObject:lastName  forKey:kNeighbor_profilelastName];
    self.lastName = lastName;
}

- (NSString *)lastName
{
    if(!_lastName)
    {
        NSString *lname = [self.defaults stringForKey:kNeighbor_profilelastName];
        _lastName = lname;
    }
    
    return _lastName;
}

- (void)saveEmail:(NSString *)email
{
    [self.defaults setObject:email  forKey:kNeighbor_profileemail];
    self.email = email;
}

- (NSString *)email
{
    if(!_email)
    {
        NSString *email = [self.defaults stringForKey:kNeighbor_profileemail];
        _email = email;
    }
    
    return _email;
}

- (void)saveAddress:(NSString *)address
{
    [self.defaults setObject:address  forKey:kNeighbor_profileaddress];
    self.address = address;
}

- (NSString *)address
{
    if(!_address)
    {
        NSString *address = [self.defaults stringForKey:kNeighbor_profileaddress];
        _address = address;
    }
    
    return _address;
}
- (void)saveProfilePicture:(UIImage *) profilePicture;
{
    NSData* imageData = UIImagePNGRepresentation(profilePicture);
    NSString* encodedImageData = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self.defaults setObject:encodedImageData forKey:kNeighbor_profileprofilePicture];
    self.profilePicture = profilePicture;
}

-(UIImage *)profilePicture
{
    if(!_profilePicture)
    {
        NSString *encodedImageData = [self.defaults objectForKey:kNeighbor_profileprofilePicture];
        NSData *data = [[NSData alloc] initWithBase64EncodedString:encodedImageData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage* image = [UIImage imageWithData:data];
        _profilePicture = image;
    }
    
    return _profilePicture;
    
}

- (void)saveUserId:(NSString *)userId
{
    [self.defaults setObject:userId forKey:kNeighbor_userid];
}

- (NSString *)userId
{
    if(!_userId)
    {
        NSString *uid = [self.defaults stringForKey:kNeighbor_userid];
        if(uid)
            _userId = uid;
    }
    
    return _userId;
}

//Saving the phone number for the first time
- (void)savePhoneNumber:(NSString *)phoneNumber
{
    [self.defaults setObject:phoneNumber forKey:kNeighbor_profilephone_number];
    self.phoneNumber = phoneNumber;
}

- (NSString *)phoneNumber
{
    if(!_phoneNumber)
    {
        NSString *phone = [self.defaults stringForKey:kNeighbor_profilephone_number];
        if(phone)
            _phoneNumber = phone;
    }
    
    return _phoneNumber;
}

-(void) saveVendorPoints:(NSString *)vendorPoints
{
    [self.defaults setObject:vendorPoints forKey:kNeighbor_profilevendor_points];
    self.vendorPoints = vendorPoints;
    
}
-(NSString *) vendorPoints
{
    if(!_vendorPoints)
    {
        NSString *vendorPoints = [self.defaults stringForKey:kNeighbor_profilevendor_points];
        if(vendorPoints)
            _vendorPoints = vendorPoints;
    }
    return _vendorPoints;
}

-(void) saveUserPoints:(NSString *)userPoints
{
    [self.defaults setObject:userPoints forKey:kNeighbor_profileuser_points];
    self.userPoints = userPoints;
}

-(NSString *) userPoints
{
    if(!_userPoints)
    {
        NSString *userPoints = [self.defaults stringForKey:kNeighbor_profileuser_points];
        if(userPoints)
            _userPoints = userPoints;
    }
    return _userPoints;
}

-(void) saveUserDescription:(NSString *)userDescription
{
    [self.defaults setObject:userDescription forKey:kNeighbor_profileuser_description];
    self.userDescription = userDescription;
    
}

-(NSString *) userDescription
{
    if(!_userDescription)
    {
        NSString *userDescription = [self.defaults stringForKey:kNeighbor_profileuser_description];
        if(_userDescription)
            _userDescription = userDescription;
    }
    return _userDescription;
}
-(void) saveFullName:(NSString *)fullName
{
    [self.defaults setObject:fullName forKey:kNeighbor_profileuser_fullname];
    self.fullname = fullName;
}

-(NSString *) fullname
{
    if(!_userDescription)
    {
        NSString *fullName = [self.defaults stringForKey:kNeighbor_profileuser_fullname];
        if(_fullname)
            _fullname = fullName;
    }
    return _fullname;
}

-(void) saveUserRating:(NSString *)userRating
{
    [self.defaults setObject:userRating forKey:kNeighbor_profileuser_ratings];
    self.userRating = userRating;
}

-(NSString *) userRating
{
    if(!_userDescription)
    {
        NSString *userRating = [self.defaults stringForKey:kNeighbor_profileuser_ratings];
        if(_userRating)
            _userRating = userRating;
    }
    return _userRating;
}
@end
