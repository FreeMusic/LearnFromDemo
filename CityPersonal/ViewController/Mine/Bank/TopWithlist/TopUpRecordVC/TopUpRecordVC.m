//
//  TopUpRecordVC.m
//  CityJinFu
//
//  Created by mic on 2017/6/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "TopUpRecordVC.h"
#import "QYSessionViewController.h"
#import "TopUpRecordCell.h"
#import "HelpTableViewController.h"

@interface TopUpRecordVC ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIView *bankView;//银行卡信息背景图
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic, copy) NSString *bankCode; //银行简称
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) NSString *bankInmageName;
@property (nonatomic, copy) NSString *bankNumStr; //银行卡号
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *nowDayLab;//当天
@property (nonatomic, strong) UILabel *mouthDayLab;//当月
@property (nonatomic, strong) UILabel *singleLab;//单笔
@property (nonatomic, strong) NSDictionary *dic;//充值提现进度字典
@property (nonatomic, strong) NSString *bankName;//银行卡名称

@end

@implementation TopUpRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    if (self.tag.integerValue) {
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"提现记录"];
    }else{
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"充值记录"];
    }
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self];
    [rightBtn addTarget:self action:@selector(onClickRightItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
}
/**
 银行卡图片
 */
- (UIImageView *)iconImageView {
    
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250*m6Scale+22*m6Scale, kScreenWidth, 513*m6Scale)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-450*m6Scale/3+64, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    TopUpRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TopUpRecordCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    [cell cellForIndexPath:indexPath WithTag:_tag dic:_dic];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 513*m6Scale/3;
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  右边的按钮
 */
- (void)onClickRightItem
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([defaults objectForKey:@"userId"]) {
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
        
        HelpTableViewController *achieve = [HelpTableViewController new];
        [self.navigationController pushViewController:achieve animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  用户绑定银行卡信息
 */
- (void)loadBankMessage {
    
    [self labelExample];//HUD6
    [DownLoadData postRechargeDetails:^(id obj, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
        });
        _bankInmageName = [NSString stringWithFormat:@"%@",obj[@"LimitAmount"][@"bankIcon"]];//银行卡背景
        self.bankNumStr = obj[@"bank"][@"cardNo"];//银行卡号
        self.bankName = obj[@"bank"][@"bankName"];//银行卡名称
        //银行卡信息背景图
        [self bandViewLayout];
        //总额
        NSString *dayLimitAmount;
        if (self.tag.integerValue) {
            dayLimitAmount = [NSString stringWithFormat:@"%@",obj[@"cash"][@"actualAmount"]];
            self.nowDayLab.text = [NSString stringWithFormat:@"%.2f",dayLimitAmount.doubleValue];//日单笔
        }else{
            dayLimitAmount = [NSString stringWithFormat:@"%@",obj[@"recharge"][@"actualAmount"]];
            self.nowDayLab.text = [NSString stringWithFormat:@"%.2f",dayLimitAmount.doubleValue];//日单笔
        }
        NSString *monthLimitAmount = [NSString stringWithFormat:@"%@",obj[@"LimitAmount"][@"monthLimitAmount"]];
        self.mouthDayLab.text = [NSString stringWithFormat:@"月限额:%ld元",monthLimitAmount.integerValue];//月单笔
        NSString *singleLimitAmount = [NSString stringWithFormat:@"%@", obj[@"LimitAmount"][@"singleLimitAmount"]];
        self.singleLab.text = [NSString stringWithFormat:@"单笔限额:%ld元",singleLimitAmount.integerValue];//单笔
        if (![obj[@"recharge"] isEqual:[NSNull null]] ||![obj[@"cash"] isEqual:[NSNull null]]) {
            if (self.tag.integerValue == 0) {
                _dic = obj[@"recharge"];
            }
            else{
                _dic = obj[@"cash"];
            }
        }
        
        [self.tableView reloadData];

    } userId:[HCJFNSUser stringForKey:@"userId"] rechargeId:self.itemID type:self.tag.integerValue];    
    
}
/**
 *银行卡 信息View
 */
- (void)bandViewLayout{
    //空白View
    _bankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250*m6Scale)];
    _bankView.backgroundColor = Colorful(255, 255, 255);
    [self.view addSubview:_bankView];
    NSString *status = @"";
    if (self.tag.integerValue) {
        if ([_status isEqualToString:@"0"]) {
            status = @"提现失败";
        }else if ([_status isEqualToString:@"1"]) {
            status = @"提现成功";
        }else {
            status = @"审核中";
        }
    }else{
        if ([_status isEqualToString:@"0"]) {
            status = @"充值失败";
        }else if ([_status isEqualToString:@"1"]) {
            status = @"充值成功";
        }else {
            status = @"审核中";
        }
    }
    //充值成功、失败标签
    for (int i = 0; i < 2; i++) {
        if (i) {
            
        }else{
            //创建一个公共的View
            UIView *commonView = [[UIView alloc] init];
            [_bankView addSubview:commonView];
            //银行卡背景
            [commonView addSubview:self.iconImageView];
            NSLog(@"%@", _bankInmageName);
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_bankInmageName]];
            [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(commonView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50 * m6Scale));
            }];
            //当日限额
            _nowDayLab = [self commontLab:@"日限额:10万元"];
            _nowDayLab.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            _nowDayLab.font = [UIFont systemFontOfSize:56*m6Scale];
            [_bankView addSubview:_nowDayLab];
            [_nowDayLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_bankView.mas_centerY);
                make.centerX.equalTo(_bankView.mas_centerX);
            }];
            //银行卡名称
            UILabel *bankNameLabel = [Factory CreateLabelWithTextColor:0 andTextFont:30 andText:self.bankName addSubView:commonView];
            bankNameLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
            [bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconImageView.mas_right).offset(10*m6Scale);
                make.centerY.mas_equalTo(commonView.mas_centerY);
            }];
            [commonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_iconImageView.mas_left);
                make.right.mas_equalTo(bankNameLabel.mas_right);
                make.centerX.mas_equalTo(_bankView.mas_centerX);
                make.height.mas_equalTo(90*m6Scale);
                make.top.mas_equalTo(0);
            }];
            //交易状态
            UILabel *statusLabel = [Factory CreateLabelWithTextColor:0 andTextFont:26 andText:status addSubView:_bankView];
            statusLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bankView.mas_centerX);
                make.bottom.mas_equalTo(-30*m6Scale);
            }];
        }
    }
}
/**
 共性label
 */
- (UILabel *)commontLab:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:26*m6Scale];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    //_hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //导航设置
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    //加载银行卡信息
    [self loadBankMessage];
}
@end
