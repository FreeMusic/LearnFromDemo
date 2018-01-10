//
//  UpdatePhoneVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/18.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "UpdatePhoneVC.h"
#import "NewPhoneVC.h"


@interface UpdatePhoneVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *verificationCodeTextFiled;//验证码
@property (nonatomic, strong) UIButton *verificationCodeBtn;//验证码按钮
@property (nonatomic, strong) UIButton *nextButton;//下一步按钮
@property (nonatomic, strong) UIView *dividerView;//分割线
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, strong)  NSString *validPhoneExpiredTime;//验证码的时间戳
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation UpdatePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"修改手机号"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];

    [self creatView];//创建布局
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  创建布局
 */
- (void)creatView{
    UIView *bagView = [[UIView alloc]initWithFrame:CGRectMake(0, 150*m6Scale, kScreenWidth, 106*m6Scale)];
    bagView.backgroundColor = [UIColor whiteColor];
    bagView.userInteractionEnabled = YES;
    [self.view addSubview:bagView];
    //验证码
    _verificationCodeTextFiled = [CustomTextField new];
    _verificationCodeTextFiled.frame = CGRectMake(0, 150*m6Scale, kScreenWidth-120, 106*m6Scale);
    _verificationCodeTextFiled.delegate = self;
    _verificationCodeTextFiled.tag = 10;
    _verificationCodeTextFiled.keyboardType = UIKeyboardTypeNumberPad;//纯数字键盘
    _verificationCodeTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: titleColor}];
    [_verificationCodeTextFiled setValue:[UIFont boldSystemFontOfSize:33*m6Scale] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_verificationCodeTextFiled];
    //验证码按钮
    _verificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verificationCodeBtn setTitleColor:[UIColor colorWithRed:12/255.0 green:153/255.0 blue:241/255.0 alpha:1.0] forState:UIControlStateNormal];
    _verificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:39*m6Scale];
    [_verificationCodeBtn addTarget:self action:@selector(verificationCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verificationCodeBtn];
    [_verificationCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bagView.mas_right).offset(-20*m6Scale);
        make.centerY.equalTo(bagView.mas_centerY);
        make.height.mas_equalTo(@(57*m6Scale));
    }];
    //分割线
    _dividerView = [UIView new];
    _dividerView.backgroundColor = titleColor;
    [self.view addSubview:_dividerView];
    [_dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bagView.mas_right).offset(-220*m6Scale);
        make.centerY.equalTo(_verificationCodeTextFiled.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 57*m6Scale));
    }];
    //下一步
    _nextButton = [SubmitBtn buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(42*m6Scale, 326*m6Scale, 666*m6Scale, 90*m6Scale);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self.view viewWithTag:10];
    if (text == textField) {
        if (range.location >= 6) {
            return NO;
        }
        return YES;
    }
    else{
        return NO;
    }
}
/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.verificationCodeTextFiled resignFirstResponder];
}

/**
 *  验证码
 */
- (void)verificationCodeBtn:(UIButton *)sender
{
    [self sendVaildPhoneCode];//验证码
    //倒计时
    [TimeOut timeOut:self.verificationCodeBtn];
}
//验证码
- (void)sendVaildPhoneCode
{
    NSUserDefaults *user = HCJFNSUser;
    
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"888---%@",_timerRandom);
    
    [self labelExample];//HUD6
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        NSLog(@"oooo----%@",_validPhoneExpiredTime);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
        });
    } andvaildPhoneCode:_timerRandom andmobile:[user objectForKey:@"userId"] andtag:2 stat:@"1"];
}
/**
 *  下一步
 */
- (void)nextButton:(UIButton *)sender
{
//    NewPhoneVC *phoneVC = [NewPhoneVC new];
//    [self.navigationController pushViewController:phoneVC animated:YES];
    
    if (_verificationCodeTextFiled.text.length == 0 || _verificationCodeTextFiled.text.length < 6) {
        if (_verificationCodeTextFiled.text.length == 0) {
            
//            [self dialogWithTitle:@"温馨提示!" message:@"验证码为空!"];
            [Factory alertMes:@"验证码为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"验证码位数错误!"];
            [Factory alertMes:@"验证码位数错误"];
        }
    }
    else if (_verificationCodeTextFiled.text.length == 6) {
       if ([_verificationCodeTextFiled.text isEqual:_timerRandom]) {
           [self labelExample];//HUD6
           //判断验证码是否合法
           [DownLoadData postCheckMobile:^(id obj, NSError *error) {
               
               NSLog(@"%@",obj);
               if ([obj[@"result"] isEqualToString:@"success"]) {
                   NewPhoneVC *phoneVC = [NewPhoneVC new];
                   phoneVC.hidesBottomBarWhenPushed = YES;
                   [self.navigationController pushViewController:phoneVC animated:YES];
               }else{
//                   [self dialogWithTitle:@"温馨提示!" message:@"验证码错误!"];
                   [Factory alertMes:@"验证码错误"];
               }
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   [_hud hideAnimated:YES];
               });
           } inputRandomCode:_verificationCodeTextFiled.text jsCode:_timerRandom validPhoneExpiredTime:_validPhoneExpiredTime];
       }
       else{
//           [self dialogWithTitle:@"温馨提示!" message:@"验证码错误!"];
           [Factory alertMes:@"验证码错误"];
       }
    }
}
/**
 *  提示框
 */
//- (void)dialogWithTitle:(NSString *)dialogWithTitle message:(NSString *)message{
//    self.dialogView =
//    [[XFDialogNotice dialogWithTitle:dialogWithTitle
//                            messages:message attrs:@{//头部颜色
//                                                     XFDialogTitleViewBackgroundColor : TitleViewBackgroundColor,//分割线颜色
//                                                     XFDialogLineColor : LineColor,
//                                                     
//                                                     }
//                      commitCallBack:^(NSString *inputText) {
//                          NSLog(@"%@",inputText);
//                          if ([inputText isEqualToString:@"commit"]) {
//                              NSLog(@"222");
//                          }
//                          else{
//                              NSLog(@"333");
//                          }
//                          [self.dialogView hideWithAnimationBlock:nil];
//                      }] showWithAnimationBlock:nil];
//}
//HUD加载转圈
- (void)labelExample {
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
