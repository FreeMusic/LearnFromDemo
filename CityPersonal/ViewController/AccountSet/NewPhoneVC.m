//
//  NewPhoneVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/19.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NewPhoneVC.h"
#import "NewPhoneView.h"

@interface NewPhoneVC ()
@property (nonatomic, strong) NewPhoneView *phoneView;
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//验证码时间戳
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation NewPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    self.extendedLayoutIncludesOpaqueBars = YES;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"手机号"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneView = [[NewPhoneView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_phoneView];
    //验证码
    [_phoneView.verificationCodeBtn addTarget:self action:@selector(verificationCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    //确定
    [_phoneView.sureButton addTarget:self action:@selector(nextButton:) forControlEvents:UIControlEventTouchUpInside];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  验证码
 */
- (void)verificationCodeBtn:(UIButton *)sender
{
    if (_phoneView.PhoneText.text.length == 0 || _phoneView.PhoneText.text.length < 11) {
        if (_phoneView.PhoneText.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!"];
            [Factory alertMes:@"手机号为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!"];
            [Factory alertMes:@"手机号位数错误"];
        }
    }    //手机号正则验证
    else if ([Factory valiMobile:self.phoneView.PhoneText.text] == YES) {
        [self sendVaildPhoneCode];//验证码
        //倒计时
        [TimeOut timeOut:_phoneView.verificationCodeBtn];
    }else{
//        [self dialogWithTitle:@"温馨提示!" message:@"手机号非法!"];//提示框
        [Factory alertMes:@"手机号非法"];
    }
}
/**
 *  确定按钮点击事件
 */
- (void)nextButton:(UIButton *)sender
{
    if (_phoneView.PhoneText.text.length == 0 || _phoneView.PhoneText.text.length < 11) {
        if (_phoneView.PhoneText.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号为空!"];
            [Factory alertMes:@"手机号为空"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机号位数错误!"];
            [Factory alertMes:@"手机号位数错误"];
        }
    }else if(_phoneView.verificationCodeText.text.length == 0 || _phoneView.verificationCodeText.text.length < 6){
        if (_phoneView.verificationCodeText.text.length == 0) {
//            [self dialogWithTitle:@"温馨提示!" message:@"验证码错误!"];
            [Factory alertMes:@"验证码错误"];
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"验证码位数错误!"];
            [Factory alertMes:@"验证码位数错误"];
        }
    }else{
        [self serverData];//服务器数据
    }
}
/**
 *  服务器
 */
- (void)serverData{
    NSUserDefaults *user = HCJFNSUser;
    
    [self labelExample];//HUD6
    [DownLoadData postModifyMobile:^(id obj, NSError *error) {
        
        NSLog(@"%@",obj);
        if ([obj[@"result"] isEqualToString:@"success"]) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
//            [self dialogWithTitle:@"温馨提示!" message:@"手机修改错误!"];
            [Factory alertMes:@"手机修改错误"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hideAnimated:YES];
        });
    } mobile:_phoneView.PhoneText.text inputRandomCode:_phoneView.verificationCodeText.text jsCode:_timerRandom validPhoneExpiredTime:_validPhoneExpiredTime oldMobile:[user objectForKey:@"userId"]];
}
//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"888---%@",_timerRandom);
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
        NSLog(@"oooo----%@",_validPhoneExpiredTime);
        
    } andvaildPhoneCode:_timerRandom andmobile:_phoneView.PhoneText.text andtag:3 stat:@"1"];
}
/**
 *  提示框
 */
- (void)dialogWithTitle:(NSString *)dialogWithTitle message:(NSString *)message{
    self.dialogView =
    [[XFDialogNotice dialogWithTitle:dialogWithTitle
                            messages:message attrs:@{//头部颜色
                                                     XFDialogTitleViewBackgroundColor : TitleViewBackgroundColor,//分割线颜色
                                                     XFDialogLineColor : LineColor,
                                                     
                                                     }
                      commitCallBack:^(NSString *inputText) {
                          NSLog(@"%@",inputText);
                          if ([inputText isEqualToString:@"commit"]) {
                              NSLog(@"222");
                          }
                          else{
                              NSLog(@"333");
                          }
                          [self.dialogView hideWithAnimationBlock:nil];
                      }] showWithAnimationBlock:nil];
}
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
