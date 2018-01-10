//
//  LockTestView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "LockTestView.h"
#import "AppDelegate.h"
#import "UIView+ViewController.h"
#import "ForgetPasswordView.h"
#import "GestureViewController.h"
#import "NewSignVC.h"

@interface LockTestView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *imageArray; //存放小图片数组
@property (nonatomic, strong) UILabel *messageLabel; //信息label
@property (nonatomic, strong) UITextField *hiddenTextfield;
@property (nonatomic, assign) NSInteger wrongTime; //错误次数
@property (nonatomic, strong) ForgetPasswordView *passwordView;
@property (nonatomic, strong) UIButton *backButton; //背景阴影按钮
@property (nonatomic, copy) NSString *timerRandom;
@property (nonatomic, copy) NSString *validPhoneExpiredTime;
@property (nonatomic, strong) UILabel *forgetGestureLabel;
@property (nonatomic, assign) NSInteger typeTag;//次数用完时区分


@end

@implementation LockTestView

#pragma mark-懒加载
- (NSMutableArray *)buttons {
    
    if (_buttons==nil) {
        
        _buttons=[NSMutableArray array];
        
    }
    return _buttons;
    
}

- (NSMutableArray *)btnArray {
    
    if (_btnArray == nil) {
        
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}

- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
    
}
//返回按钮
- (UIButton *)backButton {
    
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        _backButton.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        [_backButton addTarget:self action:@selector(hiddenKeyboardAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}
//忘记密码
- (ForgetPasswordView *)passwordView {
    
    if (_passwordView == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboardAction:)];
        _passwordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 355 * m6Scale)];
        _passwordView.backgroundColor = [UIColor whiteColor];
        [_passwordView.cancelImageView addGestureRecognizer:tap];
        [_passwordView.reSendButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _passwordView;
}
//密码输入框
- (UITextField *)hiddenTextfield {
    
    if (_hiddenTextfield == nil) {
        _hiddenTextfield = [[UITextField alloc] init];
        _hiddenTextfield.keyboardType = UIKeyboardTypeNumberPad;
        _hiddenTextfield.inputAccessoryView = self.passwordView;
        _hiddenTextfield.delegate = self;
    }
    
    return _hiddenTextfield;
}
//界面搭建
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.wrongTime = 3;
        
        
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        self.clipsToBounds = YES;
        [self setup];
    }
    return self;
}
- (void)setAccessTag:(NSInteger)accessTag{
    _accessTag = accessTag;
    if (accessTag ==2) {
        NSLog(@"我的值是2");
        _forgetGestureLabel.text = @"选择其他方式登录";
    }
    else{
        NSLog(@"hahaha");
        _forgetGestureLabel.text = @"忘记手势密码";
    }
}
//在界面上创建9个按钮
- (void)setup {
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor colorWithRed:119 / 255.0 green:93 / 255.0 blue:17 / 255.0 alpha:1];
    _messageLabel.text = @"至少链接四个点";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont systemFontOfSize:31 * m6Scale];
    [self addSubview:_messageLabel];
    
    UILabel *clipLabel = [[UILabel alloc] init];
    clipLabel.text = @"绘制解锁图案";
    clipLabel.textAlignment = NSTextAlignmentCenter;
    clipLabel.font = [UIFont systemFontOfSize:41 * m6Scale];
    clipLabel.textColor = [UIColor colorWithRed:119 / 255.0 green:93 / 255.0 blue:17 / 255.0 alpha:1];
    [self addSubview:clipLabel];
    
    //1.创建9个按钮
    for (int i=0; i<9; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        //2.设置按钮的状态背景
        [btn setBackgroundImage:[UIImage imageNamed:@"手势圆"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"手势点击圆"] forState:UIControlStateSelected];
        //3.把按钮添加到视图中
        [self  addSubview:btn];
        //4.禁止按钮的点击事件
        btn.userInteractionEnabled=NO;
        
        //4.3九宫格法计算每个按钮的frame
        CGFloat row = i / 3;
        CGFloat loc   = i % 3;
        CGFloat btnW = 74;
        CGFloat btnH = 74;
        CGFloat padding = (self.frame.size.width- 3 * btnW) / 4;
        CGFloat btnX = padding + (btnW + padding) * loc;
        CGFloat btnY = - padding + (btnW + padding) * row;
        btn.frame = CGRectMake(btnX ,94 + btnY + self.frame.size.height / 4, btnW, btnH);
        
        
        if (i == 0) {
            
            [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(btn.mas_top).offset(- self.frame.size.height / 8 + 30);
                make.centerX.mas_equalTo(self.mas_centerX);
                
            }];
            
            [clipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_messageLabel.mas_bottom).offset(5);
                make.centerX.mas_equalTo(self.mas_centerX);
            }];
            
        }
    }
    //忘记手势密码
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetGestureAction:)];
    
    _forgetGestureLabel = [[UILabel alloc]init];
    _forgetGestureLabel.text = @"忘记手势密码";
    _forgetGestureLabel.userInteractionEnabled = YES;
    _forgetGestureLabel.textColor = [UIColor colorWithRed:119 / 255.0 green:93 / 255.0 blue:17 / 255.0 alpha:1];
    _forgetGestureLabel.font = [UIFont systemFontOfSize:35 * m6Scale];
    [_forgetGestureLabel addGestureRecognizer:tap];
    [self addSubview:_forgetGestureLabel];
    if (self.accessTag==2) {
        _forgetGestureLabel.text = @"选择其他方式登录";
    }
    else{
        _forgetGestureLabel.text = @"忘记手势密码";
    }
    [_forgetGestureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(@(60 * m6Scale));
        make.bottom.equalTo(self.mas_bottom).offset(- 80 * m6Scale);
    }];
}

#pragma mark - 忘记手势密码
- (void)forgetGestureAction:(UIGestureRecognizer *)tap {
    if(self.accessTag ==2){
        NSUserDefaults *user = HCJFNSUser;
        //存储到本地的数据在退出登录的时候删除掉
        NSArray *array = @[@"result",@"userId",@"switchGesture",@"userIcon",@"gesturePassword",@"fingerSwitch",@"gestureLock",@"userToken", @"bidBankCard"];
        UserDefaults(@"fail", @"sxyRealName")
        for (int i = 0; i < array.count; i++) {
            [user removeObjectForKey:array[i]];
            [user synchronize];
        }
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate hideGestureViewAction];
        //退出登录，需要注销网易七鱼
        [[QYSDK sharedSDK] logout:^{
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"3";
            [[self ViewController] presentViewController:signVC animated:YES completion:nil];
            
        }];
        
    }
    else{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        [delegate.window addSubview:self.backButton];
        self.backButton.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        self.hiddenTextfield.frame = CGRectMake(0, 0, 100, 100);
        self.hiddenTextfield.hidden = YES;
        
        [self addSubview:self.hiddenTextfield];
        [self.hiddenTextfield becomeFirstResponder];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self sendVaildPhoneCode];//验证码
            [TimeOut timeOut:self.passwordView.reSendButton]; //倒计时
        });
    }
}
#pragma mark - 隐藏键盘
- (void)hiddenKeyboardAction:(UIButton *)button {
    
    self.backButton.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    CATransition *clip = [[CATransition alloc] init];
    clip.type = @"fade";
    clip.duration = 0.3;
    self.passwordView.passwordText = nil;
    [self.backButton.layer addAnimation:clip forKey:nil];
    
    [self.hiddenTextfield resignFirstResponder];
    
}

- (void)sendCodeAction:(UIButton *)button {
    
    [self sendVaildPhoneCode];
    
    [TimeOut timeOut:button]; //倒计时
}

//验证码
- (void)sendVaildPhoneCode
{
    _timerRandom = [TimerRandom timerRandom];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [DownLoadData postVaildPhoneCode:^(id obj, NSError *error) {
        NSString *validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        //
        NSLog(@"oooo----%@",validPhoneExpiredTime);
        
        _validPhoneExpiredTime = validPhoneExpiredTime;
        
    } andvaildPhoneCode:_timerRandom andmobile:[user objectForKey:@"userId"] andtag:5 stat:@"1"];
}

#pragma mark - textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
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
        
        [DownLoadData postCheckOutGesture:^(id obj, NSError *error) {
            
            NSLog(@"%@",obj);
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                [self hiddenKeyboardAction:nil];
                
                if ([self.clipTag isEqualToString:@"1"]) {
                    
                    [[self ViewController] dismissViewControllerAnimated:YES completion:nil];
                    
                }else {
                    
                    [delegate hideGestureViewAction];
                    
                    delegate.leveyTabBarController.selectedIndex = 2;
                    
                    delegate.backView.hidden = YES;
                }
                
                GestureViewController *gestVC = [[GestureViewController alloc] init];
                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
                [navi pushViewController:gestVC animated:YES];
                
                
            }else {
                
                [self hiddenKeyboardAction:nil];
                
                self.hiddenTextfield.text = nil;
                self.passwordView.passwordText = nil;
                if (obj[@"messageText"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"messageText"] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    [[self ViewController] presentViewController:alert animated:YES completion:nil];
                }
            }
        } mobile:self.passwordView.phoneNum inputCode:text validTime:self.validPhoneExpiredTime jsCode:self.timerRandom];
        
        return YES;
        
    }else if (text.length >= 7) {
        
        return NO;
        
    }else {
        
        self.passwordView.passwordText = text;
        
        return YES;
    }
}
//刷新视图
- (void)refreshView {
    
    for (UIButton *btn in self.buttons) {
        
        btn.selected = NO;
    }
    
    for (UIImageView *imageView in self.imageArray) {
        
        imageView.image = [UIImage imageNamed:@"手势圆"];
        
    }
    
    [self.btnArray removeAllObjects];
    
    [self.buttons removeAllObjects];
    
    [self setNeedsDisplay];
    
}

//4.设置按钮的frame
- (void)layoutSubviews {
    //4.1需要先调用父类的方法
    [super layoutSubviews];
    
}

//5.监听手指的移动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint starPoint=[self getCurrentPoint:touches];
    UIButton *btn=[self getCurrentBtnWithPoint:starPoint];
    
    if (btn && btn.selected != YES) {
        btn.selected=YES;
        [self.buttons addObject:btn];
        NSString *clipTag = [NSString stringWithFormat:@"%li",(long)btn.tag];
        
//        self.btnStr = clipTag;
        [self.btnArray addObject:clipTag];
    }
    for (UIImageView *imageView in self.imageArray) {
        
        for (NSString *btnTag in self.btnArray){
            if (imageView.tag == btnTag.integerValue) {
                imageView.image = [UIImage imageNamed:@"圆-橙"];
            }
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    CGPoint movePoint=[self getCurrentPoint:touches];
    UIButton *btn=[self getCurrentBtnWithPoint:movePoint];
    //存储按钮
    //已经连过的按钮，不可再连
    if (btn && btn.selected != YES) {
        
        //设置按钮的选中状态
        btn.selected=YES;
        //把按钮添加到数组中
        [self.buttons addObject:btn];
        NSString *clipTag = [NSString stringWithFormat:@"%li",(long)btn.tag];
        
        [self.btnArray addObject:clipTag];
    }
    for (UIImageView *imageView in self.imageArray) {
        
        for (NSString *btnTag in self.btnArray){
            if (imageView.tag == btnTag.integerValue) {
                imageView.image = [UIImage imageNamed:@"圆-橙"];
            }
        }
        
    }
    //通知view重新绘制
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSInteger clip = 0;
    
    NSMutableArray *numArray = [NSMutableArray array];
    
    for (UIButton *btn in self.buttons) {
        
        NSString *str = [NSString stringWithFormat:@"%li",(long)btn.tag];
        
        [numArray addObject:str];
    }
    
    
    
    if (numArray.count < 4) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手势密码至少链接4个点" preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self refreshView];
        }]];
        
        
        [self.ViewController presentViewController:alert animated:YES completion:nil];
    } else {
        if (_typeTag == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已用完次数" preferredStyle:UIAlertControllerStyleAlert];
            _typeTag = 1;
            
            [alert addAction:[UIAlertAction actionWithTitle:@"忘记手势密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self refreshView];
                [self forgetGestureAction:nil];
                
            }]];
            
            
            [[self ViewController] presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            NSString *gestureStr = @"";
            
            for (NSString *str in numArray) {
                
                gestureStr = [gestureStr stringByAppendingString:str];
                
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
            //验证手势密码是否正确
            [DownLoadData postMatchGesture:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                NSLog(@"%@",obj);
                
                NSString *result = [NSString stringWithFormat:@"%@",obj[@"result"]];
                
                if ([result isEqualToString:@"1"]) {
                    
                    if ([self.clipTag isEqualToString:@"0"]) {
                        
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        
                        [delegate hideGestureViewAction];
                        
                    }else {
                        
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        UIViewController *vc = [self ViewController];
                        
                        MBProgressHUD *hud2 = [MBProgressHUD showHUDAddedTo:delegate.window animated:YES];
                        hud2.mode = MBProgressHUDModeCustomView;
                        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                        //                        hud2.contentColor = [UIColor whiteColor];
                        hud2.customView = [[UIImageView alloc] initWithImage:image];
                        hud2.square = YES;
                        //                        hud2.bezelView.backgroundColor = [UIColor blackColor];
                        hud2.label.text = NSLocalizedString(@"验证成功", @"HUD done title");
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [hud2 hideAnimated:YES];
                            if (self.isCloseProtect) {//是否关闭帐户保护
                                [user setValue:@"NO" forKey:@"gestureLock"];
                                [user setValue:@"NO" forKey:@"fingerSwitch"];
                                [DownLoadData postChangeSystemSetting:^(id obj, NSError *error) {
                                    
                                } userId:[user objectForKey:@"userId"] gesture:@"0" touchID:@"0" accountProtect:@"0"];
                                [vc dismissViewControllerAnimated:YES completion:nil];
                            }else{
                                if ([[user objectForKey:@"gestureLock"] isEqualToString:@"YES"]) {
                                    [user setValue:@"NO" forKey:@"fingerSwitch"];
                                }else{
                                    [user setValue:@"YES" forKey:@"gestureLock"];
                                    [user setValue:@"NO" forKey:@"fingerSwitch"];
                                }
                                if ([self.clipTag isEqualToString:@"5"]) {
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeSafe" object:self];
                                }
                                [DownLoadData postChangeSystemSetting:^(id obj, NSError *error) {
                                    
                                } userId:[user objectForKey:@"userId"] gesture:@"1" touchID:@"0" accountProtect:@"1"];
                                [vc dismissViewControllerAnimated:YES completion:nil];
                            }
                            
                            [user synchronize];

                        });
                    }
                    
                }else {
                    
                    self.wrongTime --;
                    //判断剩余次数
                    if (self.wrongTime > 0) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"还剩%li次机会绘制解锁图案",(long)self.wrongTime] preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"忘记手势密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.accessTag = 1;
                            [self forgetGestureAction:nil];
                            
                        }]];
                        [[self ViewController] presentViewController:alert animated:YES completion:nil];
                        _messageLabel.text = [NSString stringWithFormat:@"还剩%li次机会",(long)self.wrongTime];
                        
                    }else {
                        self.wrongTime = 0;
                        _messageLabel.text = [NSString stringWithFormat:@"还剩%li次机会",(long)self.wrongTime];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已用完次数" preferredStyle:UIAlertControllerStyleAlert];
                        _typeTag = 1;
//                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                            
//                            
//                            
//                            [[self ViewController] dismissViewControllerAnimated:YES completion:nil];
//                            
//                            [user setObject:@"NO" forKey:@"gestureLock"];
//                            [user synchroniz123e];
//                            
//                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"忘记手势密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self forgetGestureAction:nil];
                            
                        }]];
                        [[self ViewController] presentViewController:alert animated:YES completion:nil];
                        
                    }
                    
                    [self refreshView];
                    
                }
                
                
            } userId:[user objectForKey:@"userId"] gestureStr:gestureStr];
            
        }
    }
    
}
//对功能点进行封装
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:touch.view];
    return point;
}

- (UIButton *)getCurrentBtnWithPoint:(CGPoint)point {
    
    for (UIView *btn in self.subviews) {
        
        if ([btn isKindOfClass:NSClassFromString(@"UIButton")]) {
            
            if (CGRectContainsPoint(btn.frame, point)) {
                return (UIButton *)btn;
            }
        }
        
    }
    return Nil;
}

//重写drawrect:方法
- (void)drawRect:(CGRect)rect {
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //绘图（线段）
    for (int i=0; i < self.buttons.count; i++) {
        
        UIButton *btn = self.buttons[i];
        
        if (i == 0) {
            //设置起点（注意连接的是中点）
            //            CGContextMoveToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
        }else
        {
            //            CGContextAddLineToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    //渲染
    //设置线条的属性
   
        
    CGContextSetLineWidth(ctx, 3);
    CGContextSetRGBStrokeColor(ctx, 255 / 255.0, 167/255.0, 79/255.0, 1);
    CGContextStrokePath(ctx);
}




@end
