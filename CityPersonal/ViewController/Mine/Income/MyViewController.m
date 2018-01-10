//
//  MyViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "MyViewController.h"
#import "BalanceCell.h"
#import "SecondCell.h"
#import "MessageVC.h"
#import "HeaderCell.h"
#import "TopUpVC.h"
#import "BindCradVC.h"
#import "WithdrawalVC.h"
#import "InviteFriendVC.h"
#import "MyBillVC.h"
#import "ActivityVC.h"
#import "ActivityCenterVC.h"
#import "AccountSettingViewController.h"
#import "MyBackView.h"
#import "VipVC.h"
#import "LeveyTabBarController.h"
#import "MoneyPlanVC.h"
#import "AccountCheckVC.h"
#import "RiskPushView.h"
#import "ScanIdentityVC.h"
#import "BidCardFirstVC.h"
#import "OpenAlertView.h"
#import "DealPswVC.h"
#import "NewSignVC.h"
#import "MywelfareVC.h"
#import "AuthenticationVC.h"
#import "FinalDecisionVC.h"

@interface MyViewController ()<FactoryDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) MBProgressHUD *hud;//网络加载
@property (nonatomic, strong) Reachability *conn;//网络监听
@property (nonatomic, copy) NSString *cashAccountStr;//可用余额
@property (nonatomic, copy) NSString *totalStr;//总资产
@property (nonatomic, assign) NSInteger tag;//充值提现按钮的类型区分
@property (nonatomic, strong) SXYButton *leftButton;//左边VIP
@property (nonatomic, copy) NSString *totalIncome;//累计收益
@property (nonatomic, copy) NSString *collectedIncome;//待收金额
@property (nonatomic, strong) MyBackView *backView;//用户没有登录的时候一层蒙版
@property (nonatomic, copy) NSString *phoneNum;//手机号
@property (nonatomic, strong) UILabel *phonelab;//客服
@property (nonatomic, strong) NSString *messageCount;//标记未读消息数量
@property (nonatomic, strong) SXYButton *messBtn;//消息按钮
@property (nonatomic, strong) NSString *riskType;//风险评估类型，如果为null则未测试
@property (nonatomic, strong) UILabel *userLabel;//假如用户未登录显示欢迎登陆（已登录显示手机号）
@property (nonatomic, strong) UIImageView *imgView;//
@property (nonatomic, strong) RiskPushView *riskPushView;//风险评估弹屏
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *sumLabel;//总金额
@property (nonatomic, strong) UILabel *titleClipLabel;//总资产
@property (nonatomic, strong) UILabel *collectedLabel;//待收金额
@property (nonatomic, strong) UILabel *collectedtitle;
@property (nonatomic, strong) UILabel *totalIncomeLabel;//累计收益
@property (nonatomic, strong) UILabel *totaltitlelab;
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) SXYButton *leftBtn;//会员按钮
@property (nonatomic, strong) BalanceCell *cell;
@property (nonatomic, strong) OpenAlertView * openAlert;
@property (nonatomic, strong) OpenAlertView * setPswAlter;
@property (nonatomic, assign) NSInteger total;//可用福利

@property (nonatomic, assign) NSInteger coupon;//未用红包数量
@property (nonatomic, assign) NSInteger ticket;//未用卡券数量
@property (nonatomic, assign) NSInteger experienceGold;//未用体验金数量

@end


@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    //添加数据请求失败的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zyynoti) name:@"ZyyQuitLogin" object:nil];
    self.totalStr = @"正在数钱中";
    self.totalIncome = @"正在数钱中";
    self.collectedIncome = @"正在数钱中";
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //接受隐藏登录注册蒙版的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HiddenBackView) name:@"HiddenBackView" object:nil];
    //在风险评估页面中，如果用户点击前去投资按钮，则需要跳转到首页中去
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToHome) name:@"GoToHome" object:nil];
    //跳转投资页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GoToInvest:) name:@"GoToInvest" object:nil];
    //用户在绑定银行卡之后，接受预提示用户风险评估的消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alterUserRiskTest) name:@"alterUserRiskTest" object:nil];
    //用户在实名成功之后，需要给用户一个提示框去做风险评估
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RiskViewPush) name:@"sxyRealName" object:nil];
    //用户在注册成功之后，自动登录，此刻需要在个人中心页面提示用户去实名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameInformtion) name:@"realNameView" object:nil];
    //用户在登录成功之后，判断用户是否已经实名
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameInformtion) name:@"loginRealNameView" object:nil];
    //通知 让设置交易密码弹框 消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyPushviewDismiss:) name:@"sxyPushviewDismiss" object:nil];
}
/**
 导航上的按钮
 */
- (void)typeBtn{
    //左边按钮
    //_leftButton = [Factory addLeftbottonWithCeHuaToVC:self andImageName:@"消息@2x (3)"];//左边的按钮
    _leftBtn = [SXYButton buttonWithType:0];
    [_leftBtn setImage:[UIImage imageNamed:@"V0_logo"] forState:0];
    [_leftBtn addTarget:self action:@selector(goVipVC) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_leftBtn];
    
    _userLabel = [Factory CreateLabelWithTextColor:1 andTextFont:33 andText:@"您好,欢迎登录" addSubView:_navigationView];
    
    //为导航栏添加右侧按钮2
    _messBtn = [SXYButton buttonWithType:0];
    [_messBtn setImage:[UIImage imageNamed:@"消息@2x (2)"] forState:0];
    [_messBtn setImage:[UIImage imageNamed:@"消息@2x (1)"] forState:UIControlStateSelected];
    [_messBtn addTarget:self action:@selector(rightBtn1) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigationView addSubview:_messBtn];
    //为导航栏添加右侧按钮1
    UIButton *right = [UIButton buttonWithType:0];
    [right setImage:[UIImage imageNamed:@"消息"] forState:0];
    [right addTarget:self action:@selector(rightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:right];
    
    
    if (kStatusBarHeight > 20) {
        
        _leftBtn.frame = CGRectMake(20*m6Scale, 65*m6Scale, 70*m6Scale, 70*m6Scale);
        _messBtn.frame = CGRectMake(kScreenWidth-80*m6Scale, 70*m6Scale, 70*m6Scale, 70*m6Scale);
        [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_right).offset(5*m6Scale);
            make.top.mas_equalTo(_leftBtn.mas_top).offset(18*m6Scale);
        }];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70*m6Scale, 70*m6Scale));
            make.right.mas_equalTo(_messBtn.mas_left).offset(-5*m6Scale);
            make.top.mas_equalTo(70*m6Scale);
        }];
    }else{
        
        
         _leftBtn.frame = CGRectMake(20*m6Scale, 45*m6Scale, 70*m6Scale, 70*m6Scale);
        _messBtn.frame = CGRectMake(kScreenWidth-80*m6Scale, 50*m6Scale, 70*m6Scale, 70*m6Scale);
        [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftBtn.mas_right).offset(5*m6Scale);
            make.top.mas_equalTo(_leftBtn.mas_top).offset(18*m6Scale);
        }];
        [right mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70*m6Scale, 70*m6Scale));
            make.right.mas_equalTo(_messBtn.mas_left).offset(-5*m6Scale);
            make.top.mas_equalTo(50*m6Scale);
        }];
    }
}
/**
 *
 */
- (UIImageView *)imgView{
    if(!_imgView){
        _imgView = [Factory getPersonHeaderView];
        [self.navigationController.view addSubview:_imgView];
    }
    return _imgView;
}
/**
 *风险评估弹屏
 */
- (RiskPushView *)riskPushView{
    if(!_riskPushView){
        _riskPushView = [[RiskPushView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_riskPushView];
    }
    return _riskPushView;
}
/**
 *  判断是否已经登录
 */
- (void)JudgeLogin{
    if ([HCJFNSUser objectForKey:@"userId"]) {
        _backView.hidden = YES;
        self.imgView.hidden = YES;
        self.phonelab.hidden = NO;
    }else{
        //用户没有登录会有蒙版弹窗
        if (!_backView) {
            _backView = [[MyBackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight)];
        }
        if (_userLabel) {
            _userLabel.text = @"您好，欢迎登录";
        }
        //用户未登录 获取福利弹屏
        [self UnLoginGetPushView];
        _backView.hidden = NO;
        self.imgView.hidden = NO;
        self.phonelab.hidden = YES;
        [self.navigationController.view addSubview:_backView];
    }
}
- (UILabel *)phonelab{
    if(!_phonelab){
        _phonelab = [UILabel new];
    }
    return _phonelab;
}
/**
 当有网状态下请求数据
 */
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-90*m6Scale) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
        
        _tableView.contentInset = UIEdgeInsetsMake(44-NavigationBarHeight, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return 1;
    }
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = HCJF;
    if (indexPath.section == 0) {
        _cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!_cell) {
            _cell = [[BalanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [_cell.topUpBtn addTarget:self action:@selector(topUpBtn) forControlEvents:UIControlEventTouchUpInside];//充值
        [_cell.withdrawalBtn addTarget:self action:@selector(withdrawalBtn) forControlEvents:UIControlEventTouchUpInside];//提现
        if (_cashAccountStr == nil) {
            _cell.balanceLab.text = [NSString stringWithFormat:@"可用余额: 正在数钱中"];
        }else{
            _cell.balanceLab.text = [NSString stringWithFormat:@"可用余额:  %@",[Factory countNumAndChange:_cashAccountStr]];
        }
        
        return _cell;
    }else if (indexPath.section == 1){
        SecondCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[SecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell addWelfToPoint:self.total];
        
        cell.coupon = self.coupon;
        
        cell.ticket = self.ticket;
        
        cell.experienceGold = self.experienceGold;
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        NSArray *array = @[@"我的账单",@"邀请好友 ",@"风险评估", @"锁投加息"];
        cell.textLabel.text = array[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:array[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        if (indexPath.row == 2) {
            //风险评估类型
            cell.detailTextLabel.text = self.riskType;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:24*m6Scale];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }else{
        if (_navigationView == nil) {
            _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
            _navigationView.backgroundColor = navigationYellowColor;
            [self typeBtn];//导航上的按钮
            [self.headerView addSubview:_navigationView];
        }
        
        return self.headerView;
    }
}
/**
 *tableView的headerView
 */
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] init];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, kScreenWidth, 400*m6Scale)];
        imageview.image = [UIImage imageNamed:@"我的头部背景"];
        [_headerView addSubview:imageview];
        //总金额
        _sumLabel = [self commontLab:80];
        _sumLabel.text = @"正在数钱中";
        [imageview addSubview:_sumLabel];
        [_sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.top.mas_equalTo(40*m6Scale);
        }];
        //总资产(元)
        _titleClipLabel = [Factory myTypeLab:@"总资产(元)"];
        _titleClipLabel.frame = CGRectMake(0, 120*m6Scale+NavigationBarHeight, kScreenWidth, 70*m6Scale);
        [_headerView addSubview:_titleClipLabel];
        //待收金额
        _collectedLabel = [self commontLab:40];
        _collectedLabel.text = @"正在数钱中";
        [_headerView addSubview:_collectedLabel];
        [_collectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left);
            make.bottom.equalTo(_headerView.mas_bottom).offset(-80*m6Scale);
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
        _collectedtitle = [Factory myTypeLab:@"待收金额"];
        [_headerView addSubview:_collectedtitle];
        [_collectedtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView.mas_left);
            make.top.equalTo(_collectedLabel.mas_bottom).offset(10*m6Scale);
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
        //累计收益
        _totalIncomeLabel = [self commontLab:40];
        _totalIncomeLabel.text = @"正在数钱中";
        [_headerView addSubview:_totalIncomeLabel];
        [_totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView.mas_right);
            make.bottom.equalTo(_headerView.mas_bottom).offset(-80*m6Scale);
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
        _totaltitlelab = [Factory myTypeLab:@"累计收益"];
        [_headerView addSubview:_totaltitlelab];
        [_totaltitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView.mas_right);
            make.top.equalTo(_totalIncomeLabel.mas_bottom).offset(10*m6Scale);
            make.width.mas_equalTo(kScreenWidth / 2);
        }];
    }
    return _headerView;
}
/**
 共有属性label
 */
- (UILabel *)commontLab:(CGFloat)floatlab{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:floatlab*m6Scale];
    label.textColor = TitleViewBackgroundColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 21*m6Scale;
    }else{
        return NavigationBarHeight+400*m6Scale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [UIView new];
        //文字
        UILabel *safeLab = [UILabel new];
        safeLab.text = @"浙江民泰商业银行存管保护资金安全";
        safeLab.textColor = [UIColor lightGrayColor];
        safeLab.font = [UIFont systemFontOfSize:30*m6Scale];
        [footerView addSubview:safeLab];
        [safeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footerView.mas_centerX);
            make.bottom.equalTo(footerView.mas_bottom).offset(-20*m6Scale);
        }];
        //盾牌
        UIImageView *safeImage = [[UIImageView alloc]init];
        safeImage.image = [UIImage imageNamed:@"anquan@2x(1)"];
        [footerView addSubview:safeImage];
        [safeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(safeLab.mas_left).offset(-10*m6Scale);
            make.bottom.equalTo(footerView.mas_bottom).offset(-23*m6Scale);
            make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
        }];
        
        return footerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100*m6Scale;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 200*m6Scale*3;
    }else if(indexPath.section == 0){
        //        if (indexPath.row == 0) {
        //            return 400*m6Scale;
        //        }else{
        return 120*m6Scale;
        //        }
    }else{
        return 90*m6Scale;
    }
}
/**
 跳转到VIP界面
 */
- (void)goVipVC{
    VipVC *vipVC = [VipVC new];
    [self.navigationController pushViewController:vipVC animated:YES];
}
/**
 客户电话
 */
- (void)resgister{
    //呼叫客服
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *str = @"tel://400-0571-909";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 设置
 */
- (void)rightBtn:(UIButton *)sender{
    AccountSettingViewController *accountVC = [[AccountSettingViewController alloc] init];
    accountVC.phoneNum = _phoneNum;
    [self.navigationController pushViewController:accountVC animated:YES];
}
/**
 信息中心
 */
- (void)rightBtn1{
    MessageVC *message = [MessageVC new];
    
    [self.navigationController pushViewController:message animated:YES];
}
/**
 充值
 */
- (void)topUpBtn{
    _tag = 104;
    [self loadBankMessage];//判断是否绑卡
}
/**
 提现
 */
- (void)withdrawalBtn{
    _tag = 105;
    [self loadBankMessage];//判断是否绑卡
}

/**
 数据请求失败，重新登录
 */
- (void)zyynoti{
    
    NSUserDefaults *user = HCJFNSUser;
    //存储到本地的数据在退出登录的时候删除掉
    NSArray *array = @[@"result",@"userId",@"switchGesture",@"userIcon",@"gesturePassword",@"fingerSwitch",@"gestureLock",@"userToken",@"bidBankCard"];
    UserDefaults(@"fail", @"sxyRealName")
    for (int i = 0; i < array.count; i++) {
        [user removeObjectForKey:array[i]];
        [user synchronize];
    }
    //退出登录，需要注销网易七鱼
    [[QYSDK sharedSDK] logout:^{
        NewSignVC *signVC = [[NewSignVC alloc] init];
        signVC.presentTag = @"1";
        [self presentViewController:signVC animated:YES completion:nil];
    }];
}
/**
 *  后台数据（查看昨日收益和累计收益）
 */
- (void)serverData{
    if ([HCJFNSUser stringForKey:@"userId"]) {
        //收益
        [DownLoadData postIncome:^(id obj, NSError *error) {
            if ([obj[@"result"] isEqualToString:@"fail"] && [obj[@"messageCode"] isEqualToString:@"sys.error"]) {
                if ([HCJFNSUser stringForKey:@"userId"]) {
                    [Factory alertMes:obj[@"messageText"]];
                }
            } else {
                //标记未读消息数量
                self.messageCount = [NSString stringWithFormat:@"%@", obj[@"messageCount"]];
                //风险评估类型，如果为null则未测试
                //NSString *risk = [NSString stringWithFormat:@"%@", obj[@"riskType"]];
                //风险评估类型
                //[self RiskTypeWithType:risk];
                //将用用户名称存到本地  方便充值和体现记录中用到
                UserDefaults(obj[@"userName"], @"userName");
                //用户登录成功之后，未实名显示手机号 实名显示昵称
                _userLabel.text = [NSString stringWithFormat:@"%@, 您好", obj[@"userName"]];
                NSString *memerGrade = obj[@"memberGrade"];
                [_leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"V%ld_logo", memerGrade.integerValue]] forState:0];
                if (self.messageCount.integerValue) {
                    _messBtn.selected = YES;
                }else{
                    _messBtn.selected = NO;
                }
                NSString *totalStr = obj[@"accountTotal"];
                _totalStr = [NSString stringWithFormat:@"%.2f", totalStr.doubleValue];//总资产
                NSString *collectedIncome = obj[@"accountWait"];
                _collectedIncome = [NSString stringWithFormat:@"%.2f", collectedIncome.doubleValue];//待收
                NSString *totalIncome = obj[@"income"];
                _totalIncome = [NSString stringWithFormat:@"%.2f", totalIncome.doubleValue];//累计
                NSString *cashAccountStr = obj[@"accountUsable"];
                _cashAccountStr = [NSString stringWithFormat:@"%.2f", cashAccountStr.doubleValue];//可用
                [defaults setValue:_totalStr forKey:@"totalAccount"];//总资产
                [defaults setValue:_cashAccountStr forKey:@"accountUsable"];//可用
                [defaults setValue:_collectedIncome forKey:@"collectedIncome"];//待收
                
                self.sumLabel.text = [Factory countNumAndChange:_totalStr];
                self.collectedLabel.text = [Factory countNumAndChange:_collectedIncome];//待收金额
                self.totalIncomeLabel.text = [Factory countNumAndChange:_totalIncome];//累计收益
                
                _cell.balanceLab.text = [NSString stringWithFormat:@"可用余额:  %@",[Factory countNumAndChange:_cashAccountStr]];
                
                [self.tableView.mj_header endRefreshing];
            }
        } userId:[HCJFNSUser objectForKey:@"userId"]];
        
        //查看用户是否可有可用福利
        [DownLoadData postHasCanUseReward:^(id obj, NSError *error) {
            
            NSString *total = obj[@"ret"][@"total"];
            
            self.total = total.integerValue;
            
            NSString *coupon = obj[@"ret"][@"coupon"];
                                           
            self.coupon = coupon.integerValue;
            
            NSString *ticket = obj[@"ret"][@"ticket"];
            
            self.ticket = ticket.integerValue;
            
            NSString *experienceGold = obj[@"ret"][@"experienceGold"];
            
            self.experienceGold = experienceGold.integerValue;
            
            [self.tableView reloadData];
            
        } userId:[HCJFNSUser objectForKey:@"userId"]];
        
        //用户实时获取版本号
        [DownLoadData postUpdateVersion:^(id obj, NSError *error) {
            
        }];
    }else{
        
    }
}
/**
 *风险评估类型(1.保守型 2.稳健型 3.积极型 为null则未设置)
 */
- (void)RiskTypeWithType:(NSString *)type{
    switch (type.integerValue) {
        case 0:
            self.riskType = @"未设置";
            break;
        case 1:
            self.riskType = @"保守型";
            break;
        case 2:
            self.riskType = @"稳健型";
            break;
        case 3:
            self.riskType = @"积极型";
            break;
            
        default:
            break;
    }
}
/**
 *查询用户是否实名
 */
- (void)realNameInformtion{
    //实名前查询老用户实名信息
    [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
        //首先根据realnameStatus该字段判断用户是否实名过
        NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
        //真实姓名
        NSString *realname = [NSString stringWithFormat:@"%@", obj[@"realname"]];
        //身份证号
        NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
        if (status.integerValue) {
            UserDefaults(@"success", @"sxyRealName");
        }
        
        if (status.integerValue == 0) {
            //用户没有实名弹窗
            [self alertActionWithUserName:realname identifyCard:identifyCard status:status];
        }else{
            //用户已经实名   判断用户是否设置交易密码
            [DownLoadData postCheckTradingPs:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    NSString *password = [NSString stringWithFormat:@"%@", obj[@"password"]];
                    if (password.integerValue) {
                        //用户已设置交易密码
                    }else{
                        //用户没有设置交易密码
                        [self alterUserSetPassword];
                    }
                }else{
                    [Factory alertMes:obj[@"messageText"]];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *   用户绑定银行卡信息
 */
- (void)loadBankMessage {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //实名前查询老用户实名信息
    [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
        NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
        //首先根据realnameStatus该字段判断用户是否实名过
        NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
        if (status.integerValue) {
            //用户实名过  判断他是否绑过卡
            [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                NSString *result = obj[@"result"];
                if ([result isEqualToString:@"success"]) {
                    //验证通过
                    if (_tag == 104) {
                        //充值
                        TopUpVC *topUp = [TopUpVC new];
                        topUp.userName = realName;
                        [self.navigationController pushViewController:topUp animated:YES];
                    }else if (_tag == 105){
                        //用户第一次提现的时候需要做人脸识别 校验
                        [self faceRecognitionWithName:realName];
                    }
                }else {
                    //跳转至绑定银行卡页面
                    BidCardFirstVC *tempVC = [BidCardFirstVC new];
                    tempVC.userName = realName;//用户真实姓名
                    [self.navigationController pushViewController:tempVC animated:YES];
                }
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }else{
            [hud hideAnimated:YES];
            NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
            NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
            //提示实名
            [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  用户第一次提现的时候需要做人脸识别 校验
 */
- (void)faceRecognitionWithName:(NSString *)userName{
    //人脸识别
    [DownLoadData postFaceAuthent:^(id obj, NSError *error) {
        //success
        if ([obj[@"result"] isEqualToString:@"success"]) {
            NSString *bizNo = [NSString stringWithFormat:@"%@", obj[@"bizNo"]];
            //假如bizNo是空的话 说明他是老用户  直接跳转提现页面
            if ([Factory theidTypeIsNull:bizNo]) {
                //老用户
                WithdrawalVC *with = [WithdrawalVC new];
                with.userName = userName;
                [self.navigationController pushViewController:with animated:YES];
            }else{
                if (![obj[@"face"] isKindOfClass:[NSDictionary class]]) {
                    // 用户需要进行人脸识别校验
                    AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
                    tempVC.bizNo = bizNo;//人脸识别因子
                    tempVC.reviewType = NeedReview_NO;
                    [self.navigationController pushViewController:tempVC animated:YES];
                }else{
                    NSString *count = obj[@"face"][@"tryTimes"];
                    NSString *auditStatus = [NSString stringWithFormat:@"%@", obj[@"face"][@"auditStatus"]];
                    //人脸识别跳转页面判断
                    [self judgeSkipViewControllerWithTryTimes:count auditStatus:auditStatus isFaceSuccess:[NSString stringWithFormat:@"%@", obj[@"face"][@"isFaceSuccess"]] userName:userName bizNo:bizNo];
                }
            }
        }else{
            //else 未知错误 提示用户
            [Factory alertMes:obj[@"messageText"]];
        }
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *   人脸识别跳转页面判断
 */
- (void)judgeSkipViewControllerWithTryTimes:(NSString *)count auditStatus:(NSString *)auditStatus isFaceSuccess:(NSString *)isFaceSuccess userName:(NSString *)userName bizNo:(NSString *)bizNo{
    //成功  跳转提现页面
    if ([isFaceSuccess isEqualToString:@"1"]) {
        WithdrawalVC *with = [WithdrawalVC new];
        with.userName = userName;
        [self.navigationController pushViewController:with animated:YES];
    }else{
        if (auditStatus.intValue == 0 && count.intValue) {
            //人脸识别 加 人工审核 页面
            AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
            tempVC.bizNo = bizNo;//人脸识别因子
            tempVC.reviewType = NeedReview_YES;//需要人工审核
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if(auditStatus.intValue == 2){
            //审核中
            [Factory addAlertToVC:self withMessage:@"您的手持身份证照片已提交，请等待审核结果。我们会在1-2个工作日内，通知您。"];
        }else if(auditStatus.intValue == 1){
            //审核成功
            WithdrawalVC *with = [WithdrawalVC new];
            with.userName = userName;
            [self.navigationController pushViewController:with animated:YES];
        }else if (auditStatus.intValue == -1){
            //人工审核失败(跳转人工审核失败页面)
            FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
            tempVC.decision = FinalDecision_Failure;
            tempVC.bizNo = bizNo;//人脸识别因子
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if (auditStatus.intValue == 0 && count.intValue == 0){
            // 用户需要进行人脸识别校验
            AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
            tempVC.bizNo = bizNo;//人脸识别因子
            tempVC.reviewType = NeedReview_NO;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}
/**
 是否绑卡提示
 */
- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  提示用户去开户
 */
- (void)alertActionWithUserName:(NSString *)userName identifyCard:(NSString *)identifyCard status:(NSString *)status{
    self.openAlert = [[OpenAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.openAlert];
    __weak typeof(self.openAlert) openSelf = self.openAlert;
    __weak typeof(self) weakSelf = self;
    [self.openAlert setButtonAction:^(NSInteger tag) {
        [openSelf removeFromSuperview];
        if (tag == 0) {
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            tempVC.userName = userName;
            tempVC.identifyCard = identifyCard;
            tempVC.realnameStatus = status;
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }else if (tag == 2){
            
            MywelfareVC *tempVC = [MywelfareVC new];
            
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
            
        }
    }];
    
}
/**
 * 提示用户开启交易密码
 */
- (void)alterUserSetPassword{
    self.setPswAlter = [[OpenAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    self.setPswAlter.messageLabel.text = @"为了您的资金安全，请重置交易密码";
    self.setPswAlter.messageLabel.textAlignment = NSTextAlignmentCenter;
    [self.setPswAlter.openBtn setTitle:@"立即重置" forState:0];
    [[UIApplication sharedApplication].keyWindow addSubview:self.setPswAlter];
    __weak typeof(self.setPswAlter) set = self.setPswAlter;
    __weak typeof(self) weakSelf = self;
    self.setPswAlter.showPswView = YES;
    self.setPswAlter.showMyWealf = YES;
    [self.setPswAlter setButtonAction:^(NSInteger tag) {
        [set removeFromSuperview];
        if (tag == 0) {
            DealPswVC *tempVC = [DealPswVC new];
            tempVC.style = @"1";
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }
    }];
}
//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    [Factory showTabar];//显示tabar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //导航设置
    self.navigationController.navigationBar.translucent = YES;
    //隐藏导航栏的分割线
    [Factory navgation:self];
    _navigationView.hidden = NO;
    if ([HCJFNSUser stringForKey:@"userId"]) {
        [self serverData];//服务器数
    }else{
        //没有userID 要将用户的个人财产金额清除
        _cell.balanceLab.text = [NSString stringWithFormat:@"可用余额: 0"];
        self.sumLabel.text = @"正在数钱中";
        self.collectedLabel.text = @"正在数钱中";//待收金额
        self.totalIncomeLabel.text = @"正在数钱中";//累计收益
        _userLabel.text = @"您好欢迎您登陆";
        [_leftBtn setImage:[UIImage imageNamed:@"V0_logo"] forState:0];
        
    }
    //判断用户是否已经登录
    [self JudgeLogin];
}
/**
 *  用户未登录 获取福利弹屏
 */
- (void)UnLoginGetPushView{
    
    [DownLoadData postGetNoviceWelfare:^(id obj, NSError *error) {
        
        [self.backView.welfImgView sd_setImageWithURL:[NSURL URLWithString:obj[@"ret"][@"picturePath"]]];
        
    } clientId:[HCJFNSUser stringForKey:@"clientId"]];
    
}
/**
 *为了防止在加载页面的时候出现卡顿，尽量不要将一些耗时操作放在Viewdidload  和 viewWillAppear里面 。可以将耗时操作放在viewDidAppear里面。
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *在风险评估页面中，如果用户点击前去投资按钮，则需要跳转到理财中去
 */
- (void)goToHome{
    
    self.leveyTabBarController.selectedIndex = 1;
    
}

- (void)sxyPushviewDismiss:(NSNotification *)noti{
    NSString *statua = noti.userInfo[@"result"];
    if (statua.integerValue) {
        [self alterUserSetPassword];
    }else{
        
    }
}
/**
 *跳转投资页
 */
- (void)GoToInvest:(NSNotification *)notice{
    self.leveyTabBarController.selectedIndex = 1;
    NSDictionary *dic = notice.userInfo;
    if (dic&& [dic[@"selectIndex"] isEqualToString:@"3"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goToPlan" object:nil];
    }
}
/**
 *风险评估提示框
 */
- (void)RiskViewPush{
    self.riskPushView.hidden = NO;
    [self.riskPushView changeStringBytext:self.riskPushView.resultLabel.text changeStr:@"平台默认测试类型结果为"];
}
/**
 *用户在实名成功之后，需要给用户一个提示框去做风险评估
 */
- (void)alterUserRiskTest{
    NSNotification *notification = [[NSNotification alloc] initWithName:@"sxyRealName" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
//隐藏蒙版
- (void)HiddenBackView{
    //弹出登录注册界面
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
    UIViewController *vc = [navi.viewControllers firstObject];
    NewSignVC *signVC = [[NewSignVC alloc] init];
    [vc presentViewController:signVC animated:YES completion:^{
        _backView.hidden = YES;
        self.imgView.hidden = YES;
        self.phonelab.hidden = NO;
    }];
}

@end
