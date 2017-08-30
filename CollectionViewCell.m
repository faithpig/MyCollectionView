//
//  CollectionViewCell.m
//  MyCollectionView
//
//  Created by Xu,Chao(MMS) on 2017/8/2.
//  Copyright © 2017年 Xu,Chao(MMS). All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()

@end


@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/** 注意：
 *      清除subView以及重新添加并布局cellview 的功能适合在cellForItemAtIndexPath里做
 *      而不是prepareForReuse,因为在prepareForReuse方法里尚未真正获得cell的bounds
 */
-(void)setReuse{
    for(UIView *view in self.contentView.subviews){
        [view removeFromSuperview];
    }
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tiantiansifangmao-%d",arc4random()%19]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    self.contentView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentView.clipsToBounds = YES;
    [imageView setCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))];
    [imageView setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];

}

@end
