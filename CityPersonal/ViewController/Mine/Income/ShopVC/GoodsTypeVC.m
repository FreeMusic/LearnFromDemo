//
//  GoodsTypeVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "GoodsTypeVC.h"
#import "MyiPhoneCell.h"
#import "IphoneDetailsVC.h"

@interface GoodsTypeVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *contentArr;//商品数组
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIImageView *iconImg;//头部图片
@property (nonatomic, strong) NSURL *url;//图片的URl地址

@end

@implementation GoodsTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.collectionView];
    [self.contentArr removeAllObjects];
    [self.collectionView reloadData];
}

/**
 *collectionView的懒加载
 */
- (UICollectionView*)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滚动方向(竖向)
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //左右间距
        flowlayout.minimumInteritemSpacing = 0*m6Scale;
        //上下间距
        flowlayout.minimumLineSpacing = 0*m6Scale;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight-90*m6Scale) collectionViewLayout:flowlayout];
        //遵循代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = backGroundColor;
        //注册重用标识符
        [_collectionView registerClass:[MyiPhoneCell class] forCellWithReuseIdentifier:@"MyiPhoneCell"];
        //注册头视图
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    
    return _collectionView;
}
/**
 *暂无数据图片
 */
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] init];
        _backImgView.image = [UIImage imageNamed:@"无数据"];
        [self.view addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(260*m6Scale, 260*m6Scale));
            make.centerY.mas_equalTo(self.view.mas_centerY);
        }];
    }
    return _backImgView;
}
/**
 *商品数组的懒加载
 */
- (NSMutableArray *)contentArr{
    if(!_contentArr){
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
/**
 *头部图片
 */
- (UIImageView *)iconImg{
    if(!_iconImg){
        _iconImg = [[UIImageView alloc] init];
    }
    return _iconImg;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *请求数据
 */
- (void)serviceData{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //_hud.label.text = NSLocalizedString(@"加载数据中...", @"HUD done title");
    //某个类目下的商品所有列表
    [DownLoadData postGetGoodsListAllByType:^(id obj, NSError *error) {
        self.contentArr = obj[@"SUCCESS"];
        [_hud setHidden:YES];
        if (self.contentArr.count == 0) {
            self.backImgView.hidden = NO;
            _collectionView.backgroundColor = [UIColor whiteColor];
        }else{
            self.backImgView.hidden = YES;
            _collectionView.backgroundColor = backGroundColor;
        }
        [self.collectionView reloadData];
    }userId:[HCJFNSUser stringForKey:@"userId"] typeId:[NSString stringWithFormat:@"%ld", self.view.tag-1000]];
    //获取商品类目icon
    [DownLoadData postGetTypeIcon:^(id obj, NSError *error) {
        NSString *pic = obj[@"ret"][@"icon"];
        self.url = [NSURL URLWithString:pic];
        
        [self.collectionView reloadData];
    } typeId:[NSString stringWithFormat:@"%ld", self.view.tag-1000]];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyiPhoneCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyiPhoneCell" forIndexPath:indexPath];
    [cell cellForModel:self.contentArr[indexPath.row] andIndex:indexPath.row];
    
    return cell;
}
#pragma mark - 设置collectionView的item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenWidth/2, 380*m6Scale);
}
#pragma mark - 设置collectionView的头部大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 240*m6Scale);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头部视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:219/255.0 alpha:1.0];
        self.iconImg.frame = CGRectMake(0, 0, kScreenWidth, 240*m6Scale);
        [self.iconImg sd_setImageWithURL:self.url placeholderImage:[UIImage imageNamed:@"750x240"]];
        [header addSubview:self.iconImg];
        
        
        return header;
    }
    //如果是footer
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([HCJFNSUser stringForKey:@"userId"]) {
        IphoneModel *model = self.contentArr[indexPath.row];
        //锁投有礼详情页
        IphoneDetailsVC *tempVC = [[IphoneDetailsVC alloc] init];
        tempVC.goodsID = [NSString stringWithFormat:@"%@", model.ID];
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        [Factory alertMes:@"请您先登录"];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //获取当前的产品类型的ID
    self.typeID = [NSString stringWithFormat:@"%ld", self.view.tag-1000];
    //请求数据
    [self serviceData];
}
@end
