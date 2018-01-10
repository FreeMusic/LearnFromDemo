//
//  WithdrawalVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "WithdrawalVC.h"
#import "BindCradVC.h"
#import "HelpTableViewController.h"
#import "TopWithDrawalVC.h"
#import "PasswordTextField.h"
#import "ActivityVC.h"
#import "WithdrawalCell.h"
#import "BidCardFirstVC.h"
#import "BankListVC.h"
#import "RechargeView.h"
#import "BankListModel.h"
#import "DealPswVC.h"

@interface WithdrawalVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *bankNum;//银行卡号
@property (nonatomic, strong) PasswordTextField *moneyText;//提现金额
@property (nonatomic, strong) UILabel *accountLabel; //账户余额
@property (nonatomic, copy) NSString *remainAccount; //账户余额
@property (nonatomic, copy) NSString *bankInmageName;//银行图片名称
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *withDrawalBtn;//全部提现按钮
@property (nonatomic, strong) UIButton *topupRecordButton; //提现记录
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) UIButton *nextBtn;//下一步按钮
@property (nonatomic, strong) UILabel *bankNameLabel;//银行卡名称
@property (nonatomic, strong) UILabel *cardNoLabel;//银行卡号
@property (nonatomic, strong) UIImageView *bankImg;//添加银行卡
@property (nonatomic, strong) RechargeView *rechargeView;
@property (nonatomic, strong) WithdrawalCell *cell;
@property (nonatomic, strong) NSString *passWord;//交易密码
@property (nonatomic, strong) NSString *bankId;//银行ID
@property (nonatomic, strong) NSMutableArray *dataSource;//银行卡信息数据
@property (nonatomic, strong) BankListModel *bankListModel;
@property (nonatomic, assign) NSInteger index;//记录被选中银行卡的下标
@property (nonatomic, strong) UIImage *bankName;//银行卡背景图
@property (nonatomic, strong) UIImageView *iconImgView;//银行卡图标
@property (nonatomic, strong) NSString *restStr;//剩余金额
@property (nonatomic, assign) NSInteger bankIndex;//记录用户选择银行卡的下标
@property (nonatomic, assign) NSInteger isRechargeDefault;//首先判断用户isRechargeDefault字段是否有1的
@property (nonatomic, copy) NSString *accessMoney;//可用余额
@end

@implementation WithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
    //接受选择银行卡信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseBank:) name:@"chooseWithdrawalBank" object:nil];
    //刷新银行卡列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBankList) name:@"refreshBankList" object:nil];
    //获取银行列表
    [self getBankList];
    
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = backGroundColor;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = NO;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        //盾牌以及文字描述
        [self wordCharactor];
    }
    return _tableView;
}
/**
 * 盾牌以及文字描述
 */
- (void)wordCharactor{
    //文字
    UILabel *safeLab = [UILabel new];
    safeLab.text = @"浙江民泰商业银行存管保护资金安全";
    safeLab.textColor = [UIColor lightGrayColor];
    safeLab.font = [UIFont systemFontOfSize:30*m6Scale];
    [self.tableView addSubview:safeLab];
    [safeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView.mas_centerX);
        make.top.equalTo(kScreenHeight-30*m6Scale-NavigationBarHeight-KSafeBarHeight);
    }];
    //盾牌
    UIImageView *safeImage = [[UIImageView alloc]init];
    safeImage.image = [UIImage imageNamed:@"anquan@2x(1)"];
    [self.tableView addSubview:safeImage];
    [safeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(safeLab.mas_left).offset(-10*m6Scale);
        make.top.equalTo(kScreenHeight-30*m6Scale-NavigationBarHeight-KSafeBarHeight);
        make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
    }];
}
/**
 *添加银行卡按钮
 */
- (UIImageView *)bankImg{
    if(!_bankImg){
        _bankImg  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加银行卡"]]
        ;
        _bankImg.frame = CGRectMake((kScreenWidth-688*m6Scale)/2, 68*m6Scale+64, 688*m6Scale, 88*m6Scale);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBankCard)];
        _bankImg.userInteractionEnabled = YES;
        [_bankImg addGestureRecognizer:tap];
    }
    return _bankImg;
}
/**
 *银行卡名称
 */
- (UILabel *)bankNameLabel{
    if(!_bankNameLabel){
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.textColor = UIColorFromRGB(0x393939);
        _bankNameLabel.text = @"中国工商银行";
        _bankNameLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _bankNameLabel;
}
/**
 *银行卡图标
 */
- (UIImageView *)iconImgView{
    if(!_iconImgView){
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20*m6Scale, 13*m6Scale, 80*m6Scale, 80*m6Scale)];
    }
    return _iconImgView;
}
/**
 *银行卡单笔限额
 */
- (UILabel *)cardNoLabel{
    if(!_cardNoLabel){
        _cardNoLabel = [[UILabel alloc] init];
        _cardNoLabel.textColor = UIColorFromRGB(0x848484);
        _cardNoLabel.text = @"尾号6666储蓄号";
        _cardNoLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    return _cardNoLabel;
}
/**
 *获取选择银行卡的信息
 */
- (void)chooseBank:(NSNotification *)noti{
    //被选中银行卡的下标
    NSString *index = noti.userInfo[@"index"];
    _index = index.integerValue;
    _bankListModel = noti.userInfo[@"model"];
    //银行卡图标
    self.bankName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _bankListModel.bankIcon]]]];
    //银行卡Id
    self.bankId = [NSString stringWithFormat:@"%@", _bankListModel.ID];
    
    [self.tableView reloadData];
}
/**
 *添加银行卡
 */
- (void)addBankCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.userName = self.userName;//用户姓名
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *下一步按钮点击
 */
- (UIButton *)nextBtn{
    if(!_nextBtn){
        _nextBtn = [UIButton buttonWithType:0];
        [_nextBtn setTitle:@"确认提现" forState:0];
        [_nextBtn setTitleColor:UIColorFromRGB(0x8c8c8c) forState:0];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_nextBtn setBackgroundColor:UIColorFromRGB(0xdbdbdb)];
        _nextBtn.layer.cornerRadius = 8*m6Scale;
        
        [_nextBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}
/**
 *充值提现输入交易密码弹出视图
 */
- (RechargeView *)rechargeView{
    if(!_rechargeView){
        _rechargeView = [[RechargeView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _rechargeView.styleLabel.text = @"提现";
        
        [[UIApplication sharedApplication].keyWindow addSubview:_rechargeView];
    }
    return _rechargeView;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [Factory textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row) {
        NSString *reuse = @"UITableViewCell";
        _cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!_cell) {
            _cell = [[WithdrawalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        _cell.textFiled.delegate = self;
        [_cell.textFiled addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        _cell.restLabel.text = self.restStr;
        [_cell.drawAllBtn addTarget:self action:@selector(drawAllMoney:) forControlEvents:UIControlEventTouchUpInside];
        return _cell;
    }else{
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        [cell.contentView addSubview:self.iconImgView];
        self.iconImgView.image = self.bankName;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //银行卡名称
        [cell.contentView addSubview:self.bankNameLabel];
        //银行名称
        self.bankNameLabel.text = [NSString stringWithFormat:@"%@", _bankListModel.bankName];
        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(116*m6Scale);
            make.top.mas_equalTo(18*m6Scale);
        }];
        //银行卡号
        
        [cell.contentView addSubview:self.cardNoLabel];
        NSString *cardNum = [NSString stringWithFormat:@"%@",_bankListModel.cardNo];
        if(cardNum.length>4){
            self.cardNoLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡", [cardNum substringFromIndex:cardNum.length-4]];
        }
        
        [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(116*m6Scale);
            make.bottom.mas_equalTo(-10*m6Scale);
        }];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 106*m6Scale;
    }else{
        return 280*m6Scale;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = backGroundColor;
    [footerView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25*m6Scale);
        make.right.mas_equalTo(-25*m6Scale);
        make.top.mas_equalTo(60*m6Scale);
        make.height.mas_equalTo(90*m6Scale);
    }];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        BankListVC *tempVC = [BankListVC new];
        tempVC.dataSource = self.dataSource;//数据数组
        tempVC.userName = self.userName;
        tempVC.index = _index;
        tempVC.bankIndex = 5;
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
- (void)drawAllMoney:(UIButton *)btn{
    if (self.accessMoney.doubleValue) {
        if (self.accessMoney.doubleValue > 50000) {
            _cell.textFiled.text = [NSString stringWithFormat:@"50000.00"];
        }else{
            _cell.textFiled.text = [NSString stringWithFormat:@"%.2f",[self.accessMoney doubleValue]];
        }
        [self textChanged:_cell.textFiled];
    }else{
        [Factory alertMes:@"您的金额为0"];
    }
}
/**
 *监听文字输入的改变
 */
- (void)textChanged:(UITextField *)textFiled{
    //当用户输入的金额第一位是0
    if (textFiled.text.length > 1 && [textFiled.text hasPrefix:@"0"] && textFiled.text.doubleValue >= 1) {
        NSArray *array = [textFiled.text componentsSeparatedByString:@"0"];
        if ([[array lastObject] isEqualToString:@"0"]) {
            textFiled.text = @"0";
        }else if ([[array lastObject] intValue]){
            textFiled.text = [array lastObject];
        }
    }else if (textFiled.text.length > 1 && textFiled.text.doubleValue == 0.00){
        if ([textFiled.text containsString:@"."]) {
            
        }else{
            textFiled.text = @"0";
        }
    }
    
    if (textFiled.text.doubleValue) {
        if (textFiled.text.doubleValue > 50000) {
            textFiled.text = @"50000.00";
        }
        self.nextBtn.selected = YES;
        self.nextBtn.buttonWhetherClick = ButtonCanClick;
    }else{
        self.nextBtn.buttonWhetherClick = ButtonCanNotClickWithGray;
        self.nextBtn.selected = NO;
    }
}
/**
 *下一步按钮的点击事件
 */
- (void)nextButtonClick{
    if (self.nextBtn.selected) {
        if([self.accessMoney doubleValue]>[_cell.textFiled.text doubleValue]||[self.accessMoney doubleValue]==[_cell.textFiled.text doubleValue]){
            if ([_cell.textFiled.text doubleValue]>50000) {
                [Factory alertMes:@"提现金额超限"];
            }else{
                self.rechargeView.hidden = NO;
                self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", _cell.textFiled.text.doubleValue];
                [self.rechargeView.myTextFiled becomeFirstResponder];
                
                [self.view endEditing:YES];
            }
        }
        else{
            [Factory alertMes:@"提现金额大于可用余额"];
        }
    }
}
- (void)sxyRecharge:(NSNotification *)noti{
    NSString *mcryptKey = noti.userInfo[@"mcryptKey"];
    self.passWord = noti.userInfo[@"passWord"];
    self.rechargeView.hidden = YES;
    self.rechargeView.myTextFiled.text = @"";
    [self.rechargeView.myTextFiled resignFirstResponder];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //提现接口
    [DownLoadData postWithdraw:^(id obj, NSError *error) {
        NSLog(@"%@", obj[@"messageText"]);
        [hud setHidden:YES];
        if ([obj[@"result"] isEqualToString:@"success"]) {
            [Factory alertMes:@"提现成功"];
            //成功之后三秒返回到我的界面
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                sleep(1);
                //回到主队列
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.rechargeView.hidden = YES;
                    self.rechargeView.myTextFiled.text = @"";
                    [self.rechargeView.myTextFiled resignFirstResponder];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            });
        }else{
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
        }
    } userId:[HCJFNSUser stringForKey:@"userId"] cashAmount:_cell.textFiled.text bankId:self.bankId password:self.passWord mcryptKey:mcryptKey routeFlag:@"0"];
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
 *  返回
 */
- (void)onClickLeftItem
{
    if (_skipFrom == VCSkipFrom_FaceAuthent) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  提现记录
 */
- (void)onClickRightItem
{
    TopWithDrawalVC *topWith = [TopWithDrawalVC new];
    topWith.tag = @"1";
    [self.navigationController pushViewController:topWith animated:YES];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
}
//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];//导航的处理
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    //_tableView.contentInset = UIEdgeInsetsMake(-64-25, 0, 0, 0);
}
/**
 *获取用户银行卡列表
 */
- (void)getBankList{
    //用户银行卡列表
    [DownLoadData postGetListByUserId:^(id obj, NSError *error) {
        self.dataSource = obj[@"SUCCESS"];
        if (self.dataSource.count) {
            [self.view addSubview:self.tableView];
            //标题
            [TitleLabelStyle addtitleViewToVC:self withTitle:@"提现"];
            //右边按钮(充值记录)
            UIButton *recordBtn = [Factory addRightbottonToVC:self andrightStr:@"提现记录"];
            [recordBtn addTarget:self action:@selector(onClickRightItem) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //标题
            [TitleLabelStyle addtitleViewToVC:self withTitle:@"添加银行卡" ];
            [self.view addSubview:self.bankImg];
        }
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BankListModel *model = self.dataSource[idx];
            if (model.isCashDefault.integerValue) {
                _bankListModel = model;
                _index = idx;
                self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
                _isRechargeDefault = 100;
                
                return;
            }
        }];
        if (_isRechargeDefault == 0) {
            //没有1的  就优先找一个isRechargeDefault字段是0的
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BankListModel *model = self.dataSource[idx];
                if (model.isCashDefault.integerValue == 0) {
                    _bankListModel = model;
                    _index = idx;
                    self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
                    
                    return;
                }
            }];
        }
        self.bankName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _bankListModel.bankIcon]]]];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //查询用户可用余额
    [DownLoadData postAccountPage:^(id obj, NSError *error) {
        //可用余额
        self.accessMoney = [NSString stringWithFormat:@"%@", obj[@"accountUsable"]];
        self.restStr = [NSString stringWithFormat:@"可用余额%.2f元", self.accessMoney.doubleValue];
        NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end
