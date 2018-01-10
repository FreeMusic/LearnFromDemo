//
//  MoneyPlanVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/13.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MoneyPlanVC.h"
#import "GoingVC.h"
#import "FinishedVC.h"
#import "FatherVC.h"

@interface MoneyPlanVC ()

@property (nonatomic, strong) UILabel *amountLabel;//锁定本金标签
@property (nonatomic, strong) UILabel *incomeLabel;//累计收益标签
@property (nonatomic, strong) NSString *amount;//锁定本金
@property (nonatomic, strong) NSString *income;//累计收益

@end

@implementation MoneyPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"锁投加息"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //理财计划头部view
    [self headerView];
    //添加子控制器
    [self addChildVC];
    //请求数据
    [self serviceData];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *添加子控制器
 */
- (void)addChildVC{
    //进行中
    GoingVC *selected = [GoingVC new];
    selected.title = @"进行中";
    //已结束
    FinishedVC *carCredit = [FinishedVC new];
    carCredit.title = @"已结束";
    //数组
    NSArray *subViewControllers = @[selected, carCredit];
    FatherVC *fatherVC = [[FatherVC alloc]initWithSubViewControllers:subViewControllers];
    fatherVC.view.frame = CGRectMake(0, 208*m6Scale, kScreenWidth, kScreenHeight);
    
    [self.view addSubview:fatherVC.view];
    [self addChildViewController:fatherVC];
}
/**
 *请求数据
 */
- (void)serviceData{
    //我的计划规则统计
    [DownLoadData postCountPlans:^(id obj, NSError *error) {
        NSString *amount = [NSString stringWithFormat:@"%@", obj[@"ret"][@"planAutoAmount"]];
        NSString *income = [NSString stringWithFormat:@"%@", obj[@"ret"][@"planAutoIncome"]];
        self.amountLabel.text = [NSString stringWithFormat:@"%.2f", amount.doubleValue];
        self.incomeLabel.text = [NSString stringWithFormat:@"%.2f", income.doubleValue];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *理财计划头部view
 */
- (void)headerView{
    //
    CGFloat width = kScreenWidth/2;
    //头部背景图
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 208*m6Scale)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    //竖线
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [topView addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38*m6Scale);
        make.bottom.mas_equalTo(-38*m6Scale);
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    //横线
    UIView *bottomVeiw = [[UIView alloc] init];
    bottomVeiw.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [topView addSubview:bottomVeiw];
    [bottomVeiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    NSArray *textArr = @[@"锁定本金(元)", @"累计收益(元)"];
    //循环两个标签的创建
    for (int i = 0; i < 2; i++) {
        UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:textArr[i] addSubView:topView];
        label.textColor = UIColorFromRGB(0x9d9d9d);
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i%2*width);
            make.top.mas_equalTo(38*m6Scale);
            make.width.mas_equalTo(width);
        }];
        if (i) {
            [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_left);
                make.width.mas_equalTo(width);
                make.top.mas_equalTo(label.mas_bottom).offset(25*m6Scale);
            }];
        }else{
            [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(label.mas_left);
                make.width.mas_equalTo(width);
                make.top.mas_equalTo(label.mas_bottom).offset(25*m6Scale);
            }];
        }
    }
}
/**
 *累计收益标签
 */
- (UILabel *)incomeLabel{
    if(!_incomeLabel){
        _incomeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:46 andText:@"2000.00" addSubView:self.view];
        _incomeLabel.textColor = UIColorFromRGB(0x393939);
        _incomeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _incomeLabel;
}
/**
 *锁定本金标签
 */
- (UILabel *)amountLabel{
    if(!_amountLabel){
        _amountLabel = [Factory CreateLabelWithTextColor:1 andTextFont:46 andText:@"200.00" addSubView:self.view];
        _amountLabel.textColor = UIColorFromRGB(0x393939);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _amountLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [Factory hidentabar];
}

@end
