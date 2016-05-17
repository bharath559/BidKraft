//
//  CategoryCollectionViewDelgate.m
//  Neighbour
//
//  Created by ravi pitapurapu on 9/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "CategoryCollectionViewDelgate.h"
#import "CategoryCollectionViewFlowLayout.h"
#import "CreateRequestViewController.h"

@interface CategoryCollectionViewDelgate()

 @property (nonatomic,strong) CreateRequestViewController *createRequestViewController;

@property (nonatomic,strong) NSMutableArray *labelsArray;
@property (nonatomic,strong) NSString *categoryType;
@property (nonatomic,strong) NSString *categoryId;


@end

@implementation CategoryCollectionViewDelgate

-(void) prepareLabelArray
{
    self.labelsArray = [[NSMutableArray alloc] initWithCapacity:5];
    [self.labelsArray addObject:@"Baby Sitting"];
    [self.labelsArray addObject:@"Pet Care"];
    [self.labelsArray addObject:@"Sell Books"];
    [self.labelsArray addObject:@"Tutor"];

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self prepareLabelArray];
    
    NSString *categoryType =[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    self.categoryType = [[NSString alloc] initWithString:categoryType];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"User" bundle:[NSBundle mainBundle]];
    self.createRequestViewController = (CreateRequestViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"CreateRequestViewController"];
    self.createRequestViewController.categoryType = categoryType;
    self.createRequestViewController.homeViewController = self.homeViewController;
    self.createRequestViewController.categoryId = self.categoryId;
    [self.homeViewController.navigationController pushViewController:self.createRequestViewController animated:YES];
}

- (NSString *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
  //  NSInteger index = indexPath.section * [(CategoryCollectionViewFlowLayout *)collectionView.collectionViewLayout numberOfItemsPerSection:indexPath.section] + indexPath.item;
    
    NSInteger index;
    
    if(indexPath.section == 0)
        index = indexPath.row*(indexPath.section)+ indexPath.row;
    else
        index = indexPath.row*(indexPath.section)+ indexPath.row +3;
    
    NSLog(@"selected %ld",(long)index);
    NSString *selectedLabel =[self.labelsArray objectAtIndex:index];
    self.categoryId = [[NSString alloc] initWithFormat:@"%ld",((long)index+1)];
    return selectedLabel;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CreateRequest"])
    {
         CreateRequestViewController *createRequestViewController = [segue destinationViewController];
        createRequestViewController.categoryType = self.categoryType;
    }
}

@end
