//
//  ItemTypeVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ItemTypeVC.h"
#import "ItemTypeFirstCell.h"
#import "ItemTypeSecondCell.h"
#import "ItemModel.h"
#import "InstantInvestViewController.h"
#import "AppDelegate.h"
#import "SXTitleLable.h"
#import "DetailsVC.h"
#import "RecordVC.h"
#import "RiskVC.h"
#import "NewSignVC.h"
#import "UIControl+Blocks.h"
#import "openShareView.h"
#import "CountdownView.h"
#import "HelpTableViewController.h"
#import "ItemDetailsModel.h"
#import "FatherVC.h"
#import "ForgetPasswordView.h"
#import "ItemPswView.h"
#import "ScanIdentityVC.h"
#import "BidCardFirstVC.h"
#import "OpenAlertView.h"
#import "MywelfareVC.h"

@interface ItemTypeVC ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ItemModel *model;//model层
@property (nonatomic, strong) NSArray *array;//年化利率、可投金额、项目期限
@property (nonatomic, assign) NSInteger *click;
@property (nonatomic ,strong) MBProgressHUD *hud;//网络加载
@property (nonatomic, strong) UIView *buyBtnBottom;//最下面的悬停View
@property (nonatomic, strong) UIButton *buyBtn;//购买按钮
@property (nonatomic, strong) Reachability *conn;//网络判断
@property (nonatomic, assign) CGFloat contentOffY;
@property (nonatomic, strong) UIScrollView *bottomScrollView;//底层的ScrollView
@property (nonatomic, strong) UINavigationBar *QYnavBar;//导航设置
@property (nonatomic, assign) BOOL isTop;//标记该页面是否滑到了顶部

/** 标题栏 */
@property (strong, nonatomic) UIScrollView *smallScrollView;
/** 下面的内容栏 */
@property (strong, nonatomic) UIScrollView *bigScrollView;
@property (nonatomic,strong) UINavigationBar *navBar;
@property (nonatomic) NSUInteger tag;
@property (nonatomic, strong) UIButton *calculatorBtn;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *backgroundClipView; //背景阴影视图
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) CountdownView *countDownView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) UIImageView * remindImg;
@property (nonatomic, strong) DetailsVC *detailVC; //webview VC
@property (nonatomic, strong) RecordVC *recordVC; //tableView VC
@property (nonatomic, strong) UIScrollView *backScrollView; //背景滑动式图
@property (nonatomic, strong) ItemDetailsModel *itemDetailsModel;
@property (nonatomic, strong) NSString *passWord;//定向标的密码
@property (nonatomic, strong) ItemPswView *itemPswView;//定向标密码输入视图
@property (nonatomic, strong) OpenAlertView * openAlert;

@end

@implementation ItemTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //在顶部
    self.isTop = YES;
    self.bigScrollView = [[UIScrollView alloc]init];
    self.smallScrollView = [[UIScrollView alloc]init];
    self.click = 0;
    _contentOffY = 0;
    self.view.backgroundColor = backGroundColor;

    _remindImg = [[UIImageView alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bottomScrollViewOffsetWithNoti:) name:@"itemScrollViewOffset" object:nil];
    [TitleLabelStyle addtitleViewToVC:self withTitle:self.itemNameText color:[UIColor whiteColor]];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self andImageName:@"项目客服"];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomScrollView];//底层的scrollView
    [self buttonView];//最下面悬停的View
    [self quitBuy];//立即购买
    [self.bottomScrollView addSubview:self.tableView];//加载tableView
    [self nSUserDefaults];//无论是否上拉都应该将itemId存入本地
    [self scrollow];
    
    [self labelExample];//HUD
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //请求数据
    [self serviceData];
}
#pragma mark -bottomScrollView
- (UIScrollView *)bottomScrollView{
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bottomScrollView.pagingEnabled = YES;
        _bottomScrollView.delegate = self;
        _bottomScrollView.bounces = NO;
        _bottomScrollView.tag = 10;
        _bottomScrollView.showsVerticalScrollIndicator = NO;
        if (kStatusBarHeight > 20) {
            _bottomScrollView.contentSize = CGSizeMake(0, (kScreenHeight)*2 - NavigationBarHeight - 120 * m6Scale);
        }else{
            _bottomScrollView.contentSize = CGSizeMake(0, (kScreenHeight)*2 - NavigationBarHeight - 100 * m6Scale);
        }
    }
    return _bottomScrollView;
}
#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64-7, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = backGroundColor;
        _tableView.dataSource = self;
        _tableView.delegate  = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 15*m6Scale;
    }
    return _tableView;
}
/**
 *项目详情的接口请求
 */
- (void)serviceData{
    //项目详情的接口请求
    [DownLoadData postItemDocuments:^(id obj, NSError *error) {
        _itemDetailsModel = obj[@"model"];
        //定向标的密码
        self.passWord = [NSString  stringWithFormat:@"%@", _itemDetailsModel.password];
        [self.tableView reloadData];
    } itemId:self.itemId];
}
- (void)bottomScrollViewOffsetWithNoti:(NSNotification *)noti {
    
    [self.bottomScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

/**
 悬停的View
 */
- (void)buttonView{
    //最底下的view
    self.buyBtnBottom = [[UIView alloc] init];
    self.buyBtnBottom.backgroundColor = [UIColor  whiteColor];
    [self.view addSubview:self.buyBtnBottom];
    [self.buyBtnBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kTabBarHeight);
    }];
}
/**
 立即购买按钮
 */
- (void)quitBuy{
    //立即投资按钮
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.layer.cornerRadius = 5;
        [_buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.buyBtnBottom addSubview:_buyBtn];
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-KSafeBarHeight);
            make.centerX.equalTo(self.buyBtnBottom.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(580*m6Scale, 80*m6Scale));
        }];
    }
    NSInteger status = _itemStatus.integerValue;
    NSLog(@"status = %ld", status);
    if (status == 0 || status == 1 || status == 2) {
        [_buyBtn setTitle:[NSString stringWithFormat:@"%@", self.dataStr] forState:UIControlStateNormal];
        _buyBtn.backgroundColor = ButtonColor;
        _buyBtn.userInteractionEnabled = NO;
    }else if (status == 18 || status == 20 || status == 23){
        [self setButtonTitle:@"已满标"];
    }else if(status == 30 || status == 31 || status == 32){
        [self setButtonTitle:@"还款中"];
    }else if(status == 10){
        [_buyBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        _buyBtn.backgroundColor = ButtonColor;
    }else if(status == 13 || status == 14){
        [self setButtonTitle:@"流标"];
    }
}
/**
 *设置立即投标按钮的颜色
 */
- (void)setButtonTitle:(NSString *)title{
    [_buyBtn setTitle:title forState:UIControlStateNormal];
    _buyBtn.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    _buyBtn.userInteractionEnabled = NO;
}
//开启定时器方法：
- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}
/**
 定时器的调用方法
 */
- (void)refreshLessTime {
    
    [self lessSecondToDay:-- self.time];
    self.countDownView.hourLabel.text = [NSString stringWithFormat:@"%@",[self.timeArr firstObject]];
    self.countDownView.minLabel.text = [NSString stringWithFormat:@"%@",self.timeArr[1]];
    self.countDownView.secLabel.text = [NSString stringWithFormat:@"%@",[self.timeArr lastObject]];
    // NSLog(@"time = %@",[NSString stringWithFormat:@"%li",time]);
    NSString *mytime = [NSString stringWithFormat:@"%li",(unsigned long)self.time];
    // NSLog(@"%d",mytime.intValue);
    if (mytime.intValue <= 0) {
        [_timer invalidate];
        
        //移除倒计时view
        [self.countDownView removeFromSuperview];
        //改变按钮状态
        [_buyBtn setTitle:@"立即投资" forState:UIControlStateNormal];
        _buyBtn.backgroundColor = ButtonColor;
        _buyBtn.userInteractionEnabled = YES;
    }
}
/**
 倒计时的时分秒
 */
- (NSMutableArray *)lessSecondToDay:(NSInteger)seconds {
    
    [self.timeArr removeAllObjects];
    
    NSInteger hours = seconds / (60*60*1000);
    NSInteger minute = seconds / (1000 * 60) - hours * 60;
    NSInteger secondss = seconds / 1000 - minute * 60 - hours * 60 * 60;
    
    NSString *clipHours = [NSString stringWithFormat:@"%.2li",(long)hours];
    NSString *clipMinute = [NSString stringWithFormat:@"%.2li",(long)minute];
    NSString *clipSecond = [NSString stringWithFormat:@"%.2li",(long)secondss];
    
    [self.timeArr addObject:clipHours];//小时
    [self.timeArr addObject:clipMinute];//分钟
    [self.timeArr addObject:clipSecond];//秒
    return self.timeArr;
}
#pragma mark - 懒加载
- (NSMutableArray *)timeArr {
    
    if (_timeArr == nil) {
        
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}
/**
 倒计时View
 */
- (CountdownView *)countDownView {
    
    if (_countDownView == nil) {
        _countDownView = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0, 580 * m6Scale, 80 * m6Scale)];
    }
    return _countDownView;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    if (self.isTop == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.bottomScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [TitleLabelStyle addtitleViewToVC:self withTitle:self.itemNameText color:[UIColor whiteColor]];
    }
}
/**
 *  客服
 */
- (void)rightBtn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([defaults objectForKey:@"userId"]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
            //用户个人信息
            [DownLoadData postUserInformation:^(id obj, NSError *error) {
                
                NSLog(@"%@-------",obj);
                
                if (obj[@"usableCouponCount"]) {
                    
                    [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
                }
                if (obj[@"usableTicketCount"]) {
                    [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];
                    
                }
                if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
                    [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
                }else{
                    [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
                }
                NSArray *array = obj[@"accountBankList"];
                if ([array count] == 0) {
                    [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
                }else{
                    
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
                    }];
                }
                [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
                [HCJFNSUser synchronize];
                [hud setHidden:YES];
                //在线客服
                QYSessionViewController *sessionViewController = [Factory jumpToQY];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                if (iOS11) {
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
                }else{
                    self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
                }
                UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
                TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
                navItem.titleView = titleLabel;
                UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
                
                left.tintColor = [UIColor blackColor];
                [self.QYnavBar pushNavigationItem:navItem animated:NO];
                [navItem setLeftBarButtonItem:left];
                //    [navItem setRightBarButtonItem:right];
                [navi.view addSubview:self.QYnavBar];
                //电池点两条
                [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
                [self presentViewController:navi animated:YES completion:nil];
            } userId:[HCJFNSUser objectForKey:@"userId"]];
    }
    else{
            [Factory alertMes:@"请先登录"];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //呼叫客服
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *str = @"tel://400-0571-909";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"帮助中心" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HelpTableViewController *help = [HelpTableViewController new];
        [self.navigationController pushViewController:help animated:YES];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark - numberOfRowsInSection
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = HCJF;
    static NSString *str1 = @"HC";
    if (indexPath.row == 0 && indexPath.section == 0) {
        ItemTypeFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!firstCell) {
            firstCell = [[ItemTypeFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [firstCell cellForModel:_itemDetailsModel];
        
        return firstCell;
        
    }else if (indexPath.row == 1 && indexPath.section == 0){
        ItemTypeSecondCell *secondCell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!secondCell) {
            secondCell = [[ItemTypeSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1];
        }
        [secondCell cellForModel:_itemDetailsModel];
        
        return secondCell;
    }
    else{
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
        if (!myCell) {
            myCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"secondCell"];
        }
        //拖动查看详情
        _remindImg.clipsToBounds = YES;
        _remindImg.image = [UIImage imageNamed:@"详情页上拉"];
        [myCell addSubview:_remindImg];
        [_remindImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(myCell.mas_centerY);
            make.centerX.equalTo(myCell.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 66 * m6Scale));
        }];
        
        return myCell;
    }
}
#pragma mark -heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 880*m6Scale;
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
        return 304*m6Scale;
    }
    else
    {
        return 66*m6Scale;
    }
}
#pragma mark -heightForFooterInSection
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -heightForHeaderInSection
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
/**
 *定向标密码输入视图
 */
- (ItemPswView *)itemPswView{
    if(!_itemPswView){
        _itemPswView = [[ItemPswView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [delegate.window addSubview:self.itemPswView];
        [_itemPswView.pswBtn addTarget:self action:@selector(judgePassWord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _itemPswView;
}

/**
 * 立即投资
 */
- (void)buyBtn:(UIButton *)sender{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:@"userId"]) {
        //用户登录 判断用户是否实名
        [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
            [hud setHidden:YES];
            //获取用户实名状态
            NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
            //用户的真实姓名
            NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
            if (realnameStatus.integerValue) {
//                //用户已经实名  校验用户是否绑卡
//                [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
//                    if ([obj[@"result"] isEqualToString:@"success"]) {
                        if ([self.passWord isEqualToString:@"(null)"] || [self.passWord isEqualToString:@" "]) {
                            InstantInvestViewController *instantVC = [[InstantInvestViewController alloc] init];
                            instantVC.titleName = self.itemNameText;
                            instantVC.userName = realName;//用户的真实姓名
                            instantVC.itemId = self.itemId;//项目ID
                            [self.navigationController pushViewController:instantVC animated:YES];
                        }else{
                            self.itemPswView.hidden = NO;
                            [self.itemPswView.textFiled becomeFirstResponder];
                        }
//                    }else{
//                        [self alertByuserName:realName];
//                    }
//                } userId:[HCJFNSUser stringForKey:@"userId"]];
                
            }else{
                //提示实名
                //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
//                [_hud hideAnimated:YES];//HUD
//                [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                }]];
//                
//                [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    ScanIdentityVC *tempVC = [ScanIdentityVC new];
//                    tempVC.userName = realName;//用户名字
//                    tempVC.identifyCard = identifyCard;//用户身份证号
//                    tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
//                    [self.navigationController pushViewController:tempVC animated:YES];
//                }]];
//                
//                [self presentViewController:alert animated:YES completion:nil];
            }
        } userId:[HCJFNSUser stringForKey:@"userId"]];
    }else {
        [hud setHidden:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"2";
            [self presentViewController:signVC animated:YES completion:nil];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/**
 *用户输入定向标密码完成后 点击确认按钮
 */
- (void)judgePassWord{
    if ([self.passWord isEqualToString:self.itemPswView.textFiled.text]) {
        self.itemPswView.hidden = YES;
        self.itemPswView.textFiled.text = @"";
        [self.itemPswView.textFiled resignFirstResponder];
        //输入成功
        InstantInvestViewController *instantVC = [[InstantInvestViewController alloc] init];
        instantVC.itemId = self.itemId;//项目ID
        [self.navigationController pushViewController:instantVC animated:YES];
    }else{
        [Factory alertMes:@"定向标密码输入错误"];
    }
}
/**
 *  项目信息存入本地
 */
- (void)nSUserDefaults{
    NSUserDefaults *user = HCJFNSUser;
    [user setValue:[NSString stringWithFormat:@"%.0f",_sumLabelText.floatValue - _itemOngoingLabelText.floatValue] forKey:@"zyyAccount"];//可投金额
    NSLog(@"ayyItemId = %@-------%@",_itemId,[NSString stringWithFormat:@"%.0f",_model.itemAccount.floatValue - _model.itemOngoingAccount.floatValue]);
    [user setValue:_itemId forKey:@"zyyItemId"];//项目ID
    [user synchronize];
}
#pragma mark - section为1的加载滚动视图
- (void)scrollow{
    
    self.bigScrollView.frame = CGRectMake(0,kScreenHeight- 100 * m6Scale-64,kScreenWidth, kScreenHeight);
    [self.bottomScrollView addSubview:self.bigScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.bigScrollView.delegate = self;
    //添加子控制器（标的详情、投资记录、风险保护）
    [self addController];
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
}
/** 添加子控制器 */
- (void)addController
{
    //默认选择的控制器
    self.detailVC = [[DetailsVC alloc]init];
    self.recordVC = [[RecordVC alloc]init];
    RiskVC *vc3 = [[RiskVC alloc]init];
    self.detailVC.title = @"标的详情";
    self.recordVC.title = @"投资记录";
    vc3.title = @"风险保护";
    vc3.itemId = self.itemId;
    //数组
    NSArray *subViewControllers = @[self.detailVC, self.recordVC, vc3];
    FatherVC *fatherVC = [[FatherVC alloc]initWithSubViewControllers:subViewControllers];
    fatherVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.bigScrollView addSubview:fatherVC.view];
    [self addChildViewController:fatherVC];
}
//开始滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _contentOffY = scrollView.contentOffset.y;
}
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
       
        if (scrollView.contentOffset.y <= 0) {
            
            
            scrollView.bounces = NO;
            
        }else {
            
            scrollView.bounces = YES;
        }
    } else {
        if (scrollView.tag != 10) {
            
//            // 取出绝对值 避免最左边往右拉时形变超过1
//            CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
//            NSUInteger leftIndex = (int)value;
//            NSUInteger rightIndex = leftIndex + 1;
//            CGFloat scaleRight = value - leftIndex;
//            CGFloat scaleLeft = 1 - scaleRight;
//            SXTitleLable *labelLeft = self.smallScrollView.subviews[leftIndex];
//            labelLeft.scale = scaleLeft;
//            
//            // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
//            if (rightIndex < self.smallScrollView.subviews.count) {
//                SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
//                labelRight.scale = scaleRight;
//            }
            
        }
        
        if (scrollView.contentOffset.x) {
//            self.navBar.alphaView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65);
//            [self.navBar setColor:[UIColor colorWithRed:254.0 / 255.0 green:162.0 / 255.0 blue:39.0/255.0 alpha:1.0]];//导航颜色
        }
        
        if (scrollView.contentOffset.y) {
            
//            self.navBar.alphaView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 65);
            
//            [self.navBar setColor:[UIColor colorWithRed:254.0 / 255.0 green:162.0 / 255.0 blue:39.0/255.0 alpha:scrollView.contentOffset.y / 64]];
            NSLog(@"scrollView.contentOffset.y = %lf,%f",scrollView.contentOffset.y, (kScreenHeight - 100 * m6Scale - 64));
            if (scrollView.contentOffset.y >= (kScreenHeight - 100 * m6Scale - 74)) {
                _remindImg.image = [UIImage imageNamed:@"详情页下拉"];
                self.detailVC.webView.scrollView.scrollEnabled = YES;
                self.recordVC.tableView.scrollEnabled = YES;
                self.isTop = NO;
                [TitleLabelStyle addtitleViewToVC:self withTitle:@"标的详情" color:[UIColor whiteColor]];
//                [self.navBar setColor:ButtonColor];
            }else if (scrollView.contentOffset.y <= (kScreenHeight - 100 * m6Scale - 64) / 2) {
                
                _remindImg.image = [UIImage imageNamed:@"详情页上拉"];
                [TitleLabelStyle addtitleViewToVC:self withTitle:self.itemNameText color:[UIColor whiteColor]];
                self.isTop = YES;
            }
        }
    }
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
 是否绑卡提示
 */
- (void)alertByuserName:(NSString *)name{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BidCardFirstVC *tempVC = [BidCardFirstVC new];
        tempVC.userName = name;
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏
    [Factory navgation:self];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationYellowColor;
//    [self.navigationController.navigationBar setColor:[UIColor colorWithWhite:1 alpha:0]];
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [user removeObjectForKey:@"zyyRedId"];
    [user synchronize];
    [user removeObjectForKey:@"zyyTicketId"];
    [user synchronize];
    
    [DownLoadData postItemRemainAccount:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        
        self.sumLabelText = obj[@"itemAccount"];
        self.itemOngoingLabelText = obj[@"itemOngoingAccount"];
        
        [self.tableView reloadData];
        
    } itemId:self.itemId];
}
//取消键盘的通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moneyTF" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"itemScrollViewOffset" object:nil];
}
//HUD加载转圈
- (void)labelExample {
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    // Set the label text.
////    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
//    // You can also adjust other label properties if needed.
//    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
//    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//        sleep(10.);
//    });
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.calculatorView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}

@end
