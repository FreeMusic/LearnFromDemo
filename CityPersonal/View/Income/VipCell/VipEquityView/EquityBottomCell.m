//
//  EquityBottomCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "EquityBottomCell.h"
#import "UIButton+WebCache.h"
#import "VipEquityVC.h"

#define Width [UIScreen mainScreen].bounds.size.width/3
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface EquityBottomCell ()

@property (nonatomic, strong) NSMutableArray *vipPicArr;
@property (nonatomic, assign) NSInteger grade;//会员等级
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *vipArr;
@property (nonatomic, assign) NSInteger money;//用户财气值
@property (nonatomic, strong) NSMutableDictionary *gradeDic;//存放享受该权益的最小等级
@property (nonatomic, strong) NSMutableArray *array;//主要用来装六个按钮的tag值
@property (nonatomic, strong) NSString *currentIndex;//卡片划到的当前位置
@property (nonatomic, strong) NSMutableDictionary *mutableDic;

@end

@implementation EquityBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        //NewPagedFlowView（滑动视图的布局）
        [self creatView];
        //静态视图的布局
        [self createStaticView];
        
    }
    
    return self;
}
/**
 *存放享受该权益的最小等级
 */
- (NSMutableDictionary *)gradeDic{
    if(!_gradeDic){
        _gradeDic = [NSMutableDictionary dictionary];
    }
    return _gradeDic;
}
/**
 *主要用来装六个按钮的tag值
 */
- (NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}
/**
 *
 */
- (NSMutableDictionary *)mutableDic{
    if(!_mutableDic){
        _mutableDic = [NSMutableDictionary dictionary];
    }
    return _mutableDic;
}
/**
 布局（滑动视图的布局）
 */
- (void)creatView{
    
    _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 0*m6Scale, kScreenWidth, 293*m6Scale)];
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
    [self.contentView addSubview:_pageFlowView];
}
/**
 *静态视图的布局
 */
- (void)createStaticView{
    //标题标签
    _titleLabel = [Factory CreateLabelWithTextColor:0.6 andTextFont:26 andText:@"升级成为会员，可以享受以下专属特权" addSubView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_pageFlowView.mas_bottom).offset(10*m6Scale);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    //快去充值按钮
    _rechargeBtn = [UIButton buttonWithType:0];
    [_rechargeBtn setTitle:@"快去投资，升级您的VIP>" forState:0];
    [_rechargeBtn setTitleColor:UIColorFromRGB(0xFEAC2C) forState:0];
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    [self.contentView addSubview:_rechargeBtn];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30*m6Scale);
        make.bottom.mas_equalTo(-46*m6Scale);
        make.width.mas_equalTo(kScreenWidth/3*2);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
}
/**
 *用户会员背景图数组懒加载
 */
- (NSMutableArray *)vipPicArr{
    if(!_vipPicArr){
        _vipPicArr = [NSMutableArray array];
        //用户背景图数组
        for (int i = 0; i < 7; i++) {
            NSString *imgName = [NSString stringWithFormat:@"vip%d", i];
            
            [_vipPicArr addObject:imgName];
        }
    }
    return _vipPicArr;
}
/**
 *生成不同等级需要年化门槛 的数组d的懒加载
 */
- (NSMutableArray *)vipArr{
    if (!_vipArr) {
        _vipArr = [NSMutableArray array];
    }
    
    return _vipArr;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(569*m6Scale, 293*m6Scale);
}
#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return 7;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    _bannerView = (EquityIndexBannerView *)[flowView dequeueReusableCell];
    
    if (!_bannerView) {
        _bannerView = [[EquityIndexBannerView alloc] initWithFrame:CGRectMake(0, 0, 569*m6Scale, 293*m6Scale)];
        _bannerView.tag = index+100;
        _bannerView.layer.cornerRadius = 4;
        _bannerView.layer.masksToBounds = YES;
    }
    NSLog(@"%@", self.vipArr);
    if (self.vipArr.count) {
        [_bannerView setBackgroundImgViewByImgName:self.vipPicArr[index] andVipArr:self.vipArr andMoney:_money andGrade:_grade andIndex:index];
    }
    
    return _bannerView;
}
/**
 *滑动视图
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
        [self scrollToVipGrade:pageNumber andArray:self.equityArr];
}
/**
 *会员滑动到某个等级所享受的权益
 */
- (void)scrollToVipGrade:(NSInteger)grade andArray:(NSArray *)array{
    //图标和标签的循环创建
    for (int i = 0; i < array.count; i++) {
        //获取 能享受该会员权益所需要的最低会员等级
        NSString *minMemberGrade = [NSString stringWithFormat:@"%@", array[i][@"minMemberGrade"]];
        NSString *tag = self.array[i];
        UIButton *btn = (UIButton *)[self.contentView viewWithTag:tag.integerValue];
        //判断图标是否高亮来确定按钮的tag值是否大于1000
        if (grade < minMemberGrade.integerValue) {
            btn.selected = NO;
        }else{
            btn.selected = YES;
        }
    }
    self.currentIndex = [NSString stringWithFormat:@"%ld", grade];
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex{
    VipEquityVC *ctr = (VipEquityVC *)[self.contentView ViewController];
    [Factory addAlertToVC:ctr withMessage:@"投资年化=单笔投资金额×投资期限÷360"];
}
//会员可享受的权益 根据会员等级确定会员卡初始位置
- (void)cellForVipEquityByArray:(NSArray *)array andVipGrade:(NSString *)grade dictionary:(NSDictionary *)dictionary andMoney:(NSString *)monry{
    [self.vipArr addObject:dictionary[@"member_invest_amount_v0"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v1"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v2"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v3"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v4"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v5"]];
    [self.vipArr addObject:dictionary[@"member_invest_amount_v6"]];
    _grade = grade.integerValue;//会员等级
    _money = monry.integerValue;//会员财气值
    
    self.currentIndex = [NSString stringWithFormat:@"%ld", _grade];
    //图标和标签的循环创建
    for (int i = 0; i < array.count; i++) {
        _index++;
        _imgBtn = [UIButton buttonWithType:0];
        //获取 能享受该会员权益所需要的最低会员等级
        NSString *minMemberGrade = [NSString stringWithFormat:@"%@", array[i][@"minMemberGrade"]];
        //拿到每一个权益的ID
        NSString *equityId = [NSString stringWithFormat:@"%@", array[i][@"id"]];
        [self.mutableDic setValue:minMemberGrade forKey:equityId];
        NSString *chooseIcon = [NSString stringWithFormat:@"%@", array[i][@"chooseIcon"]];
        NSString *icon = [NSString stringWithFormat:@"%@", array[i][@"icon"]];
        [_imgBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:chooseIcon]]] forState:UIControlStateSelected];
        [_imgBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:icon]]] forState:0];
        
        //判断图标是否高亮来确定按钮的tag值是否大于1000
        if (_grade < minMemberGrade.integerValue) {
            //非高亮
            _imgBtn.tag = 1000+equityId.integerValue;
            _imgBtn.selected = NO;
        }else{
            //高亮
            _imgBtn.tag = 999-equityId.integerValue;
            _imgBtn.selected = YES;
        }
        NSLog(@"%ld", _imgBtn.tag);
        [self.array addObject:[NSString stringWithFormat:@"%ld", _imgBtn.tag]];
        [self.gradeDic setValue:array[i][@"minMemberGrade"] forKey:[NSString stringWithFormat:@"%ld", _imgBtn.tag]];
        
        [_imgBtn addTarget: self action:@selector(vipPrivilegeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_imgBtn];
        [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(110*m6Scale, 110*m6Scale));
            make.left.mas_equalTo((Width-110*m6Scale)/2+(i%3)*Width);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(34*m6Scale+(i/3)*194*m6Scale);
        }];
        //标签
        NSString *title = [NSString stringWithFormat:@"%@", array[i][@"privilegeValue"]];
        _label = [Factory CreateLabelWithTextColor:0.6 andTextFont:26 andText:title addSubView:self.contentView];
        _label.tag = 100+i;
        _label.textAlignment = NSTextAlignmentCenter;
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(Width*(i%3));
            make.width.mas_equalTo(Width);
            make.top.mas_equalTo(_imgBtn.mas_bottom).offset(20*m6Scale);
        }];
    }
    NSLog(@"%@", self.vipArr);
    
    [_pageFlowView reloadData];
    //根据会员等级确定会员卡初始位置
    [_pageFlowView scrollToPage:_grade];
}
/**
 *会员权益数组set方法
 */
- (void)setEquityArr:(NSArray *)equityArr{
    _equityArr = equityArr;
}
/**
 *会员特权按钮点击事件
 */
- (void)vipPrivilegeButtonClick:(UIButton *)sender{
    //通过点击哪个按钮 来确认该权益最小等级
    //NSString *grade = self.gradeDic[[NSString stringWithFormat:@"%ld", sender.tag]];
    //通知弹出视图
    NSNotification *notification = [[NSNotification alloc] initWithName:@"PushView" object:nil userInfo:@{@"tag":[NSString stringWithFormat:@"%ld", sender.tag], @"grade":self.currentIndex, @"dictionary":self.mutableDic}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PushView" object:nil];
}

@end
