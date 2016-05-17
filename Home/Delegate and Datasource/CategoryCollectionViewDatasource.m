//
//  CategoryCollectionViewDatasource.m
//  Neighbour
//
//  Created by ravi pitapurapu on 9/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "CategoryCollectionViewDatasource.h"

#import "CategoryTypeCell.h"
#import "CategoryCollectionViewFlowLayout.h"

@interface CategoryCollectionViewDatasource ()


@end

@implementation CategoryCollectionViewDatasource

- (id)init
{
    self = [super init];
    if(self)
    {
        //Custom initialization
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(section ==0)
        return 3;
    return 1;
 }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CategoryTypeCell";
    CategoryTypeCell* cell =(CategoryTypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell prepareCellForCollectionView:collectionView atIndex:indexPath];
    return cell;
}


@end
