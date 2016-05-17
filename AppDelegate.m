//
//  AppDelegate.m
//  Neighbour
//
//  Created by bkongara on 8/28/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MPGNotification.h"
#import "User.h"
#import "Reachability.h"
#import "SystemLevelConstants.h"
#import <Venmo-iOS-SDK/Venmo.h>


@interface AppDelegate ()

@property (nonatomic, strong) MPGNotification *notification;
@property (nonatomic, strong) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) User  *userData;


@end
@implementation AppDelegate


- (User *)userData
{
    if(!_userData)
        _userData = [User sharedData];
    
    return _userData;
}

- (NSNotificationCenter *)notificationCenter
{
    if(!_notificationCenter)
        _notificationCenter = [NSNotificationCenter defaultCenter];
    
    return _notificationCenter;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"Ad-iwxBZKzcCobNuH621s03dMgzgfrL5-27uYltcJIi_-F10yfO_MYtOvkni"}];
    
    [Venmo startWithAppId:@"2660" secret:@"5SDYdjJdHGG5Mkqd4PUXGZ2fQk98LDN6" name:@"BidKraft"];

    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [self registerForNotifications];
    [Reachability monitorNetworkAndPostReachablityNotification];
    return YES;
}

#pragma mark - Utility methods
- (void)registerForNotifications
{
    [self.notificationCenter addObserver:self selector:@selector(networkNotReachable:) name:kReachabilityStatus_NoNetwork object:nil];
    [self.notificationCenter addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    [self registrForPushNotifications];
}

- (void)registrForPushNotifications
{
    //-- Set Notification
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    if(userInfo)
    {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        
    }
    
}

-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog(@"Time Out.");
   
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    self.userData.notificationToken = deviceToken;
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Problem in registering for notifications" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil,nil];
    [alert show];
    NSLog(@"Failed to get token, error: %@", error);
}


- (void)networkNotReachable:(NSNotification *)notification
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Not Reachable" message:@"Unable to reach network. Please Check your network settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([[Venmo sharedInstance] handleOpenURL:url]) {
        return YES;
    }

    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
