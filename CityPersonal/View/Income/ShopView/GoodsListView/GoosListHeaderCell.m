//
//  GoosListHeaderCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoosListHeaderCell.h"
#import "WaresCell.h"
#import "IphoneDetailsVC.h"
#import "GoodsListVC.h"
#import "RecommendModel.h"

@interface GoosListHeaderCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GoosListHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = backGroundColor;
        
        [self.contentView addSubview:self.collectionView];
    }
    
    return self;
}
/**
 *collectionView的懒加载
 */
- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向(竖向)
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //左右间距
        flowlayout.minimumInteritemSpacing = 100*m6Scale;
        //上下间距
        flowlayout.minimumLineSpacing = 0*m6Scale;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20*m6Scale, kScreenWidth, 282*m6Scale) collectionViewLayout:flowlayout];
        //遵循代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        //注册重用标识符
        [_collectionView registerClass:[WaresCell class] forCellWithReuseIdentifier:@"WaresCell"];
    }
    return _collectionView;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WaresCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaresCell" forIndexPath:indexPath];
    [cell cellForModel:[self.dataSource objectAtIndexVerify:indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //选中某个单元格
    if ([HCJFNSUser stringForKey:@"userId"]) {
        RecommendModel *model = [self.dataSource objectAtIndexVerify:indexPath.row];
        GoodsListVC *ctr = (GoodsListVC *)[self.contentView ViewController];
        IphoneDetailsVC *tempVC = [IphoneDetailsVC new];
        tempVC.goodsID = [NSString stringWithFormat:@"%@", model.ID];
        [ctr.navigationController pushViewController:tempVC animated:YES];
    }else{
        //发送通知提醒用户登录
        NSNotification *noti = [[NSNotification alloc] initWithName:@"alterUser" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
    }
}

- (void)setArray:(NSArray *)array{
    self.dataSource = array;
    
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(303*m6Scale, 256*m6Scale);
}

@end
