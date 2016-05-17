//
//  PaymentViewController.m
//  BidKraft
//
//  Created by Raghav Sai on 4/1/15.
//  Copyright (c) 2015 ODU_HANDSON. All rights reserved.
//

#import "PaymentViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface PaymentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnPay;


@end

@implementation PaymentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![Venmo isVenmoAppInstalled])
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];
    else
        [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)payMoneyWithVenmo:(id)sender
{
    [[Venmo sharedInstance] sendRequestTo:@"7578147843"
                                   amount:1*100 // this is in cents!
                                     note:@"paisal evvu ra"
                        completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                            if (success) {
                                NSLog(@"Transaction succeeded!");
                                NSLog(@"%lu",(unsigned long)transaction.target.amount);
                            }
                            else {
                                NSLog(@"Transaction failed with error: %@", [error localizedDescription]);
                            }
                        }];
}



@end
