//
//  InviteFriendVC.m
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InviteFriendVC.h"
#import "FriendHeaderCell.h"
#import "CodeView.h"
#import "UIImage+JGQRCode.h"
#import "AlertView.h"
#import "InviteFriendModel.h"
#import "AwardAndInviteVC.h"
#import "InviteFriedsDetailsVC.h"
#import "InviteRecordView.h"
#import "InviteRecordCell.h"
#import "InviteFriendModel.h"

@interface InviteFriendVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *numLabe;//邀请码
@property (nonatomic, strong) UIButton *cpyBtn;//复制按钮
@property (nonatomic, strong) UIImageView *imageview;//二维码图片
@property (nonatomic, strong) UIButton *inviteBtn;//邀请好友按钮
@property (nonatomic, strong) CodeView *codeview;//二维码
@property (nonatomic, strong) UIImage *imgName;//二维码
@property (nonatomic, strong) NSString *coupn;//新手红包
@property (nonatomic, strong) NSString *expGold;//体验金
@property (nonatomic, strong) InviteRecordView *inviteRecordView;

/**
 邀请人数
 */
@property (nonatomic, strong) UILabel *numLabel;
/**
 红包奖励
 */
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UILabel *accountLabel;//佣金奖励
@property (nonatomic, strong) UILabel *inviteLabel;//邀请奖励
@property (nonatomic, strong) UILabel *titleLabel;//弹出视图标题标签
@property (nonatomic, strong) UIView *awardView;//邀请奖励View
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) NSArray *dataSource;//邀请记录数据
@property (nonatomic, strong) InviteFriendModel *inviteFriendModel;

@property (nonatomic,strong) NSMutableArray *dataArr;//模型数组
@property (nonatomic,strong) NSMutableDictionary *dataDic;//模型字典
@property (nonatomic,strong) UIImageView *backImgView;//暂无数据背景图片
@property (nonatomic,assign) NSInteger page;//计算刷新的页数
@property (nonatomic,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic,strong) NSMutableArray *muArray;//上拉加载的数组
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, copy) NSString *appointTime;//预约时间

@end

@implementation InviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:@"邀请好友"];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self WithImgName:@"Back-Arrow"];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = Colorful(247, 194, 70);
    _viewWidth = 670*m6Scale;
    
    //弹出视图标题标签
    _titleLabel = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.4 alpha:1] andTextFont:30 andText:@"已邀请0位好友，共获得0元现金奖励。" addSubView:self.view];
    [Factory ChangeColorStringArray:@[@"0", @"0"] andLabel:_titleLabel andColor:buttonColor];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0*m6Scale);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    //邀请奖励View
    self.awardView.frame = CGRectMake((kScreenWidth-_viewWidth)/2, 240*m6Scale, _viewWidth, 290*m6Scale);
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10*m6Scale,10*m6Scale)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.awardView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.awardView.layer.mask = maskLayer1;
    //创建标题
    [self createTitleView];
    //绘制分割线
    [self drawSplitLine];
    //加载tableView
    [self tableView];
    //请求数据
    [self reciveData];
}
/**
 *  邀请好友RecordView
 */
- (InviteRecordView *)inviteRecordView{
    if(!_inviteRecordView){
        _inviteRecordView = [[InviteRecordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight)];
    }
    return _inviteRecordView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 请求数据
 */
- (void)reciveData{
    //邀请人列表
    [DownLoadData postGetInviteInfoLists:^(id obj, NSError *error) {
        self.dataSource = obj[@"SUCCESS"];
        
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    
    //邀请好友首页
    [DownLoadData postInviteFriendByUserId:^(id obj, NSError *error) {
        _inviteFriendModel = [[InviteFriendModel alloc] initWithDictionary:obj];
        //邀请人数
        _numLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.invitePersons.intValue];
        //获得 奖励
        _redLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.inviteRewards.intValue];
        //佣金奖励
        _accountLabel.text = [NSString stringWithFormat:@"%.2f", _inviteFriendModel.inviteInvestAmount.doubleValue];
        //邀请奖励
        _inviteLabel.text = [NSString stringWithFormat:@"%d", _inviteFriendModel.invitePersonReward.intValue];
        //用户邀请总共获得的金额
        NSString *total = [NSString stringWithFormat:@"%.2f", _inviteFriendModel.inviteInvestAmount.doubleValue+_inviteFriendModel.invitePersonReward.doubleValue];
        _titleLabel.text = [NSString stringWithFormat:@"已邀请%@位好友，共获得%@元现金奖励。", _numLabel.text, total];
        [Factory ChangeColorStringArray:@[_numLabel.text, total] andLabel:_titleLabel andColor:buttonColor];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  创建标题
 */
- (void)createTitleView{
    //奖励标题View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 170*m6Scale, _viewWidth, 70*m6Scale)];
    titleView.backgroundColor = Colorful(252, 90, 69);
    [self.view addSubview:titleView];
    //画曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30*m6Scale,30*m6Scale)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    //图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteFried_明细"]];
    [titleView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(210*m6Scale);
        make.size.mas_equalTo(CGSizeMake(40*m6Scale, 37*m6Scale));
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    //邀请奖励明细标题
    UILabel *awardLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:30 andText:@"邀请奖励明细" addSubView:titleView];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(15*m6Scale);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
}
/**
 *  绘制分割线
 */
- (void)drawSplitLine{
    
    NSArray *array = @[@"邀请人数(人)", @"红包奖励(元)", @"佣金奖励(元)", @"邀请奖励(元)"];
    //横线
    UIView *horizontal = [[UIView alloc] init];
    horizontal.backgroundColor = LineColor;
    [self.awardView addSubview:horizontal];
    [horizontal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45*m6Scale);
        make.right.mas_equalTo(-45*m6Scale);
        make.centerY.mas_equalTo(self.awardView.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    //竖线
    UIView *vertical = [[UIView alloc] init];
    vertical.backgroundColor = LineColor;
    [self.awardView addSubview:vertical];
    [vertical mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25*m6Scale);
        make.bottom.mas_equalTo(-25*m6Scale);
        make.centerX.mas_equalTo(self.awardView.mas_centerX);
        make.width.mas_equalTo(1);
    }];
    
    CGFloat width = self.awardView.frame.size.width/2;
    CGFloat height = self.awardView.frame.size.height/2;
    //邀请人数
    _numLabel = [self getLabel];
    //红包奖励
    _redLabel = [self getLabel];
    //佣金奖励
    _accountLabel = [self getLabel];
    //邀请奖励
    _inviteLabel = [self getLabel];
    
    NSArray *labelArr =@[_numLabel, _redLabel, _accountLabel, _inviteLabel];
    
    for (int i = 0; i < array.count; i++) {
        
        UILabel *label = [Factory CreateLabelWithColor:[UIColor colorWithWhite:0.3 alpha:0.7] andTextFont:25 andText:array[i] addSubView:self.awardView];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i/2*height+25*m6Scale);
            make.width.mas_equalTo(width);
            make.left.mas_equalTo(i%2*width);
        }];
        
        UILabel *numLabel = (UILabel *)labelArr[i];
        
        [self layoutLabel:numLabel andOrder:i topLabel:label];
    }
}
/**
 * 约束标签
 */
- (void)layoutLabel:(UILabel *)label andOrder:(int)order topLabel:(UILabel *)topLabel{
    CGFloat width = self.awardView.frame.size.width/2;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLabel.mas_bottom).offset(25*m6Scale);
        make.width.mas_equalTo(width);
        make.left.mas_equalTo(order%2*width);
    }];
    
}

- (UILabel *)getLabel{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = Colorful(252, 90, 69);
    label.text = @"0";
    [self.awardView addSubview:label];
    
    return label;
}
/**
 *  邀请奖励View
 */
- (UIView *)awardView{
    if(!_awardView){
        _awardView = [[UIView alloc] init];
        _awardView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_awardView];
    }
    return _awardView;
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        
        //我的邀请记录标题View
        [self initInviteRecordView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 620*m6Scale, _viewWidth, 350*m6Scale)];
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
/**
 * 我的邀请记录标题View
 */
- (void)initInviteRecordView{
    //我的邀请记录标题View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth-_viewWidth)/2, 550*m6Scale, _viewWidth, 70*m6Scale)];
    titleView.backgroundColor = Colorful(252, 90, 69);
    [self.view addSubview:titleView];
    //画曲线
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.awardView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(30*m6Scale,30*m6Scale)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = titleView.bounds;
    maskLayer.path = maskPath.CGPath;
    titleView.layer.mask = maskLayer;
    //图标
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inviteFried_拷贝"]];
    [titleView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(210*m6Scale);
        make.size.mas_equalTo(CGSizeMake(38*m6Scale, 38*m6Scale));
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
    //邀请记录标题
    UILabel *awardLabel = [Factory CreateLabelWithColor:[UIColor whiteColor] andTextFont:30 andText:@"我的邀请记录" addSubView:titleView];
    [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(15*m6Scale);
        make.centerY.mas_equalTo(titleView.mas_centerY);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.dataSource.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = @"InviteRecordCell";
    
    InviteRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell) {
        cell = [[InviteRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    if (self.dataSource.count && indexPath.row) {
        [cell cellForModel:self.dataSource[indexPath.row-1]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*m6Scale;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [Factory hidentabar];//隐藏tabar
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = navigationYellowColor;
    //navigationBar延展性并设置透明
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    //隐藏导航栏的分割线
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];

    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [Factory navgation:self];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    //请求数据
//    [self pullDown];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];     self.navigationController.navigationBar.barTintColor = navigationColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}


@end
