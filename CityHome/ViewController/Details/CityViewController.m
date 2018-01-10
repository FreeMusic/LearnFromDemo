//
//  CityViewController.m
//  CityJinFu
//
//  Created by xxlc on 16/8/9.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "CityViewController.h"
#import "SXTitleLable.h"
#import "DetailsVC.h"
#import "RecordVC.h"
#import "RiskVC.h"
#import "InstantInvestViewController.h"


@interface CityViewController ()<UIScrollViewDelegate>
/** 标题栏 */
@property (strong, nonatomic) UIScrollView *smallScrollView;
/** 下面的内容栏 */
@property (strong, nonatomic) UIScrollView *bigScrollView;
@property (nonatomic,strong) SXTitleLable *oldTitleLable;
@property (nonatomic,assign) CGFloat beginOffsetX;
@property (nonatomic, strong) UIButton *buyBtn;//立即投资按钮


@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //导航栏的定制
    UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    backview.backgroundColor = ButtonColor;
    [self.view addSubview:backview];
    
    UILabel *titleLabel1 = [UILabel new];
    titleLabel1.text = @"风险保护";
    titleLabel1.font = [UIFont systemFontOfSize:40*m6Scale];
    titleLabel1.textColor = [UIColor whiteColor];
    titleLabel1.textAlignment = NSTextAlignmentCenter;
    titleLabel1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel1];
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backview.mas_centerX);
        make.centerY.equalTo(backview.mas_centerY).offset(5);
        make.size.mas_equalTo(CGSizeMake(600*m6Scale, 64*m6Scale));
    }];
    //左边按钮
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
//    left.frame = CGRectMake(30*m6Scale, 60*m6Scale, 40*m6Scale, 40*m6Scale);
    [left setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onClickLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:left];
    [left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backview.mas_left).offset(30*m6Scale);
        make.centerY.equalTo(backview.mas_centerY).offset(15*m6Scale);
        make.size.mas_equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
    }];
    
    
//    //立即投资
//    _buyBtn = [SubmitBtn buttonWithType:UIButtonTypeCustom];
//    if (self.signStr.floatValue == 0.00) {
//        _buyBtn.backgroundColor = [UIColor lightGrayColor];
//        _buyBtn.userInteractionEnabled = NO;
//    }
//    else {
//        _buyBtn.userInteractionEnabled = YES;
//        _buyBtn.backgroundColor = buttonColor;
//    }
//    [_buyBtn setTitle:@"立即投资" forState:UIControlStateNormal];
//    [_buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_buyBtn];
//    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(20*m6Scale);
//        make.right.equalTo(self.view.mas_right).offset(-20*m6Scale);
//        make.height.mas_equalTo(@(90*m6Scale));
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50*m6Scale);
//    }];

    [self scrollow];//添加头部
    [DownLoadData postGetRiskTemplet:^(id obj, NSError *error) {
        
    } itemId:@""];
}
/**
 *  返回
 */
- (void)onClickLeft:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * 立即投资
 */
- (void)buyBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
    InstantInvestViewController *itemType = [InstantInvestViewController new];
    itemType.hidesBottomBarWhenPushed = YES;
    [navi pushViewController:itemType animated:YES];
    
}

- (void)scrollow{
    self.bigScrollView = [[UIScrollView alloc]init];
    self.bigScrollView.frame = CGRectMake(0,64,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.view addSubview:self.bigScrollView];

    self.smallScrollView = [[UIScrollView alloc]init];
    _smallScrollView.backgroundColor = [UIColor whiteColor];
    
    self.smallScrollView.frame = CGRectMake(0,64,[[UIScreen mainScreen] bounds].size.width, 45);
    // self.smallScrollView.backgroundColor=GrayColor;
    [self.view addSubview:self.smallScrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    
    NSLog(@"%@",self.childViewControllers);
    [self addController];
    [self addLable];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    //    vc.view.frame = self.bigScrollView.bounds;
    vc.view.frame=CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [self.bigScrollView addSubview:vc.view];
    
    SXTitleLable *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat offsetX = _tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];

}
/** 添加子控制器 */
- (void)addController
{
    DetailsVC *vc1 = [[DetailsVC alloc]init];
    RecordVC *vc2 = [[RecordVC alloc]init];
    RiskVC *vc3 = [[RiskVC alloc]init];
    vc1.title = @"标的详情";
    vc2.title = @"投资记录";
    vc3.title = @"风险保护";
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
    
    
}
/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < 3; i++) {
        CGFloat lblW = [[UIScreen mainScreen] bounds].size.width/3;
        CGFloat lblH = 45;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        SXTitleLable *lbl1 = [[SXTitleLable alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text =vc.title;
        
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        //修改标题的字体
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:20];
        lbl1.textAlignment = NSTextAlignmentCenter;
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake(70 * 3, 0);
    
}
/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    SXTitleLable *titlelable = (SXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    
}

#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
//    SXTitleLable *titleLable = (SXTitleLable *)self.smallScrollView.subviews[index];
    
//    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
//    
//    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;

    // 添加控制器
    UIViewController *VC0 = nil;
    VC0=self.childViewControllers[index];
    //vc1.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (VC0.view.superview) return;
    
    //    happyVc.view.frame = scrollView.bounds;
    VC0.view.frame =CGRectMake(index * scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height);
    [self.bigScrollView addSubview:VC0.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
