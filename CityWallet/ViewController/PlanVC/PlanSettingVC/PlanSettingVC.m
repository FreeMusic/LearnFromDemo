//
//  PlanSettingVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PlanSettingVC.h"
#import "PlanHeaderCell.h"
#import "PlanCenterCell.h"
#import "PlanBottomCell.h"
#import "FormValidator.h"
#import "PlanSetModel.h"
#import "CreatView.h"
#import "ForgetPasswordView.h"
#import "RechargeView.h"
#import "ScanIdentityVC.h"
#import "BidCardFirstVC.h"
#import "DealPswVC.h"
#import "ProtocolVC.h"
#import "OpenAlertView.h"
#import "NewSignVC.h"
#import "MywelfareVC.h"

@interface PlanSettingVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *openLabel;//开放金额标签
@property (nonatomic, strong) UILabel *restLabel;//剩余额度标签
@property (nonatomic, strong) UIButton *delegateBtn;//协议按钮
@property (nonatomic, strong) PlanSetModel *planSetModel;
@property (nonatomic, strong) CreatView *creatView;
@property (nonatomic, strong) NSString *timeRandom;//本地生成的验证码
@property (nonatomic, strong) NSString *validPhoneExpiredTime;//后台返回的时间戳
@property (nonatomic, strong) ForgetPasswordView *passwordView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PlanCenterCell *cell;
@property (nonatomic, strong) RechargeView *rechargeView;//输入交易密码弹出视图
@property (nonatomic, strong) NSString *passWord;//控件加密后的后密码
@property (nonatomic, strong) NSString *planMinLimit;//起投金额
@property (nonatomic, strong) NSString *protocol;//记录页面是否已经创建了
@property (nonatomic, strong) OpenAlertView * openAlert;
@property (nonatomic, strong) UIButton *investBtn;//立即投资button

@end

@implementation PlanSettingVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:self.title];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    //创建悬停的底层View
    [self CreateBottomView];
    //请求数据
    [self serviceData];
    //获取加密因子和密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
}
- (void)onClickLeftItem{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight-KSafeBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 24*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        _tableView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight/2);
        _tableView.bounces = NO;
        
        [_tableView registerClass:[PlanHeaderCell class] forCellReuseIdentifier:@"PlanHeaderCell"];
        [_tableView registerClass:[PlanCenterCell class] forCellReuseIdentifier:@"PlanCenterCell"];
        [_tableView registerClass:[PlanBottomCell class] forCellReuseIdentifier:@"PlanBottomCell"];
    }
    
    return _tableView;
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
 *请求数据
 */
- (void)serviceData{
    //查询单个理财计划内容
    [DownLoadData postGetOneById:^(id obj, NSError *error) {
        _planSetModel = [[PlanSetModel alloc] initWithDictionary:obj[@"ret"]];
        //起投金额
        self.planMinLimit = [NSString stringWithFormat:@"%@", obj[@"ret"][@"planMinLimit"]];
        
        if(_planSetModel.planAmount.doubleValue == 0){
            _investBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            _investBtn.userInteractionEnabled = NO;
        }
        
        [self.tableView reloadData];
        
    } planId:self.planId];
}
/**
 *开放额度标签
 */
- (UILabel *)openLabel{
    if(!_openLabel){
        _openLabel = [[UILabel alloc] init];
        _openLabel.textColor = UIColorFromRGB(0x525252);
        _openLabel.text = @"1111111.11";
        _openLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _openLabel;
}
/**
 *剩余额度标签
 */
- (UILabel *)restLabel{
    if(!_restLabel){
        _restLabel = [[UILabel alloc] init];
        _restLabel.textColor = UIColorFromRGB(0x525252);
        _restLabel.text = @"2222111.11";
        _restLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _restLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PlanHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanHeaderCell"];
        cell.model = _planSetModel;
        
        return cell;
    }else if (indexPath.section == 1){
        NSArray *textArr = @[@"开放额度", @"剩余额度"];
        NSString *str = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        cell.textLabel.text = textArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        cell.textLabel.textColor = UIColorFromRGB(0x9C9B9B);
        cell.detailTextLabel.text = @"元";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x9c9b9b);
        if (_planSetModel.planAmount.integerValue > 99999999) {
            //开放额度不限
            self.restLabel.text = @"不限";
            cell.detailTextLabel.text = @"";
            //剩余额度不限
            self.openLabel.text = @"不限";
            cell.detailTextLabel.text = @"";
        }else{
            self.restLabel.text = [NSString stringWithFormat:@"%.2f", _planSetModel.planBlance.doubleValue];
            self.openLabel.text = [NSString stringWithFormat:@"%.2f", _planSetModel.planAmount.doubleValue];
        }
        if (indexPath.row) {
            [cell.contentView addSubview:self.restLabel];
            [self.restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-60*m6Scale);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
        }else{
            [cell.contentView addSubview:self.openLabel];
            [self.openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-60*m6Scale);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            }];
        }
        
        return cell;
    }else if (indexPath.section == 2){
        _cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCenterCell"];
        _cell.textFiled.placeholder = self.planMinLimit;//起投金
        if (_planSetModel.planBlance.doubleValue && _planSetModel.planAmount.doubleValue) {
            _cell.textFiled.userInteractionEnabled = YES;
        }else{
            _cell.textFiled.userInteractionEnabled = NO;
        }
        
        return _cell;
    }else{
        PlanBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanBottomCell"];
        [cell cellForModel:@"锁投加息是为投资人提供期限内本金自动循环投资的锁投加息，由系统为投资人自动按月投资，利息将根据锁定期限的不同进行加息。投资人在锁定后资金处于冻结状态，待标的匹配完成后，系统将投资人资金从其存管账户投至借款人存管账户，资金流向均在银行存管下安全透明。到期回款在锁定期内将自动复投，充分提高资金的利用效率。"];
        
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 300*m6Scale;
    }else if (indexPath.section == 2){
        return 182*m6Scale;
    }else if (indexPath.section == 1){
        return 138*m6Scale/2;
    }else{
        return 464*m6Scale-64;
    }
}
/**
 *创建悬停的底层View
 */
- (void)CreateBottomView{
    //灰色背景
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = backGroundColor;
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-64-KSafeBarHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64*m6Scale);
    }];
    //协议图标
    _delegateBtn = [UIButton buttonWithType:0];
    [_delegateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_delegateBtn setImage:[UIImage imageNamed:@"wei."] forState:0];
    [_delegateBtn setImage:[UIImage imageNamed:@"xuan."] forState:UIControlStateSelected];
    _delegateBtn.selected = YES;
    [topView addSubview:_delegateBtn];
    [_delegateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30*m6Scale);
        make.centerY.mas_equalTo(topView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(26*m6Scale, 26*m6Scale));
    }];
    //协议标签
    UILabel *label = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"《锁投加息协议》" addSubView:topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(planProtocal)];
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:tap];
    label.textColor = UIColorFromRGB(0x9c9c9c);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_delegateBtn.mas_right).offset(10*m6Scale);
        make.centerY.mas_equalTo(topView.mas_centerY);
    }];
    //底部View
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(64+KSafeBarHeight);
    }];
    //立即锁投按钮
    _investBtn = [UIButton buttonWithType:0];
    [_investBtn setTitle:@"立即锁投" forState:0];
    _investBtn.titleLabel.font = [UIFont systemFontOfSize:36*m6Scale];
    _investBtn.backgroundColor = ButtonColor;
    [_investBtn addTarget:self action:@selector(AtOnceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _investBtn.layer.cornerRadius = 5*m6Scale;
    _investBtn.layer.masksToBounds = YES;
    [bottomView addSubview:_investBtn];
    [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80*m6Scale);
        make.right.mas_equalTo(-80*m6Scale);
        make.centerY.mas_equalTo(bottomView.mas_centerY).offset(-KSafeBarHeight/2);
        make.height.mas_equalTo(90*m6Scale);
    }];
}
/**
 *协议图标
 */
- (void)buttonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
}
/**
 *planProtocal
 */
- (void)planProtocal{
    ProtocolVC *protocol = [ProtocolVC new];
    self.protocol = @"0";
    protocol.strTag = @"4";
    [self presentViewController:protocol animated:YES completion:nil];
}
//接口
- (void)sxyRecharge:(NSNotification *)noti{
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    self.passWord = noti.userInfo[@"passWord"];
    //验证通过
    self.rechargeView.hidden = YES;
    self.rechargeView.styleLabel.text = @"";
    self.rechargeView.amountLabel.text = @"";
    [self.rechargeView.myTextFiled resignFirstResponder];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //用户购买理财计划
    [DownLoadData postBuyPlan:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            [self alterSuccess];
        }else{
//            [hud setHidden:YES];
            //失败提示错误信息
            if ([obj[@"messageText"] isEqualToString:@"密码错误"]) {
                [self alterUserPswError];
            }else{
                [self alertErrorMessage:obj[@"messageText"]];
                self.rechargeView.myTextFiled.text = @"";
//                [hud setHidden:YES];
            }
        }
    } userId:[HCJFNSUser stringForKey:@"userId"] planId:self.planId amount:_cell.textFiled.text password:self.passWord salt:mcryptKey];
}
/**
 *提示成功
 */
- (void)alterSuccess{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"锁投加息设置成功" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *提示用户交易密码输入错误
 */
- (void)alterUserPswError{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您输入的交易密码错误" preferredStyle:UIAlertControllerStyleAlert];
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
/**
 错误信息提示
 */
- (void)alertErrorMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *立即锁投按钮
 */
- (void)AtOnceButtonClick{
    if (_delegateBtn.selected) {
        NSLog(@"立即锁投按钮");
        //校验用户是否登录
        if ([HCJFNSUser stringForKey:@"userId"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //检验用户是否实名
            [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                //首先根据realnameStatus该字段判断用户是否实名过
                NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                if (status.integerValue) {
                    //用户实名过  判断他是否绑过卡
                    [DownLoadData postBankMessage:^(id obj, NSError *error) {
                        [hud hideAnimated:YES];
                        NSString *result = obj[@"result"];
                        if ([result isEqualToString:@"success"]) {
                            NSLog(@"%ld", self.planMinLimit.integerValue);
                            if (_cell.textFiled.text.floatValue < self.planMinLimit.integerValue) {
                                [Factory alertMes:[NSString stringWithFormat:@"起投金额%ld元", self.planMinLimit.integerValue]];
                            }else{
                                //验证通过
                                self.rechargeView.hidden = NO;
                                self.rechargeView.styleLabel.text = @"";
                                self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", _cell.textFiled.text.floatValue];
                                [self.rechargeView.myTextFiled becomeFirstResponder];
                                
                                [self.view endEditing:YES];
                            }
                        }else {
                            //提示用户去绑卡
                            [self alertWithUserName:realName];
                        }
                    } userId:[HCJFNSUser objectForKey:@"userId"]];
                }else{
                    [hud hideAnimated:YES];
                    //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                    NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                    NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                    //提示实名
                    [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
//                    [hud hideAnimated:YES];//HUD
//                    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    }]];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                        ScanIdentityVC *tempVC = [ScanIdentityVC new];
//                        tempVC.userName = realName;//用户名字
//                        tempVC.identifyCard = identifyCard;//用户身份证号
//                        tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
//                        [self.navigationController pushViewController:tempVC animated:YES];
//                    }]];
//                    
//                    [self presentViewController:alert animated:YES completion:nil];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
//            if (_cell.textFiled.text.integerValue < 1000) {
//                [Factory alertMes:@"1000元起投"];
//            }else{
//                [self successViewShowAction];//蒙版显示
//                [self.textField becomeFirstResponder];
//                [self sendVaildPhoneCode];//验证码
//                [TimeOut timeOut:self.passwordView.reSendButton]; //倒计时
//            }
        }else{
            //用户未登录 提示用户去登陆
            [self alterUserLogin];
        }
    }else{
        [Factory alertMes:@"请先同意协议"];
    }
}
/**
 是否绑卡提示
 */
- (void)alertWithUserName:(NSString *)userName{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转至绑定银行卡页面
        BidCardFirstVC *tempVC = [BidCardFirstVC new];
        tempVC.userName = userName;//用户姓名
        [self.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *用户未登录 提示用户去登陆
 */
- (void)alterUserLogin{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NewSignVC *signVC = [[NewSignVC alloc] init];
        signVC.presentTag = @"2";
        [self presentViewController:signVC animated:YES completion:nil];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_cell.textFiled resignFirstResponder];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    //隐藏导航栏的分割线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [Factory hidentabar];
}

@end
