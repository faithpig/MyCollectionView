//
//  MyLayout.m
//  MyCollectionView
//
//  Created by Xu,Chao(MMS) on 2017/8/2.
//  Copyright © 2017年 Xu,Chao(MMS). All rights reserved.
//

#import "MyLayout.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface MyLayout ()

@property (nonatomic, assign) CGFloat itemCount;
@property (nonatomic, assign) CGFloat numbersOfColumn;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) NSInteger minCellHeight;
@property (nonatomic, assign) NSInteger maxCellHeight;
@property (nonatomic, assign) NSInteger cellWidth;

@property (nonatomic, strong) NSMutableArray* cellHeightArray;
@property (nonatomic, strong) NSMutableArray* cellXArray;
@property (nonatomic, strong) NSMutableArray* cellYArray;

@property (nonatomic, strong) NSMutableArray* attrArray;
@property (nonatomic, strong) NSMutableArray* indexPathsToAnimate;


@end



@implementation MyLayout

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    self.indexPathsToAnimate = indexPaths;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = nil;
    if(_attrArray.count == 0 ||_attrArray.count-1<itemIndexPath.row){
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        [_attrArray addObject:attributes];
    } else {
        attributes = _attrArray[itemIndexPath.row];
    }
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attributes.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), M_PI);
        attributes.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT);
        [_indexPathsToAnimate removeObject:itemIndexPath];
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath{
    UICollectionViewLayoutAttributes *attributes = nil;
    if(_attrArray.count == 0 ||_attrArray.count-1<itemIndexPath.row){
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        [_attrArray addObject:attributes];
    } else {
        attributes = _attrArray[itemIndexPath.row];
    }
    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
        attributes.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(5,5), M_PI);
        if(itemIndexPath.row>15) attributes.center = CGPointMake(0, 0);
        else attributes.center = CGPointMake(SCREEN_WIDTH, 0);
    }
    return attributes;
}



-(void)prepareLayout{
    [super prepareLayout];
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    _numbersOfColumn = 5;
    _padding = 2;
    _minCellHeight = 60;
    _maxCellHeight = 90;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,^{
        [self initCellWidth];
    });
    _attrArray = [[NSMutableArray alloc] init];
    [self initCellHeight];
    [self initCellYArray];
}

-(CGSize)collectionViewContentSize{
    CGFloat height = [self maxCellYArrayWithArray:_cellYArray];
    return CGSizeMake(SCREEN_WIDTH,  height);
}

-(nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:_itemCount];
    for(int i = 0; i<_itemCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [array addObject:attribute];
    }
    return array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributes = nil;
    if(_attrArray.count == 0 ||_attrArray.count-1<indexPath.row){
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        [_attrArray addObject:attributes];
    } else {
        attributes = _attrArray[indexPath.row];
        return attributes;
    }
    
    CGRect frame = CGRectZero;
    
    NSInteger minYIndex = [self minCellYWithArray:_cellYArray];
    
    CGFloat tempX = [_cellXArray[minYIndex] floatValue];
    
    CGFloat tempY = [_cellYArray[minYIndex] floatValue];
    
    frame = CGRectMake( tempX, tempY, _cellWidth, [_cellHeightArray[indexPath.row] floatValue]);
    
    _cellYArray[minYIndex] = @(tempY + [_cellHeightArray[indexPath.row] floatValue] + _padding);
    
    attributes.frame = frame;

    
    return attributes;
}

/**
 * 随机生成Cell的高度
 */
- (void) initCellHeight{
    //随机生成Cell的高度
    _cellHeightArray = [[NSMutableArray alloc] initWithCapacity:_itemCount];
    for (int i = 0; i < _itemCount; i ++) {
        CGFloat cellHeight = arc4random()%(_maxCellHeight - _minCellHeight)+_minCellHeight;
        [_cellHeightArray addObject:@(100)];
    }
    
}

- (void) initCellWidth{
    _cellWidth = (SCREEN_WIDTH - (_numbersOfColumn-1)*_padding)/_numbersOfColumn;
    
    //每个cell的x坐标
    _cellXArray = [[NSMutableArray alloc] initWithCapacity:_numbersOfColumn];
    for (int i = 0; i < _itemCount; i ++) {
        CGFloat tempX = i * (_cellWidth + _padding);
        [_cellXArray addObject:@(tempX)];
    }
}

/**
 * 初始化每列Cell的Y轴坐标
 */
- (void) initCellYArray{
    if (_cellYArray == nil) {
        _cellYArray = [[NSMutableArray alloc] initWithCapacity:_numbersOfColumn];
    }
    for (int i = 0; i < _numbersOfColumn; i ++) {
        _cellYArray[i] = @0;
    }
}

/**
 * 求CellY数组中的最大值并返回
 */
- (CGFloat) maxCellYArrayWithArray: (NSMutableArray *) array{
    if (array.count == 0) {
        return 0.0f;
    }
    CGFloat max = [array[0] floatValue];
    for (NSNumber *number in array) {
        CGFloat temp = [number floatValue];
        if (max < temp) {
            max = temp;
        }
    }
    
    return max;
}

/**
 * 求CellY数组中的最小值的索引
 */
- (CGFloat) minCellYWithArray: (NSMutableArray *) array{
    
    if (array.count == 0) {
        return 0.0f;
    }
    
    NSInteger minIndex = 0;
    CGFloat min = [array[0] floatValue];
    
    for (int i = 0; i < array.count; i ++) {
        CGFloat temp = [array[i] floatValue];
        
        if (min > temp) {
            min = temp;
            minIndex = i;
        }
    }
    
    return minIndex;
}



@end
