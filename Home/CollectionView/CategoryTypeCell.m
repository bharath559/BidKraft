	//
//  CategoryTypeCell.m
//  Neighbour
//
//  Created by ravi pitapurapu on 9/4/14.
//  Copyright (c) 2014 ODU_HANDSON. All rights reserved.
//

#import "CategoryTypeCell.h"

#import "CategoryCollectionViewFlowLayout.h"

@interface CategoryTypeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *imageNamesArray;

@end

@implementation CategoryTypeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)mockData
{
    self.labelsArray = [[NSMutableArray alloc] initWithCapacity:5];
    [self.labelsArray addObject:@"Child Care"];
    [self.labelsArray addObject:@"Pet Care"];
    [self.labelsArray addObject:@"Sell Books"];
    
    [self.labelsArray addObject:@"Tutor"];
    
    self.imageNamesArray = [[NSMutableArray alloc] initWithCapacity:5];
    [self.imageNamesArray addObject:@"rigid_baby"];
    [self.imageNamesArray addObject:@"pet"];
    [self.imageNamesArray addObject:@"textbook"];
    [self.imageNamesArray addObject:@"tutor"];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.categoryImage = nil;
    self.categoryName = nil;
}

- (void)prepareCellForCollectionView:(UICollectionView *)collectionView atIndex:(NSIndexPath *)indexPath
{
    if(!self.imageNamesArray)
        [self mockData];
    
    NSInteger index;
    
    if(indexPath.section == 0)
    
      index = indexPath.row*(indexPath.section)+ indexPath.row;
    else
        index = indexPath.row*(indexPath.section)+ indexPath.row +3;
   
    self.categoryImage.image = [UIImage imageNamed:[self.imageNamesArray objectAtIndex:index]];
    [self prepareImageAtIndexPath:indexPath];
    self.categoryName.text = [self.labelsArray objectAtIndex:index];
}

- (void)prepareImageAtIndexPath:(NSIndexPath *)indexPath
{
    self.categoryImage.layer.masksToBounds = YES;
    self.categoryImage.layer.cornerRadius = (self.categoryImage.frame.size.width)/2;
    self.categoryImage.clipsToBounds = YES;
}

@end
