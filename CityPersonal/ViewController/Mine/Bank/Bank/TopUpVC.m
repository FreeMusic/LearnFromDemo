//
//  TopUpVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TopUpVC.h"
#import "BindCradVC.h"
#import "HelpTableViewController.h"
#import "TopWithDrawalVC.h"
#import "PasswordTextField.h"
#import "ActivityVC.h"
#import "BidCardFirstVC.h"
#import "TopUpView.h"
#import "BankListModel.h"
#import "RechargeView.h"
#import "DealPswVC.h"
#import "TopUpCell.h"
#import "ActivityCenterVC.h"
#import "LargeAmountRechangeVC.h"

@interface TopUpVC ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PasswordTextField *moneyText;//充值金额
@property (nonatomic, copy) NSString *remainCount; //可用余额
@property (nonatomic, strong) UILabel *accountLabel; //可用余额label
@property (nonatomic, strong) UILabel *moneyLabel; //充值金额字样
@property (nonatomic, copy) NSString *bankNumStr; //银行卡号
@property (nonatomic, copy) NSString *bankInmageName;//银行图片名称
@property (nonatomic ,strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *topupRecordButton;//充值记录
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, copy) NSString *bankCode; //银行简称
@property (nonatomic, strong) UILabel *nowDayLab;//当天
@property (nonatomic, strong) UILabel *mouthDayLab;//当月
@property (nonatomic, strong) UILabel *singleLab;//单笔
@property (nonatomic, strong) UILabel *bankNameLabel;//银行卡名称
@property (nonatomic, strong) UILabel *cardNoLabel;//银行卡号
@property (nonatomic, strong) UITextField *amountFiled;//充值金额输入框
@property (nonatomic, strong) UIButton *nextBtn;//下一步按钮
@property (nonatomic, strong) UIImageView *bankImg;//添加银行卡
@property (nonatomic, strong) TopUpView *topUpView;
@property (nonatomic, strong) NSMutableArray *dataSource;//银行卡信息数据
@property (nonatomic, strong) BankListModel *bankListModel;
@property (nonatomic, strong) UIImage *bankName;//银行卡背景图
@property (nonatomic, assign) NSInteger index;//记录被选中银行卡的下标
@property (nonatomic, strong) RechargeView *rechargeView;//充值提现输入交易密码弹出视图
@property (nonatomic, strong) UIImageView *iconImgView;//银行卡图标
@property (nonatomic, strong) NSString *passWord;//加密后的交易密码
@property (nonatomic, strong) NSString *bankId;//银行卡ID
@property (nonatomic, assign) BOOL move;
@property (nonatomic, assign) NSInteger isRechargeDefault;//首先判断用户isRechargeDefault字段是否有1的
@property (nonatomic, strong) NSMutableArray *payArr;//支付公司

@property (nonatomic, assign) NSInteger selected;//支付公司默认选中的下标

@property (nonatomic, assign) NSInteger isDefault;//首先判断用户isDefault字段是否有1的

@property (nonatomic, strong) NSString *paymentId;//支付公司ID

@property (nonatomic, strong) TopUpModel *topUpModel;

@end

@implementation TopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = backGroundColor;
    
    //获取用户银行卡列表
    [self getBankList];
    //获取加密因子和密码
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxyRecharge:) name:@"sxyRecharge" object:nil];
    _move = YES;
    //接受添加银行卡消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sxySkipToBidCard) name:@"sxySkipToBidCard" object:nil];
    //接受选择银行卡信息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseBank:) name:@"chooseBank" object:nil];
    //筛选支付公司
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repayCompany) name:@"getPayCompanyType" object:nil];
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
        _tableView.bounces = NO;
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
- (TopUpView *)topUpView{
    //if(!_topUpView){
        _topUpView = [[TopUpView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        [self.navigationController.view addSubview:_topUpView];
    //}
    return _topUpView;
}
/**
 *银行卡名称
 */
- (UILabel *)bankNameLabel{
    if(!_bankNameLabel){
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.textColor = UIColorFromRGB(0x393939);
        _bankNameLabel.text = @"中国工商银行(2369)";
        _bankNameLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    }
    return _bankNameLabel;
}
/**
 *  支付公司
 */
- (NSMutableArray *)payArr{
    if(!_payArr){
        _payArr = [NSMutableArray array];
    }
    return _payArr;
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
 *添加银行卡按钮
 */
- (UIImageView *)bankImg{
    if(!_bankImg){
        _bankImg  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加银行卡"]]
        ;
        _bankImg.frame = CGRectMake((kScreenWidth-688*m6Scale)/2, 68*m6Scale, 688*m6Scale, 88*m6Scale);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBankCard)];
        _bankImg.userInteractionEnabled = YES;
        [_bankImg addGestureRecognizer:tap];
    }
    return _bankImg;
}
/**
 *银行卡单笔限额
 */
- (UILabel *)cardNoLabel{
    if(!_cardNoLabel){
        _cardNoLabel = [[UILabel alloc] init];
        _cardNoLabel.textColor = UIColorFromRGB(0x848484);
        _cardNoLabel.text = @"银行单笔限额10000.00元";
        _cardNoLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    }
    return _cardNoLabel;
}
/**
 *充值金额输入框
 */
- (UITextField *)amountFiled{
    if(!_amountFiled){
        _amountFiled = [[UITextField alloc] init];
        _amountFiled.placeholder = @"请输入充值金额";
        _amountFiled.delegate = self;
        _amountFiled.textColor = UIColorFromRGB(0x4a4a4a);
        _amountFiled.font = [UIFont systemFontOfSize:34*m6Scale];
        [_amountFiled addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        _amountFiled.keyboardType = UIKeyboardTypeNumberPad;
        _amountFiled.keyboardType = UIKeyboardTypeDecimalPad;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        
        _amountFiled.inputAccessoryView = clip;
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        [_amountFiled setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _amountFiled;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
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
 *下一步按钮点击
 */
- (UIButton *)nextBtn{
    if(!_nextBtn){
        _nextBtn = [Factory ButtonWithTitle:@"确认充值" andTitleColor:UIColorFromRGB(0x8c8c8c) andButtonbackGroundColor:UIColorFromRGB(0xdbdbdb) andCornerRadius:8 addTarget:self action:@"nextButtonClick"];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return _nextBtn;
}
/**
 *获取选择银行卡的信息
 */
- (void)chooseBank:(NSNotification *)noti{
    _bankListModel = noti.userInfo[@"model"];
    //银行卡图标
    self.bankName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _bankListModel.bankIcon]]]];
    //银行卡Id
    self.bankId = [NSString stringWithFormat:@"%@", _bankListModel.ID];
    NSString *index = noti.userInfo[@"index"];
    _index = index.intValue;
    
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4+self.payArr.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        self.iconImgView.image = self.bankName ;
        [cell.contentView addSubview:self.iconImgView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *cardNum = [NSString stringWithFormat:@"%@", _bankListModel.cardNo];
        if (cardNum.length>4) {
            self.bankNameLabel.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@", _bankListModel.bankName]];
        }
        if ([_bankListModel.bankName containsString:@"("]) {
            NSString *text =[_bankListModel.bankName componentsSeparatedByString:@"("][0];
            self.bankNameLabel.text = [NSString stringWithFormat:@"%@",text];
        }
        //银行卡名称
        // self.bankNameLabel.text = [NSString stringWithFormat:@"%@", _bankListModel.bankName];
        [cell.contentView addSubview:self.bankNameLabel];
        [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(116*m6Scale);
            make.top.mas_equalTo(18*m6Scale);
        }];
        //银行卡号
        self.cardNoLabel.text = [NSString stringWithFormat:@"尾号%@储蓄卡", [cardNum substringFromIndex:cardNum.length-4]];
        [cell.contentView addSubview:self.cardNoLabel];
        [self.cardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(116*m6Scale);
            make.bottom.mas_equalTo(-10*m6Scale);
        }];
        
        return cell;
        
    }else if (indexPath.row == 1){
        
        NSString *str = @"tableView";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        cell.backgroundColor = backGroundColor;
        cell.textLabel.text = @"选择支付公司";
        cell.textLabel.textColor = UIColorFromRGB(0x727272);
        cell.textLabel.font = [UIFont systemFontOfSize:26*m6Scale];
        
        return cell;
    }else if (indexPath.row < 2+self.payArr.count){
        
        NSString *str = @"tableView";
        TopUpCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[TopUpCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }

        [cell cellForModel:self.payArr[indexPath.row - 2] andSelected:_selected andIndexPath:indexPath];
        
        return cell;
        
    }
    else{
        NSString *reuse = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        cell.selectionStyle = NO;
        if (indexPath.row == 2+self.payArr.count) {
            cell.backgroundColor = backGroundColor;
        }else{
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = @"金额";
            cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
            cell.textLabel.textColor = UIColorFromRGB(0x474343);
            [cell.contentView addSubview:self.amountFiled];
            [self.amountFiled mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.textLabel.mas_right).offset(25*m6Scale);
                make.right.top.bottom.mas_equalTo(0);
            }];
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 106*m6Scale;
    }else if (indexPath.row == 1){
        return 72*m6Scale;
    }else if (indexPath.row == 2+self.payArr.count){
        return 30*m6Scale;
    }
    else{
        return 106*m6Scale;
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
    //单线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [footerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nextBtn.mas_bottom).offset(62.5*m6Scale);
        make.centerX.mas_equalTo(footerView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(1, 25*m6Scale));
    }];
    
    //大额充值按钮 和  支持银行按钮
    NSArray *array = @[@"大额充值", @"支持银行"];
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        [btn setTitle:array[i] forState:0];
        [btn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
        btn.tag = 9999+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:30*m6Scale];
        [btn addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130*m6Scale, 50*m6Scale));
            make.top.mas_equalTo(self.nextBtn.mas_bottom).offset(50*m6Scale);
            if (i) {
                make.left.mas_equalTo(line.mas_right).mas_equalTo(20*m6Scale);
            }else{
                make.right.mas_equalTo(line.mas_left).offset(-20*m6Scale);
            }
        }];
    }
    
    
    return footerView;
}
/**
 *  大额充值按钮  和  支持银行按钮的点击事件
 */
- (void)bottomButtonClick:(UIButton *)sender{
    if (sender.tag == 9999) {
        LargeAmountRechangeVC *tempVC = [LargeAmountRechangeVC new];
        tempVC.bankIconImage = self.bankName;//银行卡图标
        NSString *cardNum = [NSString stringWithFormat:@"%@", _bankListModel.cardNo];
        NSString *bankName = [NSString stringWithFormat:@"%@(尾号%@)", self.bankNameLabel.text, [cardNum substringFromIndex:cardNum.length-4]];
        tempVC.bankName = bankName;//银行卡名称描述
        tempVC.userName = self.userName;
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        ActivityCenterVC *tempVC = [ActivityCenterVC new];
        tempVC.tag = 10;
        tempVC.strUrl = @"/html/banks.html";
        tempVC.urlName = @"支持银行";
        [self.navigationController pushViewController:tempVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 300*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.amountFiled resignFirstResponder];
        self.topUpView.hidden = NO;
        NSLog(@"**%@",self.dataSource);
        [_topUpView viewWithModel:self.dataSource andIndex:_index];
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat height = 90*m6Scale*self.dataSource.count+104*m6Scale+84*m6Scale;
            if (height < kScreenHeight*0.6) {
                _topUpView.backView.frame = CGRectMake(0, kScreenHeight-height-KSafeBarHeight, kScreenWidth, height);
            }else{
                _topUpView.backView.frame = CGRectMake(0, kScreenHeight-kScreenHeight*0.6-KSafeBarHeight, kScreenWidth, kScreenHeight*0.6);
            }
        } completion:^(BOOL finished) {
            _topUpView.btn.hidden = NO;
        }];
    }else if (indexPath.row < 2+self.payArr.count && indexPath.row > 1){
        
        _selected = indexPath.row+100-2;
        [self.tableView reloadData];
        
        _topUpModel = self.payArr[indexPath.row-2];
        
        self.paymentId = [NSString stringWithFormat:@"%@", _topUpModel.paymentId];
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
        if(textFiled.text.doubleValue < _topUpModel.singleLimitAmount.doubleValue){
            
        }else{
            if (textFiled.text.doubleValue > _topUpModel.singleLimitAmount.doubleValue) {
                [Factory alertMes:@"您输入的金额已超出银行单笔限额"];
            }
            textFiled.text = [NSString stringWithFormat:@"%d", _topUpModel.singleLimitAmount.intValue];
        }
        self.nextBtn.selected = YES;
        self.nextBtn.buttonWhetherClick = ButtonCanClick;
    }else{
        self.nextBtn.buttonWhetherClick = ButtonCanNotClickWithGray;
        self.nextBtn.selected = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [Factory textField:textField shouldChangeCharactersInRange:range replacementString:string];
}
/**
 *下一步按钮的点击事件
 */
- (void)nextButtonClick{
    if (self.nextBtn.selected) {
        if ([_topUpModel.singleLimitAmount doubleValue]>[self.amountFiled.text doubleValue]||[_topUpModel.singleLimitAmount doubleValue]==[self.amountFiled.text doubleValue]) {
            self.rechargeView.hidden = NO;
            self.rechargeView.amountLabel.text = [NSString stringWithFormat:@"￥%.2f", self.amountFiled.text.floatValue];
            [self.rechargeView.myTextFiled becomeFirstResponder];
            
            [self.view endEditing:YES];
        }
        else{
            [Factory alertMes:@"充值金额超限"];
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
    //充值按钮
    [DownLoadData postApplyRecharge:^(id obj, NSError *error) {
        [hud setHidden:YES];
        NSLog(@"%@", obj[@"messageText"]);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            [Factory alertMes:@"充值成功"];
            //反馈成功之后三秒返回到我的界面
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                sleep(1);
                //回到主队列
                dispatch_async(dispatch_get_main_queue(), ^{
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
    } userId:[HCJFNSUser stringForKey:@"userId"] amount:self.amountFiled.text bankId:self.bankId password:self.passWord mcryptKey:mcryptKey paymentId:self.paymentId];
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
 *添加银行卡
 */
- (void)addBankCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.userName = self.userName;//用户的真实姓名
    tempVC.index = 5;
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  右边的按钮,跳到充值记录
 */
- (void)onClickRightItem
{
    TopWithDrawalVC *topWith = [TopWithDrawalVC new];
    topWith.tag = @"0";
    [self.navigationController pushViewController:topWith animated:YES];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];//导航的处理
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
}
/** 
 *获取用户银行卡列表
 */
- (void)getBankList{
    //用户银行卡列表
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [DownLoadData postGetListByUserId:^(id obj, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.dataSource removeAllObjects];
        self.dataSource = obj[@"SUCCESS"];
        if (self.dataSource.count) {
            [self.view addSubview:self.tableView];
            //标题
            [TitleLabelStyle addtitleViewToVC:self withTitle:@"充值"];
            //右边按钮(充值记录)
            UIButton *recordBtn = [Factory addRightbottonToVC:self andrightStr:@"充值记录"];
            [recordBtn addTarget:self action:@selector(onClickRightItem) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //标题
            [TitleLabelStyle addtitleViewToVC:self withTitle:@"添加银行卡"];
            [self.view addSubview:self.bankImg];
        }
        //首先判断用户isRechargeDefault字段是否有1的
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BankListModel *model = self.dataSource[idx];
            if (model.isRechargeDefault.integerValue) {
                _bankListModel = model;
                _index = idx;
                self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
                _isRechargeDefault = 100;
                
                *stop = YES;
            }
        }];
        if (_isRechargeDefault == 0) {
            //没有1的  就优先找一个isRechargeDefault字段是0的
            [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BankListModel *model = self.dataSource[idx];
                if (model.isRechargeDefault.integerValue == 0) {
                    _bankListModel = model;
                    _index = idx;
                    self.bankId  = [NSString stringWithFormat:@"%@", model.ID];
                    
                    *stop = YES;
                }
            }];
        }
        //银行卡图标
        self.bankName = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _bankListModel.bankIcon]]]];
        //根据BankId获取支付公司
        [self repayCompany];
        
        NSLog(@"%@", _bankListModel.description);
        
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  获取支付公司
 */
- (void)repayCompany{
    
    [DownLoadData postGetSupportBankLimit:^(id obj, NSError *error) {
        
        [self.payArr removeAllObjects];
        
        self.payArr = obj;
        
        //首先判断用户isRechargeDefault字段是否有1的
        [self.payArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _topUpModel = self.payArr[idx];
            if (_topUpModel.isDefault.integerValue) {
                _selected = idx+100;
                
                _isDefault = 100;
                
                self.paymentId = [NSString stringWithFormat:@"%@", _topUpModel.paymentId];
                
                *stop = YES;
            }
        }];
        if (_isDefault == 0) {
            //没有1的  就优先找一个isRechargeDefault字段是0的
            [self.payArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                _topUpModel = self.payArr[idx];
                if (_topUpModel.isDefault.integerValue == 0) {
                    
                    _selected = idx+100;
                    
                    self.paymentId = [NSString stringWithFormat:@"%@", _topUpModel.paymentId];
                    
                    *stop = YES;
                }
            }];
        }
        
        [self.tableView reloadData];

    } bankId:self.bankId];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
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

- (void)dealloc {
    
    _tableView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/**
 *跳转至绑银行卡界面
 */
- (void)sxySkipToBidCard{
    BidCardFirstVC *tempVC = [BidCardFirstVC new];
    tempVC.index = 1;
    tempVC.userName = self.userName;//用户的真实姓名
    [self.navigationController pushViewController:tempVC animated:YES];
}

@end
