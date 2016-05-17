//
//  UIBlurView.m
//  Neighbour
//
//  Created by ravi pitapurapu on 9/8/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "UIBlurView.h"

@interface UIBlurView ()

@property (nonatomic, strong) UINavigationBar *navigationBar;

@end

@implementation UIBlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyBlur];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self applyBlur];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self applyBlur];
    }
    return self;
}

- (void)applyBlur
{
    [self setClipsToBounds:YES];
    
    if (![self navigationBar])
    {
        [self setNavigationBar:[[UINavigationBar alloc] initWithFrame:[self bounds]]];
        CALayer *layer = [self.navigationBar layer];
        if(layer)
            [self.layer insertSublayer:layer atIndex:0];
        else
            self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
    }
    else
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.97];
}

@end
