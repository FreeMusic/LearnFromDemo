//
//  RegisterView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/16.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "RegisterView.h"
#import "ProtocolVC.h"
#import "AppDelegate.h"

@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createView];//创建布局
    }
    return self;
}
/**
 *  创建界面布局
 */
- (void)createView
{
    [self addSubview:self.cubeImageView];
    [self addSubview:self.passWordImageView];
    [self addSubview:self.phoneImageView];
    [self.phoneImageView addSubview:self.userTextFiled];
    [self.passWordImageView addSubview:self.verificationCodeTextFiled];
    [self.inviteImgView addSubview:self.inviteTextFiled];
    [self addSubview:self.verificationCodeButton];
    [self addSubview:self.selectButton];
    [self addSubview:self.agreementLabel];
    [self addSubview:self.nextButton];
    [self addSubview:self.resgisterLabel];//已有账号，请登录
    [self addSubview:self.servicephoneLabel];
    [self addSubview:self.serviceTimeLabel];
    
    //立方体
    _cubeImageView.frame = CGRectMake(0, 0, 142 * m6Scale, 152 * m6Scale);
    _cubeImageView.center = CGPointMake(kScreenWidth / 2, 261 * m6Scale);
    // 用户名
    [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(111*m6Scale));
        make.top.equalTo(self.mas_top).offset(437*m6Scale);
    }];
    [self.userTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_left).offset(100*m6Scale);
        if (iPhone5) {
            make.centerY.equalTo(self.phoneImageView.mas_centerY).offset(15.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.phoneImageView.mas_centerY).offset(10.5 * m6Scale);
        }
        make.right.equalTo(self.phoneImageView.mas_right).mas_offset(-5*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //密码
    [self.passWordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(117*m6Scale));
        make.top.equalTo(_phoneImageView.mas_bottom).offset(20*m6Scale);
    }];
    //验证码
    [_verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_passWordImageView.mas_right);
        make.height.mas_equalTo(@(93 * m6Scale));
        make.bottom.equalTo(_passWordImageView.mas_bottom);
        make.width.mas_equalTo(@(206 * m6Scale));
    }];
    [self.verificationCodeTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passWordImageView.mas_left).offset(100*m6Scale);
        make.width.mas_equalTo(@(240 * m6Scale));
        if (iPhone5) {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(18.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.passWordImageView.mas_centerY).offset(13.5 * m6Scale);
        }
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //邀请码图标
    [self addSubview:self.inviteImgView];
    [_inviteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(85*m6Scale);
        make.right.equalTo(self.mas_right).offset(-85*m6Scale);
        make.height.mas_equalTo(@(111*m6Scale));
        make.top.equalTo(_passWordImageView.mas_bottom).offset(20*m6Scale);
    }];
    //邀请码输入框
    [self.inviteTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_left).offset(100*m6Scale);
        if (iPhone5) {
            make.centerY.equalTo(self.inviteImgView.mas_centerY).offset(15.5 * m6Scale);
        } else {
            make.centerY.equalTo(self.inviteImgView.mas_centerY).offset(10.5 * m6Scale);
        }
        make.right.equalTo(self.inviteImgView.mas_right).mas_offset(-5*m6Scale);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //协议
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(120*m6Scale);
        make.top.equalTo(_inviteImgView.mas_bottom).offset(15*m6Scale);
        make.size.mas_equalTo(CGSizeMake(60*m6Scale, 60*m6Scale));
    }];
    [_agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_selectButton.mas_right).offset(5*m6Scale);
        make.top.equalTo(_inviteImgView.mas_bottom).offset(24*m6Scale);
        make.height.mas_equalTo(@(40*m6Scale));
    }];
    //登录
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((kScreenWidth - 600*m6Scale) / 2);
        make.right.equalTo(self.mas_right).offset(-(kScreenWidth - 600*m6Scale) / 2);
        make.top.equalTo(_selectButton.mas_bottom).offset(43*m6Scale);
        make.height.mas_equalTo(@(90*m6Scale));
    }];
    //注册
    [_resgisterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(350*m6Scale));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.equalTo(_nextButton.mas_bottom).offset(42*m6Scale);
    }];
    //客服时间
    [self.serviceTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50*m6Scale);
    }];
    //客服电话
    [self.servicephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.serviceTimeLabel.mas_top).offset(-10*m6Scale);
    }];
}
/**
 *  立方体
 *
 *  @return cubeImageView
 */
- (UIImageView *)cubeImageView
{
    if (!_cubeImageView) {
        _cubeImageView = [Factory imageView:@"thumb"];
    }
    return _cubeImageView;
}
/**
 *   用户名
 */
- (UITextField *)userTextFiled
{
    if (!_userTextFiled) {
        _userTextFiled = [[UITextField alloc]init];
        _userTextFiled = [HCJFTextField textStr:@"请输入手机号" andTag:10 andFont:30*m6Scale];
        _userTextFiled.delegate = self;
        _userTextFiled.keyboardType = UIKeyboardTypeNumberPad;
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _userTextFiled.inputAccessoryView = clip;
    }
    return _userTextFiled;
}
- (UIImageView *)phoneImageView
{
    if (!_phoneImageView) {
        _phoneImageView = [Factory imageView:@"phone"];
    }
    return _phoneImageView;
}
/**
 *  密码
 */
- (UITextField *)verificationCodeTextFiled
{
    if (!_verificationCodeTextFiled) {
        _verificationCodeTextFiled = [UITextField new];
        _verificationCodeTextFiled = [HCJFTextField textStr:@"请输入验证码" andTag:20 andFont:30*m6Scale];
        _verificationCodeTextFiled.delegate = self;
        _verificationCodeTextFiled.keyboardType = UIKeyboardTypeNumberPad;//键盘样式
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _verificationCodeTextFiled.inputAccessoryView = clip;

    }
    return _verificationCodeTextFiled;
}
/**
 *邀请码输入框
 */
- (UITextField *)inviteTextFiled{
    if(!_inviteTextFiled){
        _inviteTextFiled = [UITextField new];
        _inviteTextFiled = [HCJFTextField textStr:@"请输入邀请码或手机号(选填)" andTag:20 andFont:30*m6Scale];
        _inviteTextFiled.delegate = self;
        //定制的键盘
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _inviteTextFiled.inputAccessoryView = clip;
    }
    return _inviteTextFiled;
}
- (UIImageView *)passWordImageView
{
    if (!_passWordImageView) {
        _passWordImageView = [Factory imageView:@"lock-"];
    }
    return _passWordImageView;
}
/**
 *邀请码图标
 */
- (UIImageView *)inviteImgView{
    if(!_inviteImgView){
        _inviteImgView = [Factory imageView:@"组-7"];
    }
    return _inviteImgView;
}
/**
 *  验证码按钮
 */
- (UIButton *)verificationCodeButton
{
    if (!_verificationCodeButton) {
        _verificationCodeButton = [GXJButton buttonWithType:UIButtonTypeCustom];
        _verificationCodeButton.backgroundColor = ButtonColor;
        [_verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:33*m6Scale];
        _verificationCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_verificationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _verificationCodeButton.time = 2.0;
    }
    return _verificationCodeButton;
}
/**
 *客服电话
 */
- (UILabel *)servicephoneLabel{
    if(!_servicephoneLabel){
        _servicephoneLabel = [Factory CreateLabelWithTextColor:0.8 andTextFont:24 andText:@"客服电话：400-0571-909" addSubView:self];
        _servicephoneLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(servicePhoneLabel:)];
        _servicephoneLabel.userInteractionEnabled = YES;
        [_servicephoneLabel addGestureRecognizer:tap];
    }
    return _servicephoneLabel;
}
/**
 *客服时间
 */
- (UILabel *)serviceTimeLabel{
    if(!_serviceTimeLabel){
        _serviceTimeLabel = [Factory CreateLabelWithTextColor:0.8 andTextFont:24 andText:@"客服时间：9：00-17：30" addSubView:self];
        _serviceTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _serviceTimeLabel;
}
/**
 *客服电话手势点击
 */
- (void)servicePhoneLabel:(UITapGestureRecognizer *)tap{
    NSLog(@"打电话");
}
/**
 *  下一步
 */
- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    return _nextButton;
}
/**
 *  选择框
 */
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        _selectButton.tag = 1;
        [_selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
/**
 *  协议
 */
- (UILabel *)agreementLabel
{
    if (!_agreementLabel) {
        _agreementLabel = [UILabel new];
        _agreementLabel.text = @"我同意 《汇诚金服注册协议》";
        _agreementLabel.textColor = textFieldColor;
        _agreementLabel.userInteractionEnabled = YES;
        _agreementLabel.font = [UIFont systemFontOfSize:30*m6Scale];
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:_agreementLabel.text attributes:nil];
//        [att addAttribute:NSForegroundColorAttributeName value:buttonColor range:[_agreementLabel.text rangeOfString:@"《汇诚金服注册协议》"]];
//        _agreementLabel.attributedText = att;
        //手势
        UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self.agreementLabel addGestureRecognizer:singleRecognizer];
    }
    return _agreementLabel;
}
/**
 *  注册
 */
- (UILabel *)resgisterLabel
{
    if (!_resgisterLabel) {
        _resgisterLabel = [UILabel new];
        _resgisterLabel.text = @"已有账号,  请登录";
        _resgisterLabel.textColor = [UIColor colorWithRed:176 / 255.0 green:175 / 255.0 blue:175 / 255.0 alpha:1.0];
        _resgisterLabel.textAlignment = NSTextAlignmentCenter;
        _resgisterLabel.userInteractionEnabled = YES;
        _resgisterLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:_resgisterLabel.text attributes:nil];
        [att addAttribute:NSForegroundColorAttributeName value:ButtonColor range:[_resgisterLabel.text rangeOfString:@"请登录"]];
        _resgisterLabel.attributedText = att;
        UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgisterLogin:)];//手势
        singleRecognizer.numberOfTapsRequired = 1;
        [self.resgisterLabel addGestureRecognizer:singleRecognizer];
    }
    return _resgisterLabel;
}

/**
 已有账号,  请登录
 */
- (void)resgisterLogin:(UITapGestureRecognizer *)sender{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    [ctr dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  注册协议
 */
- (void)resgister:(UITapGestureRecognizer *)sender
{
    
    UIViewController *ctr = (UIViewController *)[self ViewController];
    ProtocolVC *protocol = [ProtocolVC new];
    protocol.strTag = @"0";
    [ctr presentViewController:protocol animated:YES completion:nil];

}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self viewWithTag:10];
    NSString *resultStr;
//    if ([string isEqualToString:@""]) {
//        //获取到上一次操作的字符串长度
//        NSInteger clip = textField.text.length;
//        //截取字符串 将最后一个字符删除
//        resultStr = [textField.text substringToIndex:clip - 1];
//        
//    } else {
//        resultStr = [textField.text stringByAppendingString:string];
//    }

    if (text == textField) {
//        self.clearPwdTF.hidden = YES;
//        if (range.location == -1 || resultStr.length == 0) {
//            self.clearUserTF.hidden = YES;
//        } else {
//            self.clearUserTF.hidden = NO;
//        }
        if (range.location >= 11) {
            return NO;
        }
        return YES;
    }else if ([textField isEqual:_inviteTextFiled]){
        if (range.location > 11) {
            return NO;
        }else{
            return YES;
        }
    }else{
//        self.clearUserTF.hidden = YES;
//        if (range.location == -1 || resultStr.length == 0) {
//            self.clearPwdTF.hidden = YES;
//        } else {
//            self.clearPwdTF.hidden = NO;
//        }
        if (range.location >= 6) {
            return NO;
        }
        return YES;
    }
}


//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    UITextField *text = (UITextField *)[self viewWithTag:10];
//    if (text == textField) {
//        self.clearUserTF.hidden = YES;
//    }
//    else {
//        self.clearPwdTF.hidden = YES;
//    }
//    return YES;
//}

/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userTextFiled resignFirstResponder];
    [self.verificationCodeTextFiled resignFirstResponder];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
    
}
/**
 *  协议选择按钮
 */
- (void)selectButton:(UIButton *)sender{
    NSLog(@"11111111");
    if (sender.selected == YES) {
        [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        _selectButton.tag = 1;
    }else{
        [_selectButton setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        _selectButton.tag = 2;
    }
    sender.selected = !sender.selected;
}

@end
