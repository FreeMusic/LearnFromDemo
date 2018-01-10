
//
//  InstantInvestViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/25.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InstantInvestViewController.h"
#import "InstantMessageCell.h"
#import "InstantFillCell.h"
#import "InvestPayCell.h"
#import "RedViewController.h"
#import "TicketViewController.h"
#import "RedModel.h"
#import "TicketModel.h"
#import "BindCradVC.h"
#import "InvestPayView.h"
#import "ForgetPasswordView.h"
#import "ItemDetailsModel.h"
#import "InvestDetailsModel.h"
#import "ActivityVC.h"
#import "RechargeView.h"
#import "BidCardFirstVC.h"
#import "InvestResultVC.h"
#import "RechargeView.h"
#import "TopUpVC.h"
#import "ScanIdentityVC.h"
#import "DealPswVC.h"
#import "TopUpView.h"
#import "companyView.h"

@interface InstantInvestViewController ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate, UITextFieldDelegate>
@property (nonatomic,strong) ItemDetailsModel *itemDetailsModel;
@property (nonatomic,strong) InvestDetailsModel *investDetailsModel;
@property (nonatomic, strong) UITableView *insatntTableView;
@property (nonatomic, copy) NSString *moneyString;//投资金额
@property (nonatomic, strong) InstantFillCell *cell;
@property (nonatomic, copy) NSString *remainingStr;//剩余金额
@property (nonatomic, copy) NSString *rechargeStr; //充值金额
@property (nonatomic, assign) NSInteger clipTag; //延时调用
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, copy) NSString *redAmount; //选择的红包金额
@property (nonatomic, assign) NSInteger password;
@property (nonatomic, strong) UITextField *hiddenTextfield; //隐藏输入框
@property (nonatomic, strong) ForgetPasswordView *passwordView; //密码输入视图
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableViewCell *incomecell;//收益cell
@property (nonatomic, strong) UITableViewCell *accountcell;//投资总金额
@property (nonatomic, copy) NSString *redStatus;//红包的状态
@property (nonatomic, copy) NSString *ticketStatus;//加息劵的状态
@property (nonatomic, strong) InvestPayView *investPayView;
@property (nonatomic, assign) NSInteger allow;//当用户第一次进入界面，点击投资金额输入框的时候，金额要清空
@property (nonatomic, strong) RechargeView *rechargeView;
@property (nonatomic, strong) NSString *redId;//红包ID
@property (nonatomic, strong) NSString *ticketId;//加息券ID
@property (nonatomic, strong) TopUpView *topUpView;//调用充值页面
@property (nonatomic, strong) NSString *bankId;//在充值的时候 获取bankId
@property (nonatomic, strong) companyView *companyView;
@property (nonatomic, strong) NSString *payMentId;//zhifu支付公司Id

@end

@implementation InstantInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:self.titleName];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.rechargeStr = @"0";
    self.moneyString = @"0";
    //将tableView添加到self.view上
    [self.view addSubview:self.insatntTableView];
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    self.hiddenTextfield.hidden = YES;
    [self.view addSubview:self.hiddenTextfield];
    [self serverData];//服务器数据
    [self nsNotification];//通知
    //交易密码界面
    [self getRechargeView];
}
/**
 * 交易密码界面
 */
- (void)getRechargeView{
    _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _rechargeView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    __weak typeof(self)weakSelf = self;
    [_rechargeView setSkipToBankListView:^(NSInteger index, NSArray *dataSource, NSArray *payArr, NSInteger bankDefault, NSInteger comDefalut){
        if (index == 0) {
            BankListModel *model = dataSource[index];
            weakSelf.bankId = [NSString stringWithFormat:@"%@", model.ID];
            [weakSelf.rechargeView.myTextFiled resignFirstResponder];
            weakSelf.rechargeView.hidden = YES;
            weakSelf.topUpView.hidden = NO;
            weakSelf.topUpView.btn.hidden = NO;
            [weakSelf.topUpView viewWithModel:dataSource andIndex:bankDefault];
            CGFloat height = 90*m6Scale*dataSource.count+104*m6Scale+84*m6Scale;
            if (height < kScreenHeight*0.6) {
                weakSelf.topUpView.backView.frame = CGRectMake(0, kScreenHeight-height-KSafeBarHeight, kScreenWidth, height);
            }else{
                weakSelf.topUpView.backView.frame = CGRectMake(0, kScreenHeight-kScreenHeight*0.6-KSafeBarHeight, kScreenWidth, kScreenHeight*0.6);
            }
        }else{
            BankListModel *model = dataSource[index-1];
            weakSelf.bankId = [NSString stringWithFormat:@"%@", model.ID];
            [weakSelf.rechargeView.myTextFiled resignFirstResponder];
            weakSelf.rechargeView.hidden = YES;
            weakSelf.companyView.hidden = NO;
            weakSelf.companyView.dataSource = payArr;
            NSInteger num = payArr.count;
            [weakSelf.companyView.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(weakSelf.companyView.mas_centerX);
                make.centerY.mas_equalTo(weakSelf.companyView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth-200*m6Scale, 106*(num+1)*m6Scale));
            }];
            
            [weakSelf.companyView.tableView reloadData];
            weakSelf.companyView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            
        }
    }];
}
/**
 网络状态的监听
 */
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *输入交易密码弹出视图
 */
- (RechargeView *)rechargeView{
    if(!_rechargeView){
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    }
    return _rechargeView;
}
/**
 *   支付公司视图
 */
- (companyView *)companyView{
    if(!_companyView){
        _companyView = [[companyView alloc] init];
        
        [self.navigationController.view addSubview:_companyView];
    }
    return _companyView;
}
/**
 添加通知
 */
- (void)nsNotification{
    //输入框中改变金额的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyTextNoti:) name:@"clip" object:nil];
    //红包
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedRedAmountWithNoti:) name:@"selectRed" object:nil];
    //加息劵
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectedTicktetAmountWithNoti:) name:@"selectTicktet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLabelText:) name:@"redClipDota" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailLabelTextNoti:) name:@"redClip" object:nil];
    //加减
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTextNoti:) name:@"zyyAdd" object:nil];
    //控制tabView的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabviewH:) name:@"tabviewH" object:nil];
    //接收输入完交易密码 调用投资接口
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
    //接受添加银行卡消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxySkipToBidCard) name:@"sxySkipToBidCard" object:nil];
    //获取银行卡Bankid
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BankId:) name:@"SxyGetBankId" object:nil];
    //记录选择到的银行卡
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseBank:) name:@"chooseBank" object:nil];
    //hu获取选择到的支付公司
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCompanyPay:) name:@"selectedCompanyPay" object:nil];
    //获取payMentId
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SxyGetPayMentId:) name:@"SxyGetPayMentId" object:nil];
}
#pragma mark - 懒加载
- (UITableView *)insatntTableView {
    if (!_insatntTableView) {
        _insatntTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _insatntTableView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        _insatntTableView.delegate = self;
        _insatntTableView.dataSource = self;
        _insatntTableView.separatorColor = SeparatorColor;
        _insatntTableView.scrollEnabled = NO;
        
        _insatntTableView.sectionHeaderHeight = 0;
        _insatntTableView.sectionFooterHeight = 15*m6Scale;
        
        
    }
    
    return _insatntTableView;
}
/**
 账户可投金额
 */
- (void)crashData{
    [DownLoadData postIncome:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"fail"] && [obj[@"messageCode"] isEqualToString:@"sys.error"]) {
            [Factory alertMes:Message];
        } else {
            _remainingStr = [NSString stringWithFormat:@"%.2f",[obj[@"accountUsable"] doubleValue]];//账户余额
        }
        [_insatntTableView reloadData];
        
        [self refreshRedData];
    } userId:[defaults objectForKey:@"userId"]];
}
/**
 红包的筛选
 */
- (void)changeLabelText:(NSNotification *)noti {
    UITableViewCell *redCell = [self.view viewWithTag:230];
    
    NSArray *array = noti.userInfo[@"dataArr"];
    NSUserDefaults *user = HCJFNSUser;
    redCell.detailTextLabel.text = @"暂无可用";
    redCell.detailTextLabel.textColor = [UIColor grayColor];
    NSInteger index = 0;
    //根据用户当前输入的投资金额，判断能够使用红包
    NSString *canUseRed = @"";
    if ([noti.userInfo[@"status"] isEqualToString:@"red"]) {
        if (array.count == 0) {
            //红包ID
            self.redId = @"";
            redCell.detailTextLabel.text = @"暂无可用";
//            redCell.userInteractionEnabled = NO;
            _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%ld元",(long)_moneyString.integerValue];//投资总金额
            //预期收益
            [self culator];
        }else {
            
            for (int i = 0; i < array.count; i++) {
                RedModel *model = array[i];
                
                if (model.canUse.integerValue == 1) {
                    canUseRed = @"YES";
                    index = i;
                    
                    break;
                }else{
                    canUseRed = @"NO";
                }
            }
            NSLog(@"%@", _redStatus);
            if ([canUseRed isEqualToString:@"NO"]) {
                redCell.detailTextLabel.text = @"暂无可用";
                //红包ID
                self.redId = @"";
                _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%ld元",(long)_moneyString.integerValue];//投资总金额
                //预期收益
                [self culator];
            }else{
                
                if ([_redStatus isEqualToString:@"NO"]) {
                    redCell.detailTextLabel.text = @"暂不使用";
                    self.redId = @"";
                }else{
                    //可以使用红包
                    RedModel *model = array[index];
                    //红包ID
                    self.redId = [NSString stringWithFormat:@"%@", model.ID];
                    //            redCell.detailTextLabel.text  = [NSString stringWithFormat:@"最高可使用%@元",model.amount];
                    
                    redCell.detailTextLabel.textColor = [UIColor redColor];
                    redCell.detailTextLabel.text = [NSString stringWithFormat:@"+%@元",model.amount];
                    _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%ld元",_moneyString.integerValue + model.amount.integerValue];//投资总金额
                    //预期收益
                    [self culator];
                    [user setValue:[NSString stringWithFormat:@"%@",model.ID] forKey:@"zyyRedId"];
                    [user synchronize];
                }
            }
        }
    }
}
/**
 加息劵的筛选
 */
- (void)detailLabelTextNoti:(NSNotification *)noti {
    
    NSUserDefaults *user = HCJFNSUser;
    UITableViewCell *ticketCell = [self.view viewWithTag:229];
    ticketCell.detailTextLabel.text = @"暂无可用";
    ticketCell.detailTextLabel.textColor = [UIColor grayColor];
    NSArray *array = noti.userInfo[@"dataArr"];
    //TicketModel *model = [array firstObject];
    //当用户输入金额的时候 判断用户能否使用加息券
    NSString *canUse = @"";
    //能够所用的加息券ID
    NSInteger tickID = 0;
    if ([noti.userInfo[@"status"] isEqualToString:@"ticket"]) {
        if (array.count == 0) {
            ticketCell.detailTextLabel.text = @"暂无可用";
            self.ticketId = @"";
        }else {
            for (int i = 0; i < array.count; i++) {
                TicketModel *model = array[i];
                
                if (model.canUse.integerValue == 1) {
                    canUse = @"YES";
                    tickID = i;
                    
                    break;
                }else{
                    canUse = @"NO";
                }
            }
            if ([canUse isEqualToString:@"NO"]) {
                ticketCell.detailTextLabel.text = @"暂无可用";
                self.ticketId = @"";
            }else{
                ticketCell.userInteractionEnabled = YES;
                if ([_ticketStatus isEqualToString:@"NO"]) {
                    ticketCell.detailTextLabel.text = @"暂不使用";
                    self.ticketId = @"";
                    //预期收益
                    [self culator];
                }else{
                    TicketModel *model = array[tickID];
                    self.ticketId = [NSString stringWithFormat:@"%@", model.ID];
                    ticketCell.detailTextLabel.textColor = [UIColor redColor];
                    ticketCell.detailTextLabel.text = [NSString stringWithFormat:@"+ %.1f%%/%@天",model.rate.doubleValue,model.usefulLife];
                    [user setValue:[NSString stringWithFormat:@"%@",model.ID] forKey:@"zyyTicketId"];
                    [user synchronize];
                    if (_itemDetailsModel.itemCycle.integerValue < model.usefulLife.integerValue) {
                        [Factory alertMes:[NSString stringWithFormat:@"加息%ld天",(long)_itemDetailsModel.itemCycle.integerValue]];
                    }else{
                        
                    }
                    //预期收益
                    [self culator];
                }
            }
        }
    }
}
/**
 *获取银行卡Id
 */
- (void)BankId:(NSNotification *)noti{
    self.bankId = noti.userInfo[@"bankId"];
}
/**
 *记录选择到的银行卡
 */
- (void)chooseBank:(NSNotification *)noti{
    BankListModel *model = noti.userInfo[@"model"];
    NSLog(@"%@", noti.userInfo[@"index"]);
    self.bankId = [NSString stringWithFormat:@"%@", model.ID];
    
    _rechargeView.model = model;
    
    _rechargeView.hidden = NO;
    [_rechargeView.myTextFiled becomeFirstResponder];
}
/**
 创建布局
 */
- (void)createFootView {
    if (!_investPayView) {
        _investPayView = [[InvestPayView alloc] init];
        [_investPayView.makeSureButton addTarget:self action:@selector(makeSureButton:) forControlEvents:UIControlEventTouchUpInside];
        _investPayView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_investPayView];
        
        [_investPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left);
            if (kStatusBarHeight > 20) {
                make.bottom.equalTo(-kTabBarHeight+98*m6Scale);
            }else{
                make.bottom.equalTo(self.view.mas_bottom);
            }
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(98 * m6Scale);
        }];
        _investPayView.payLabel.tag = 129;
    }
    _investPayView.payLabel.text = _rechargeStr;
}
/**
 *  标详情数据
 */
- (void)serverData{
    //登录状态的项目信
    [DownLoadData postInformation:^(id obj, NSError *error) {
        _itemDetailsModel = obj[@"ItemDetailsModel"];
        NSLog(@"%@", _itemDetailsModel.itemCycle);
        //剩余可投金额大于100
        if (_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue>100) {
            self.moneyString = @"100";
        }else{
            self.moneyString = [NSString stringWithFormat:@"%d", _itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue];
        }
        _investDetailsModel = obj[@"InvestDetailsModel"];
        [self.insatntTableView reloadData];
        [self crashData];//可投金额
        
    } itemId:self.itemId userId:[HCJFNSUser stringForKey:@"userId"]];
}

#pragma mark -加减
- (void)addTextNoti:(NSNotification *)noti{
    if ([noti.userInfo[@"moneyText"] integerValue] == 0) {//减
        if (_moneyString.integerValue <= 0) {
            _cell.textFiled.text = @"0";
            _moneyString = _cell.textFiled.text;
        }else{
            _cell.textFiled.text = _moneyString;
            _cell.textFiled.text = [NSString stringWithFormat:@"%d",_cell.textFiled.text.integerValue - 100];
            _moneyString = _cell.textFiled.text;
        }
    }else{//加
        _cell.textFiled.text = [NSString stringWithFormat:@"%d",_moneyString.integerValue + 100];
        _moneyString= _cell.textFiled.text;
        if (_cell.textFiled.text.integerValue > _itemDetailsModel.itemAccount.integerValue-_itemDetailsModel.itemOngoingAccount.integerValue) {
            _cell.textFiled.text = [NSString stringWithFormat:@"%d", _itemDetailsModel.itemAccount.integerValue-_itemDetailsModel.itemOngoingAccount.integerValue];
        }else{
            
        }
        _moneyString = _cell.textFiled.text;
    }
    //投资总额
    if (_moneyString.intValue <= 0) {
        _cell.textFiled.text = @"0";
        _moneyString = _cell.textFiled.text;
        _accountcell.detailTextLabel.text = @"0元";
    }else{
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_moneyString];
    }
    if (self.moneyString.integerValue - self.remainingStr.integerValue > 0) {
        _rechargeStr = [NSString stringWithFormat:@"%.2f", self.moneyString.floatValue - self.remainingStr.floatValue];
    }else{
        _rechargeStr = @"0";
    }
    //
    [self createFootView];
    [self culator];//预期收益
    
    [self refreshRedData];
}
#pragma mark - moneyText通知事件
- (void)moneyTextNoti:(NSNotification *)noti {
    
    static NSInteger tag = 0;
    //刷新tag值
    self.clipTag = 0;
    NSLog(@"money===%@----%@",noti.userInfo[@"moneyText"],_remainingStr);
    
    _moneyString = noti.userInfo[@"moneyText"];
    //投资总额
    if (_moneyString.intValue == 0) {
        _accountcell.detailTextLabel.text = @"0元";
    }else{
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",noti.userInfo[@"moneyText"]];
    }
    NSUserDefaults *user = HCJFNSUser;
    [user removeObjectForKey:@"zyyRedId"];//红包id
    [user removeObjectForKey:@"zyyTicketId"];//加息劵id
    [user synchronize];
    //判断是否需要充值
    if ([_remainingStr doubleValue] >= [_moneyString doubleValue]) {
        
        _rechargeStr = @"0";
    }else {
        _rechargeStr = [NSString stringWithFormat:@"%.2f",[_moneyString doubleValue] - [_remainingStr doubleValue]];
    }
    _investPayView.payLabel.text = _rechargeStr;
    NSLog(@"%@", _investPayView.payLabel.text);
    [self culator];//预期收益
    
    //能够保证只开启一次
    if (tag == 0) {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshRedData) userInfo:nil repeats:YES];
    }
    tag ++;
    [self refreshRedData];
}
/**
 预期收益
 */
- (void)culator{
    //预期收益
    [DownLoadData postcalCulator:^(id obj, NSError *error) {
        
        NSLog(@"1111----%@",obj);
        if ([obj[@"result"] isEqualToString:@"fail"]) {
            
            _incomecell.detailTextLabel.text = @"0.00元";
        }
        else{
            //收益
            _incomecell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",obj[@"interest"]];
        }
    } andamount:_accountcell.detailTextLabel.text anditemId:_itemId andticketId:[defaults objectForKey:@"zyyTicketId"]];
}
//全部金额填写
- (void)getMoneyStrWithNoti {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //调用自动填入接口
    [DownLoadData postAutoFill:^(id obj, NSError *error) {
        [hud setHidden:YES];
        NSString *str = obj[@"ret"];
        _redStatus = @"YES";
        self.moneyString = [NSString stringWithFormat:@"%ld", (long)str.integerValue];
        _cell.textFiled.text = self.moneyString;
        //[self culator];//预期收益
        [self refreshRedData];
        if (self.moneyString.integerValue - self.remainingStr.integerValue > 0) {
            _rechargeStr = [NSString stringWithFormat:@"%.2f", self.moneyString.floatValue - self.remainingStr.floatValue];
        }else{
            _rechargeStr = @"0";
        }
        _investPayView.payLabel.text = [NSString stringWithFormat:@"%@", self.rechargeStr];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] itemId:self.itemId];
}

//获取到用户所选择红包的金额大小
- (void)getSelectedRedAmountWithNoti:(NSNotification *)noti {
    
    //NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UITableViewCell *redCell = [self.view viewWithTag:230];
    _redStatus = noti.userInfo[@"status"];//获得红包是否选中的状态
    if ([noti.userInfo[@"status"] isEqualToString:@"YES"]) {
        
        redCell.detailTextLabel.textColor = [UIColor redColor];
        redCell.detailTextLabel.text = [NSString stringWithFormat:@"+ %@元",noti.userInfo[@"text"]];
        
        NSString *str = noti.userInfo[@"text"];
        self.redId = [HCJFNSUser stringForKey:@"zyyRedId"];
        NSLog(@"%@", str);
        //总金额加上红包金额
        //        self.cell.investTextFiled.text = [NSString stringWithFormat:@"%li",(self.moneyString.integerValue + str.integerValue)];
        //self.cell.investTextFiled.text = self.moneyString;
        //投资总额
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%i元",(self.moneyString.integerValue + str.integerValue)];
        //红包金额
        self.redAmount = noti.userInfo[@"text"];
        NSLog(@"%@", _accountcell.detailTextLabel.text);
        //预期收益
        [self culator];
    }else {
        
        //self.cell.investTextFiled.text = self.moneyString;
        //投资总额
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元", self.moneyString];
        
        self.redAmount = nil;
        
        self.clipTag = 1;
        NSLog(@"%@", _accountcell.detailTextLabel.text);
        //预期收益
        [self culator];
        [self refreshRedData];
    }
}
/**
 加息的数值
 */
- (void)getSelectedTicktetAmountWithNoti:(NSNotification *)noti {
    
    UITableViewCell *ticketCell = [self.view viewWithTag:229];
    _ticketStatus = noti.userInfo[@"status"];//获得加息劵是否选中的状态
    self.ticketId = [HCJFNSUser stringForKey:@"zyyTicketId"];
    if ([noti.userInfo[@"status"] isEqualToString:@"YES"]) {
        
        ticketCell.detailTextLabel.textColor = [UIColor redColor];
        ticketCell.detailTextLabel.text = [NSString stringWithFormat:@"+ %@%%/%@天",noti.userInfo[@"text"],noti.userInfo[@"scope"]];
        if (_itemDetailsModel.itemCycle.integerValue < [noti.userInfo[@"scope"] integerValue]) {
            [Factory alertMes:[NSString stringWithFormat:@"加息%ld天",(long)_itemDetailsModel.itemCycle.integerValue]];
        }else{
            
        }
        //预期收益
        [self culator];
    }else {
        
        self.clipTag = 1;
        
        //预期收益
        [self culator];
        
        [self refreshRedData];
    }
}
/**
 刷新红包,加息劵数据
 */
- (void)refreshRedData {
    self.clipTag ++;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userId = [user objectForKey:@"userId"];
    
    //UITableViewCell *ticketCell = [self.view viewWithTag:229];
    
    //    if (self.clipTag == 2) {
    
    //        [self labelExample];//HUD6红包
    [DownLoadData postShowRedMessage:^(id obj, NSError *error) {
        NSArray *array = obj[@"SUCCESS"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redClipDota" object:nil userInfo:@{
                                                                                                        @"status" : @"red",
                                                                                                        @"dataArr" : array}];
        
        
    } amount:_moneyString userId:userId anditemCycle:[NSString stringWithFormat:@"%@",_itemDetailsModel.itemCycle] andbalance:[NSString stringWithFormat:@"%d",_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue]];
    
    //加息劵
    [DownLoadData postShowTicketMessage:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        
        NSArray *array = obj[@"SUCCESS"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"redClip" object:nil userInfo:@{@"status" : @"ticket",@"dataArr" : array}];
        
        
    } amount:_moneyString userId:userId anditemCycle:[NSString stringWithFormat:@"%@",_itemDetailsModel.itemCycle] andbalance:[NSString stringWithFormat:@"%d",_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue]];
    //    }
}


/**
 隐藏输入框
 */
- (UITextField *)hiddenTextfield {
    
    if (_hiddenTextfield == nil) {
        _hiddenTextfield = [[UITextField alloc] init];
        _hiddenTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _hiddenTextfield.delegate = self;
        _hiddenTextfield.inputAccessoryView = self.passwordView;
        
    }
    return _hiddenTextfield;
}
/**
 密码输入视图
 */
- (ForgetPasswordView *)passwordView {
    
    if (_passwordView == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardAction:)];
        _passwordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 355 * m6Scale)];
        _passwordView.backgroundColor = [UIColor whiteColor];
        [_passwordView.cancelImageView addGestureRecognizer:tap];
    }
    return _passwordView;
}
/**
 返回
 */
- (UIButton *)backButton {
    
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _backButton.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [_backButton addTarget:self action:@selector(hiddenKeyboardAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
#pragma mark - 隐藏键盘
- (void)hiddenKeyboardAction:(UIButton *)button {
    
    self.backButton.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    CATransition *clip = [[CATransition alloc] init];
    clip.type = @"fade";
    clip.duration = 0.3;
    self.passwordView.passwordText = nil;
    [self.backButton.layer addAnimation:clip forKey:nil];
    self.hiddenTextfield.text = nil;
    [self.hiddenTextfield resignFirstResponder];
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 1;
    }else {
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {//标详情
            
            InstantMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instantCell"];
            
            if (cell == nil) {
                
                cell = [[InstantMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"instantCell"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            [cell cellForModel:_itemDetailsModel];
            
            return cell;
        }else {//金额输入框
            
            _cell = [tableView dequeueReusableCellWithIdentifier:@"instantFill"];
            if (!_cell) {
                
                _cell = [[InstantFillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"instantFill"];
                _cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [_cell.autoBtn addTarget:self action:@selector(getMoneyStrWithNoti) forControlEvents:UIControlEventTouchUpInside];//全部填入
            //剩余可投金额大于100
            if (_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue>100) {
                _cell.textFiled.text = @"100";
            }else{
                _cell.textFiled.text = [NSString stringWithFormat:@"%d", _itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue];
            }
            _cell.textFiled.delegate = self;
            //监听用户键盘的输入
            [_cell.textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            _moneyString = _cell.textFiled.text;//投资金额
            if (self.moneyString.integerValue - self.remainingStr.integerValue > 0) {
                _rechargeStr = [NSString stringWithFormat:@"%.2f", self.moneyString.floatValue - self.remainingStr.floatValue];
            }else{
                _rechargeStr = @"0";
            }
            //
            [self createFootView];
            
            return _cell;
        }
        
    }else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clipCelll"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"clipCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"加息券";
            cell.detailTextLabel.text = @"暂无可用";
            cell.tag = 229;
        }else {
            
            cell.textLabel.text = @"红包";
            cell.detailTextLabel.text = @"暂无可用";
            cell.tag = 230;
        }
        
        return cell;
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            _incomecell = [tableView dequeueReusableCellWithIdentifier:HCJF];
            if (!_incomecell) {
                _incomecell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HCJF];
                _incomecell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            _incomecell.textLabel.text = @"预期收益";
            _incomecell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            _incomecell.detailTextLabel.text = @"0.00元";
            _incomecell.detailTextLabel.textColor = [UIColor redColor];
            return _incomecell;
        }else{
            _accountcell = [tableView dequeueReusableCellWithIdentifier:HCJF];
            if (!_accountcell) {
                _accountcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HCJF];
                _accountcell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            _accountcell.textLabel.text = @"投资总额";
            _accountcell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元", _moneyString];
            return _accountcell;
        }
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"useSum"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"useSum"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"账户可投余额";
        cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        if (_remainingStr == nil) {
            cell.detailTextLabel.text = @"¥ 0.00";
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[_remainingStr doubleValue]];
        }
        
        //        [self refreshRedData];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 394*m6Scale;
        }else{
            return 148 * m6Scale;
        }
    }else {
        return 93 * m6Scale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15 * m6Scale;
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //加息券
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self.view endEditing:YES];
        if (_itemDetailsModel.prepayment.integerValue == 0) {
            TicketViewController *ticket = [TicketViewController new];
            ticket.moneyStr = _moneyString;//投资金额
            ticket.itemTime = [NSString stringWithFormat:@"%@",_itemDetailsModel.itemCycle];//项目时间
            ticket.balance = [NSString stringWithFormat:@"%d",_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue];//项目余额
            [self.navigationController pushViewController:ticket animated:YES];
        }else {
            [Factory alertMes:@"该标暂不支持使用加息券"];
        }
    }
    //红包
    else if (indexPath.section == 1 && indexPath.row == 1) {
        [self.view endEditing:YES];
        RedViewController *redVC = [RedViewController new];
        redVC.moneyStr = _moneyString;//投资金额
        redVC.itemTime = [NSString stringWithFormat:@"%@",_itemDetailsModel.itemCycle];//项目时间
        redVC.balance = [NSString stringWithFormat:@"%d",_itemDetailsModel.itemAccount.integerValue -_itemDetailsModel.itemOngoingAccount.integerValue];//项目余额
        NSLog(@"+++++%@-----itemTime=%@",redVC.moneyStr,redVC.itemTime);
        [self.navigationController pushViewController:redVC animated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _cell.textFiled) {
        return YES;
    }else{
        NSString *text;
        //    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"."] || [string isEqualToString:@"0"]) {
            
            if ([string isEqualToString:@""]) {
                //获取到上一次操作的字符串长度
                NSInteger clip = textField.text.length;
                //截取字符串 将最后一个字符删除
                text = [textField.text substringToIndex:clip - 1];
                
            }else {
                
                text = [textField.text stringByAppendingString:string];
            }
        }
        
        if (text.length == 6) {
            self.passwordView.passwordText = text;
            
            if ([text integerValue] == self.password) {
                
                [self hiddenKeyboardAction:nil];
                
                [self investAction];
            }else {
                
                self.passwordView.messageLabel.text = @"定向密码错误，请重新输入";
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self.passwordView.messageLabel.text = @"请输入该标的定向密码";
                    
                    self.hiddenTextfield.text = nil;
                    
                    self.passwordView.passwordText = nil;
                    
                });
            }
            
            return YES;
            
        }else if (text.length >= 7) {
            
            return NO;
            
        }else {
            
            self.passwordView.passwordText = text;
            
            return YES;
        }
    }
}
/**
 *当用户开始在投资金额输入框中输入金额时，需要清空输入框中的数据
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.allow == 0) {
        textField.text = @"";
        _moneyString = @"0";
        [self refreshRedData];
    }
    self.allow ++;
    _investPayView.payLabel.text = @"0";
    //投资总额
    if (_moneyString.intValue == 0) {
        _accountcell.detailTextLabel.text = @"0元";
    }else{
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_moneyString];
    }
    [self culator];//预期收益
    //提高tabView的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabviewH" object:@"0"];
}
/**
 *监听用户投资金额的输入
 */
-(void)textFieldDidChange :(UITextField *)theTextField{
    //剩余可投金额
    NSInteger restMoney = _itemDetailsModel.itemAccount.integerValue - _itemDetailsModel.itemOngoingAccount.integerValue;
    if (theTextField.text.integerValue > restMoney) {
        theTextField.text = [NSString stringWithFormat:@"%ld", (long)restMoney];
    }
    _moneyString = theTextField.text;
    if (self.moneyString.integerValue - self.remainingStr.integerValue > 0) {
        _rechargeStr = [NSString stringWithFormat:@"%.2f", self.moneyString.floatValue - self.remainingStr.floatValue];
    }else{
        _rechargeStr = @"0";
    }
    //用户需要充值的金额
    _investPayView.payLabel.text = _rechargeStr;
    //根据用户输入的金额筛选红包和加息券
    [self refreshRedData];
    //投资总额
    if (_moneyString.intValue == 0) {
        theTextField.text = @"0";
        _accountcell.detailTextLabel.text = @"0元";
    }else{
        theTextField.text = [NSString stringWithFormat:@"%d", theTextField.text.integerValue];
        _accountcell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_moneyString];
    }
    
}
/**
 *用户确实停止金额的输入
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self culator];//预期收益
}
/**
 *充值页面
 */
- (TopUpView *)topUpView{
    
    if(!_topUpView){
    _topUpView = [[TopUpView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.navigationController.view addSubview:_topUpView];
    }
    
    return _topUpView;
}
/**
 *  确认投资
 */
- (void)makeSureButton:(UIButton *)sender{
    //投资
    [self investAction];
}
#pragma mark -investAction
- (void)investAction {
    //[self labelExample];
    NSString *money = [_accountcell.detailTextLabel.text substringToIndex:[_accountcell.detailTextLabel.text length]-1];
    if (money.integerValue == 0) {
        //用户输入的投资金额为0
        [Factory alertMes:@"请输入投资金额"];
        [_hud hideAnimated:YES];
    }else{
        //再校验账户余额
        if (_rechargeStr.integerValue) {
            _rechargeView.style = @"2";
            
            //用户账户余额不足 校验用户是否已经实名绑卡过
            [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
                [_hud hideAnimated:YES];
                NSString *result = obj[@"result"];
                //用户绑定过银行卡
                if ([result isEqualToString:@"success"]) {
                    //用户余额不足
                    if (_rechargeStr.integerValue) {
                        self.rechargeView.hidden = NO;
                        self.rechargeView.titleLabel.text = [NSString stringWithFormat:@"投资总额%.2f", money.floatValue];
                        self.rechargeView.isShowBankList = @"100";
                        self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", _rechargeStr.floatValue];
                        self.rechargeView.styleLabel.text = @"还需充值金额";
                        [self.rechargeView.myTextFiled becomeFirstResponder];
                    }else{
                        [self.view endEditing:YES];
                    }
                }else {
                    //提示用户去绑卡
                    [self alert];
                }
                
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }else{
            //账户余额够用 进行交易密码的验证
            _rechargeView.hidden = NO;
            _rechargeView.isShowBankList = @"0";
            _rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", money.floatValue];
            _rechargeView.styleLabel.text = @"投资总额";
            _rechargeView.style = @"1";
            [_rechargeView.myTextFiled becomeFirstResponder];
        }
    }
}
/**
 是否绑卡提示
 */
- (void)alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
//        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转至绑定银行卡页面
        BidCardFirstVC *tempVC = [BidCardFirstVC new];
        tempVC.userName = self.userName;//用户的真实姓名
        tempVC.index = 100;
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *当用户点击确认投资按钮时，假如用户余额不足时，提示用户是否充值
 */
- (void)RechargeStrAlter{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您的余额不足，是否立刻充值?" preferredStyle:UIAlertControllerStyleAlert];
    [_hud hideAnimated:YES];//HUD
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TopUpVC *tempVC = [TopUpVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 控制tabView的高度
 */
- (void)tabviewH:(NSNotification *)noti{
    if ([noti.object integerValue] == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.insatntTableView.frame = CGRectMake(0, -160, kScreenWidth, kScreenHeight);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.insatntTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }
}
/**
 *用户输入交易密码  调用投资接口
 */
- (void)sxyRecharge:(NSNotification *)noti{
    //加密后的交易密码
    NSString *paymentPassword = noti.userInfo[@"passWord"];
    //加密因子
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    //区分是充值还是投资
    NSString *style = noti.userInfo[@"style"];
    //用户输入的交易金额
    NSString *money = [_accountcell.detailTextLabel.text substringToIndex:[_accountcell.detailTextLabel.text length]-1];
    self.rechargeView.hidden = YES;
    self.rechargeView.isAllow = YES;
    self.rechargeView.myTextFiled.text = @"";
    [self.rechargeView.myTextFiled resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = NSLocalizedString(@"处理中...", @"HUD loading title");
    if (style.integerValue == 1) {
        //投资接口
        [DownLoadData postBuy:^(id obj, NSError *error) {
            [hud setHidden:YES];
            if ([obj[@"result"] isEqualToString:@"fail"]) {
                //投资失败
                NSString *error = obj[@"messageText"];
                //用户交易密码输入错误
                if ([error containsString:@"密码错误"]) {
                    //用户交易密码输入错误
                    [self alterUserPswError];
                }else{
                    //
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        sleep(1);
                        //回到主队列
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [Factory alertMes:obj[@"messageText"]];
                        });
                    });
                }
            }else{
                //投资成功
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(1);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        InvestResultVC *tempVC = [InvestResultVC new];
                        tempVC.amount = money;//投资金额
                        tempVC.orderId = obj[@"investId"];//用户投资的ID
                        [self.navigationController pushViewController:tempVC animated:YES];
                    });
                });
            }
        } amount:money userId:[HCJFNSUser stringForKey:@"userId"] couponId:self.redId ticketId:self.ticketId investType:@"7" itemId:self.itemId paymentPassword:paymentPassword mcryptKey:mcryptKey];
    }else{
        //充值
        [DownLoadData postApplyRecharge:^(id obj, NSError *error) {
            if ([obj[@"result"] isEqualToString:@"success"]) {
                //投资接口
                [DownLoadData postBuy:^(id obj, NSError *error) {
                    [hud setHidden:YES];
                    if ([obj[@"result"] isEqualToString:@"fail"]) {
                        //投资失败
                        NSString *error = obj[@"messageText"];
                        //用户交易密码输入错误
                        if ([error containsString:@"密码错误"]) {
                            //用户交易密码输入错误
                            [self alterUserPswError];
                        }else{
                            //
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                                sleep(1);
                                //回到主队列
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [Factory alertMes:obj[@"messageText"]];
                                });
                            });
                        }
                    }else{
                        //投资成功
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                            sleep(1);
                            //回到主队列
                            dispatch_async(dispatch_get_main_queue(), ^{
                                InvestResultVC *tempVC = [InvestResultVC new];
                                tempVC.amount = money;//投资金额
                                tempVC.orderId = obj[@"investId"];//用户投资的ID
                                [self.navigationController pushViewController:tempVC animated:YES];
                            });
                        });
                    }
                } amount:money userId:[HCJFNSUser stringForKey:@"userId"] couponId:self.redId ticketId:self.ticketId investType:@"7" itemId:self.itemId paymentPassword:paymentPassword mcryptKey:mcryptKey];
            }else{
                [hud setHidden:YES];
                if ([obj[@"messageText"] containsString:@"密码错误"]) {
                    //用户交易密码输入错误
                    [self alterUserPswError];
                }else{
                    [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
                }
            }
        } userId:[HCJFNSUser stringForKey:@"userId"] amount:_rechargeStr bankId:self.bankId password:paymentPassword mcryptKey:mcryptKey paymentId:self.payMentId];
    }
}
/**
 移除通知
 */
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clip" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectRed" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectTicktet" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"redClipDota" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"redClip" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"zyyAdd" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabviewH" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *提示用户交易面膜输入错误
 */
- (void)alterUserPswError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您输入的交易密码错误" preferredStyle:UIAlertControllerStyleAlert];
    [_hud hideAnimated:YES];//HUD
    [alert addAction:[UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DealPswVC *tempVC = [DealPswVC new];
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.rechargeView.hidden = NO;
        [self.rechargeView.myTextFiled becomeFirstResponder];
        
        [self.view endEditing:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"投资中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
}
/**
 *跳转至绑银行卡界面
 */
- (void)sxySkipToBidCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.index = 100;
    tempVC.userName = self.userName;//用户的真实姓名
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *  获取支付公司Id
 */
- (void)SxyGetPayMentId:(NSNotification *)noti{
    
    self.payMentId = noti.userInfo[@"PayMentId"];
    
}
/**
 *  选组支付公司 通知实施方法
 */
- (void)selectedCompanyPay:(NSNotification *)noti{
    
    _companyView.hidden = YES;
    
    _rechargeView.topUpModel = noti.userInfo[@"model"];
    
    self.payMentId = [NSString stringWithFormat:@"%@", _rechargeView.topUpModel.paymentId];

    NSLog(@"%@", self.payMentId);
    
    [_rechargeView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil] withRowAnimation:NO];
    
    _rechargeView.hidden = NO;
    [_rechargeView.myTextFiled becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:navigationYellowColor];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [Factory hidentabar];
    [Factory navgation:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.insatntTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}

@end
