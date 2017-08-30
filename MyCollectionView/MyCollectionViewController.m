//
//  MyCollectionViewController.m
//  MyCollectionView
//
//  Created by Xu,Chao(MMS) on 2017/8/2.
//  Copyright © 2017年 Xu,Chao(MMS). All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyLayout.h"
#import "CollectionViewCell.h"

@interface MyCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation MyCollectionViewController

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)loadView{
    [self initData];
    /** 创建布局参数 */
    MyLayout * layout = [[MyLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-30, [[UIScreen mainScreen] bounds].size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(4, 5, 40, 25);
    [btn addTarget:self action:@selector(addCell) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btn2.frame = CGRectMake(0, 5, 40, 25);
    [btn2 addTarget:self action:@selector(deleteCell) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *delBtn = [[UIBarButtonItem alloc]initWithCustomView:btn2];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,addBtn,delBtn,nil];
    [topView setItems:buttonsArray];
    [self.collectionView addSubview:topView];
    // Do any additional setup after loading the view.
}

- (void)addCell {
    
    UIColor *color = [UIColor colorWithRed:rand()%100/100.f green:rand()%100/100.f blue:rand()%100/100.f alpha:rand()%100/100.f];
    [self.collectionView performBatchUpdates:^{
        // 构造一个indexPath
        NSIndexPath *indePath = [NSIndexPath indexPathForItem:_items.count inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indePath]]; // 然后在此indexPath处插入给collectionView插入一个item
        [_items addObject:color]; // 保持collectionView的item和数据源一致
    } completion:^(BOOL finished) {
//        [self.collectionView reloadData];
    }];
    
}

- (void)deleteCell {
    [self.collectionView performBatchUpdates:^{
        // 构造一个indexPath
        NSIndexPath *indePath = [NSIndexPath indexPathForItem:_items.count-1 inSection:0];
        [self.collectionView deleteItemsAtIndexPaths:@[indePath]];
        [_items removeObjectAtIndex:_items.count-1];
    } completion:^(BOOL finished) {
//        [self.collectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _items.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = (UIColor *)self.items[indexPath.row];
    [cell setReuse];
    return cell;
}

-(void)initData{
    _items = [[NSMutableArray alloc] init];
    for(int i = 0;i<5;i++){
        UIColor *color = [UIColor colorWithRed:rand()%100/100.f green:rand()%100/100.f blue:rand()%100/100.f alpha:rand()%100/100.f];
        [_items addObject:color];
    }
}


@end
