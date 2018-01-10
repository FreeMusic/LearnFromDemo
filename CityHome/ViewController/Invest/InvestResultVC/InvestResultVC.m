//
//  InvestResultVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InvestResultVC.h"
#import "MyBillRecordVC.h"
#import "ActivityCenterVC.h"
#import "UIButton+WebCache.h"
#import "IphoneVC.h"
#import "IntegralShopVC.h"
#import "VipVC.h"
#import "InvestResultView.h"

@interface InvestResultVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *result;//投资状态
@property (nonatomic, strong) NSString *text;//标注 投资状态 或者 失败原因
@property (nonatomic, strong) NSString *investId;//投资Id  方便能够跳转到投资详情界面
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString *is_picture;//校验广告图是否显示
@property (nonatomic, strong) InvestResultView *resultView;//弹屏View

@end

@implementation InvestResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"投资"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    self.view.backgroundColor = backGroundColor;
    
    [self.view addSubview:self.tableView];
    //请求数据
    [self serviceData];
}
/**
 *懒加载talbeView
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 362*m6Scale, kScreenWidth, 210*m6Scale)];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}
/**
 *  弹屏View
 */
- (InvestResultView *)resultView{
    if(!_resultView){
        _resultView = [[InvestResultView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self.navigationController.view addSubview:_resultView];
    }
    return _resultView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 *   请求数据
 */
- (void)serviceData{
    //成功
    [self successView];
    self.result = @"投资成功";
    self.text = @"投资状态";
    self.amount = [NSString stringWithFormat:@"%.2f元", self.amount.floatValue];
    [self.tableView reloadData];
    [DownLoadData postInvestEndPic:^(id obj, NSError *error) {

        self.is_picture = obj[@"is_picture"];

        self.isFirst = obj[@"isFirst"];

        self.dataDic = obj[@"picture"];
        //是弹屏
        if (self.is_picture.integerValue == 0) {

            if (self.isFirst.integerValue == 0) {

            }else{
                self.resultView.hidden = NO;
            }
        }
        [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"picturePath"]]] forState:UIControlStateNormal];
        [self.iconButton addTarget:self action:@selector(loveActivity) forControlEvents:UIControlEventTouchUpInside];
    } investId:self.orderId];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = NO;
    NSString *text = [NSString stringWithFormat:@"%@", self.text];
    NSString *result = [NSString stringWithFormat:@"%@", self.result];
    NSString *amount = [NSString stringWithFormat:@"%@", self.amount];
    NSArray *textArr = @[@"投资金额", text];
    NSArray *detaiArr = @[amount, result];
    cell.textLabel.textColor = UIColorFromRGB(0x393939);
    cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
    cell.textLabel.text = textArr[indexPath.row];
    
    cell.detailTextLabel.textColor = UIColorFromRGB(0x393939);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    cell.detailTextLabel.text = detaiArr[indexPath.row];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105*m6Scale;
}
/**
 *成功显示的页面
 */
- (void)successView{
    [self ImageName:@"chengong" Title:@"投资成功" andBottomTitle:@"查看详情"];
}
/**
 *失败现实的页面
 */
- (void)failtView{
    [self ImageName:@"shibai" Title:@"投资失败" andBottomTitle:@"继续投资"];
}
/**
 *状态图标以及文字的显示
 */
- (void)ImageName:(NSString *)imgName Title:(NSString *)title andBottomTitle:(NSString *)string{
    //图标
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:imgName];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(86*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(110*m6Scale, 110*m6Scale));
    }];
    //标题
    UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:38 andText:title addSubView:self.view];
    label.textColor = UIColorFromRGB(0x393939);
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(40*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    //最下方空白View
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(100*m6Scale);
    }];
    //最下方按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    [btn setTitle:string forState:0];
    [btn setTitleColor:UIColorFromRGB(0xFF5933) forState:0];
    if ([string isEqualToString:@"查看详情"]) {
        btn.tag = 200;
    }else{
        btn.tag = 300;
    }
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(backView.mas_centerX);
        make.centerY.mas_equalTo(backView.mas_centerY);
    }];
    
    self.iconButton = [UIButton buttonWithType:0];
    self.iconButton.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.iconButton];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(btn.mas_top).offset(-40*m6Scale);
        make.size.mas_equalTo(CGSizeMake(699*m6Scale, 496*m6Scale));
    }];
    
}
- (void)loveActivity{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.urlName = self.dataDic[@"pictureName"];
    tempVC.strUrl = self.dataDic[@"pictureUrl"];
    if ([self.dataDic[@"pictureName"] containsString:@"锁投有礼"]) {
        //锁投有礼
        IphoneVC *tempVC = [IphoneVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }else if([self.dataDic[@"pictureName"] containsString:@"积分商城"]){
        //兑吧免登陆接口
        [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
            IntegralShopVC *temVC = [IntegralShopVC new];
            temVC.strUrl = obj[@"ret"];
            [self.navigationController pushViewController:temVC animated:YES];
        } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
    }else if ([self.dataDic[@"pictureName"] containsString:@"会员中心"]){
        VipVC *temVC = [VipVC new];
        [self.navigationController pushViewController:temVC animated:YES];
    }else if (self.dataDic[@"pictureName"] == nil && [self.dataDic[@"pictureName"] isEqualToString:@"(null)"]){
        
    }else{
        tempVC.tag = 101;
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
/**
 *按钮的点击事件
 */
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == 200) {
        //查看详情（跳转到我的账单详情页）
        MyBillRecordVC *tempVC = [MyBillRecordVC new];
        tempVC.investID = self.orderId;//ID
        tempVC.section = 2;//投资记录
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        //继续理财
        [self onClickLeftItem];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.resultView.hidden = YES;
    
}

@end
