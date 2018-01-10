//
//  BidCardVC.m
//  CityJinFu
//
//  Created by mic on 2017/7/18.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "BidCardVC.h"
#import "ActivityCenterVC.h"
#import "ProtocolVC.h"

@interface BidCardVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *codeBtn;//获取验证码按钮
@property (nonatomic, strong) NSString *message;//本地随机生成的短信验证码
@property (nonatomic, strong) UIButton *changeBtn;//更换银行卡号按钮
@property (nonatomic, strong) NSString *result;//查询银行卡结果
@property (nonatomic, strong) NSString *messageText;//错误提示信息
@property (nonatomic, assign) BOOL isBankCard;//查询用户是否绑过卡
@property (nonatomic, strong) UIButton *button;//第三方协议同意按钮

@end

@implementation BidCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = Colorful(220, 220, 219);
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //支持银行
    UIButton *rightBtn = [Factory addRightbottonToVC:self andrightStr:@"支持银行"];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"绑定银行卡"];
    
    [self.view addSubview:self.tableView];
    //根据上一个页面传来的银行卡号   查询该银行卡的信息
    //[self queryBankLocation];
}
- (void)onClickLeftItem{     NSLog(@"%ld", _index);
    if (self.isBankCard == NO && [[HCJFNSUser stringForKey:@"bidBankCard"] isEqualToString:@"success"] && _index != 100) {
        //用户第一次绑卡成功之后，发送通知，让个人中心页面弹出风险评估提示框
//        NSNotification *noti = [[NSNotification alloc] initWithName:@"alterUserRiskTest" object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:noti];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if (_index == 1){
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else if (_index == 10 || _index == 100){
        //用户从投资页-扫描身份证-绑卡
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }else if (_index == 20){
        //用户从账户设置页-扫描身份证-绑卡
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else if (_index == 5){
        //刷新银行卡列表
        NSNotification *noti = [[NSNotification alloc] initWithName:@"refreshBankList" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:noti];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
/**
 *支持银行
 */
- (void)rightBtn{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.tag = 10;
    tempVC.strUrl = @"/html/banks.html";
    tempVC.urlName = @"支持银行";
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        //银行卡标志
        [self bankPicture];
    }
    return _tableView;
}
/**
 *  银行卡标志
 */
- (void)bankPicture{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BidBank_cunguan"]];
    [self.tableView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(598*m6Scale, 106*m6Scale));
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.top.mas_equalTo(kScreenHeight-NavigationBarHeight-50*m6Scale-25);
    }];
}
/**
 *获取验证码按钮
 */
- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:0];
        [_codeBtn setTitle:@"获取验证码" forState:0];
        [_codeBtn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    }
    
    return _codeBtn;
}
/**
 *更换银行卡号按钮
 */
- (UIButton *)changeBtn{
    if(!_changeBtn){
        _changeBtn = [UIButton buttonWithType:0];
        [_changeBtn setTitle:@"修改" forState:0];
        [_changeBtn setTitleColor:UIColorFromRGB(0xff5933) forState:0];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        [_changeBtn addTarget:self action:@selector(changeBankCard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}
/**
 *更换银行卡按钮点击事件
 */
- (void)changeBankCard{
    [self.navigationController popViewControllerAnimated:NO];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 3;
    }else{
        return 1;
    }
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = NO;
    NSArray *textArr = @[@"卡号", @"开户银行", @"手机号", @"验证码"];
    NSArray *placeArr = @[ @"请输入银行预留手机号", @"请输入验证码"];
    if (indexPath.section) {
        cell.textLabel.text = textArr[indexPath.row+1];
    }else{
        cell.textLabel.text = textArr[indexPath.section];
        //修改银行卡按钮
        [cell addSubview:self.changeBtn];
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(110*m6Scale);
        }];
    }
    cell.textLabel.textColor = UIColorFromRGB(0x434040);
    cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    UITextField *textFiled;
    textFiled = [[UITextField alloc] init];
    if (indexPath.row) {
        textFiled.placeholder = placeArr[indexPath.row-1];
    }
    if (indexPath.row == 0) {
        textFiled.userInteractionEnabled = NO;
        if (indexPath.section) {
            textFiled.text = self.bankName;
        }
    }else{
        textFiled.textColor = UIColorFromRGB(0x363636);
        textFiled.userInteractionEnabled = YES;
    }
    textFiled.delegate = self;
    [textFiled setValue:UIColorFromRGB(0xB1B0B0) forKeyPath:@"_placeholderLabel.textColor"];
    textFiled.font = [UIFont systemFontOfSize:30*m6Scale];
    if (indexPath.section) {
        textFiled.tag = 1000+indexPath.row;
        if (indexPath.row) {
            textFiled.keyboardType = UIKeyboardTypeNumberPad;
            KeyBoard *key = [[KeyBoard alloc] init];
            UIView *clip = [key keyBoardview];
            textFiled.inputAccessoryView = clip;
            [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        textFiled.text = self.bankNum;
    }
    //    if (textFiled.tag == 1000) {
    //        [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //    }
    [cell addSubview:textFiled];
    [textFiled makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(200*m6Scale);
        make.right.equalTo(-160*m6Scale);
        make.top.bottom.mas_equalTo(0);
    }];
    if (indexPath.section == 1 && indexPath.row == 2) {
        //发送验证码按钮
        [cell.contentView addSubview:self.codeBtn];
        [self.codeBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(160*m6Scale);
        }];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92*m6Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return  200*m6Scale;
    }else{
        return 0.01;
    }
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor clearColor];
        
        //按钮
        _button = [UIButton buttonWithType:0];
        _button.selected = YES;
        [_button setImage:[UIImage imageNamed:@"NewSign_椭圆-4"] forState:0];
        [_button setImage:[UIImage imageNamed:@"NewSign_椭圆-5"] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(30*m6Scale);
            make.size.mas_equalTo(CGSizeMake(22*m6Scale, 22*m6Scale));
        }];
        
        //同意协议标题
        UILabel *titleLabel = [Factory CreateLabelWithTextColor:0.5 andTextFont:28 andText:@"我同意《三方存管协议》" addSubView:footerView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipToRegister)];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tap];
        titleLabel.textColor = UIColorFromRGB(0x8f8f8f);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_button.mas_right).offset(10*m6Scale);
            make.top.mas_equalTo(_button.mas_top).offset(-5*m6Scale);
        }];
        //下一部按钮
        UIButton *nextBtn = [UIButton buttonWithType:0];
        [nextBtn setTitle:@"确认" forState:0];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
        nextBtn.backgroundColor = UIColorFromRGB(0xffb514);
        [nextBtn addTarget:self action:@selector(bidBankCard) forControlEvents:UIControlEventTouchUpInside];
        nextBtn.layer.cornerRadius = 6*m6Scale;
        nextBtn.layer.masksToBounds = YES;
        [footerView addSubview:nextBtn];
        [nextBtn makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(20*m6Scale);
            make.right.equalTo(-20*m6Scale);
            make.top.equalTo(88*m6Scale);
            make.height.equalTo(86*m6Scale);
        }];
        
        return footerView;
    }else{
        return nil;
    }
}

- (void)agreeButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
}

- (void)skipToRegister{
    
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    
    tempVC.tag = 1500;
    tempVC.urlName = @"三方存管协议";
    tempVC.strUrl = @"/html/agreement.html";
    
    [self.navigationController pushViewController:tempVC animated:YES];
}

/**
 *限制银行卡号 和 手机号位数
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 1001){
        //手机号
        if (range.location >= 11) {
            [Factory alertMes:@"手机号码长度不能超过11位"];
            
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}
/**
 *改变行间距
 */
- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
/**
 *  发送验证码
 */
- (void)sendCode{
    //预留手机号输入框
    UITextField *mobileFiled = (UITextField *)[self.view viewWithTag:1001];
    //绑卡验证码申请(首先需要检验手机号)
    if ([Factory valiMobile:mobileFiled.text]) {
        [TimeOut timeOut:self.codeBtn]; //倒计时
        //手机号校验成功
        [DownLoadData postAddBankSmsSend:^(id obj, NSError *error) {
            NSLog(@"%@", obj[@"messageText"]);
        } userId:[HCJFNSUser stringForKey:@"userId"] telephone:mobileFiled.text];
    }else{
        [Factory alertMes:@"您输入的手机号不正确"];
    }
}
/**
 *确认并绑卡按钮
 */
- (void)bidBankCard{
    if (_button.selected) {
        //预留手机号输入框
        UITextField *mobileFiled = (UITextField *)[self.view viewWithTag:1001];
        //短信输入框
        UITextField *messageFiled = (UITextField *)[self.view viewWithTag:1002];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //绑卡
        [DownLoadData postAddBank:^(id obj, NSError *error) {
            [hud setHidden:YES];
            //绑卡成功
            if ([obj[@"result"] isEqualToString:@"success"]) {
                //提示成功
                [Factory alertMes:@"绑卡成功！"];
                UserDefaults(@"success", @"bidBankCard");
                //反馈成功之后三秒返回到我的界面
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    sleep(2.0);
                    //回到主队列
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //返回根控制器
                        [self onClickLeftItem];
                    });
                });
            }else{
                UserDefaults(@"fail", @"bidBankCard");
                //提示错误信息
                [Factory alertMes:obj[@"messageText"]];
            }
        } cardNo:self.bankNum bankCode:self.bankCode bankName:self.bankName mobile:mobileFiled.text subBranch:self.bankName subBankCode:self.subBankCode userId:[HCJFNSUser stringForKey:@"userId"] msgBox:messageFiled.text];
    }else{
        [Factory alertMes:@"请您先同意三方存管协议"];
    }
}
/**
 *查询用户银行卡信息
 */
- (void)getUserBankCardInformation{
    [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
            self.isBankCard = YES;
        }else{
            self.isBankCard = NO;
        }
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //查询用户银行卡信息
    [self getUserBankCardInformation];
    [Factory hidentabar];
}
@end
