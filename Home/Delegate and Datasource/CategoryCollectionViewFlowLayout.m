//
//  CategoryCollectionViewFlowLayout.m
//  Neighbour
//
//  Created by ravi pitapurapu on 9/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "CategoryCollectionViewFlowLayout.h"

@interface CategoryCollectionViewFlowLayout ()

@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGPoint origin;

@end

@implementation CategoryCollectionViewFlowLayout

- (NSInteger)numberOfSections
{
    return 4;
}

- (NSInteger)numberOfItemsPerRow
{
    return 2;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
}
- (CGSize)itemSize
{
    CGFloat width = ([self.collectionView bounds].size.width - self.sectionInset.left - self.sectionInset.right - (self.minimumInteritemSpacing * ([self numberOfItemsPerRow] -1))) / [self numberOfItemsPerRow];
    CGFloat height = ([self.collectionView bounds].size.height- self.sectionInset.top - self.sectionInset.bottom - (([self numberOfRowsAllowedPerScreenOnCollectionView]-1)*self.minimumInteritemSpacing) )/[self numberOfRowsAllowedPerScreenOnCollectionView];
   
    height = height - 10;
    width = width - 45;

    return CGSizeMake(width, height);
}

- (NSInteger)numberOfRowsAllowedPerScreenOnCollectionView
{
    return 2;
}

@end
