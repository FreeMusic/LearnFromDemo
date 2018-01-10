//
//  RecommendedCell.m
//  CityJinFu
//
//  Created by xxlc on 17/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "RecommendedCell.h"
#import "ItemListModel.h"

@interface RecommendedCell ()

@property(nonatomic, strong) NSArray *dataArr;

@property (nonatomic,strong) NewPagedFlowView *pageFlowView;

@property (nonatomic,strong) PGIndexBannerSubiew *bannerView;

@property (nonatomic,strong) ItemListModel *model;

@property(nonatomic, strong) UIImageView *backImgView;//暂无数据背景图

@end

@implementation RecommendedCell 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{

    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, -30*m6Scale, kScreenWidth, kScreenWidth * 9 / 16)];
    _pageFlowView.delegate = self;
    _pageFlowView.dataSource = self;
    _pageFlowView.minimumPageAlpha = 0.1;
    _pageFlowView.isCarousel = NO;
    _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    _pageFlowView.isOpenAutoScroll = YES;
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
//    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:backView.bounds];
//    [bottomScrollView addSubview:pageFlowView];
    [_pageFlowView reloadData];
    [self.contentView addSubview:_pageFlowView];
    

}
/**
 *暂无数据背景图
 */
- (UIImageView *)backImgView{
    if(!_backImgView){
        _backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"无数据"]];
        [self addSubview:_backImgView];
        [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130*m6Scale, 130*m6Scale));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return _backImgView;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(kScreenWidth - 60, (kScreenWidth - 60) * 9 / 16);
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    UIViewController *ctr = (UIViewController *)[self ViewController];
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    ItemListModel *model = _dataArr[subIndex];
    //if ([defaults objectForKey:@"userId"]) {
        ItemTypeVC *itemVC = [ItemTypeVC new];
        itemVC.itemId = [NSString stringWithFormat:@"%@",model.ID];//标ID
        itemVC.itemNameText = model.itemName;
        itemVC.itemStatus = model.itemStatus;//标的状态
        [ctr.navigationController pushViewController:itemVC animated:YES];
//    }else {
//        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            SignViewController *signVC = [[SignViewController alloc] init];
//            signVC.presentTag = @"2";
//            [ctr presentViewController:signVC animated:YES completion:nil];
//        }]];
//        
//        [ctr presentViewController:alert animated:YES completion:nil];
//    }

    
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return _dataArr.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    _bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!_bannerView) {
        _bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9 / 16)];
        _bannerView.tag = index;
        _bannerView.layer.cornerRadius = 4;
        _bannerView.layer.masksToBounds = YES;
    }
    
    [_bannerView viewForModel:_dataArr[index]];
    //    bannerView.mainImageView.image = self.imageArray[index];
    
    return _bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
//    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
    _model = _dataArr[pageNumber];
    
}

- (void)cellForModelArray:(NSArray *)array{
    NSLog(@"%@", array);
    _dataArr = array;
    if (array.count) {
        self.backImgView.hidden = YES;
        [_pageFlowView reloadData];
    }else{
        self.backImgView.hidden = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
