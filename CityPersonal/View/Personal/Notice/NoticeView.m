//
//  NoticeView.m
//  CityJinFu
//
//  Created by xxlc on 16/8/22.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NoticeView.h"

@interface NoticeView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, copy) NSString *whetherAppPush;//推送
@property (nonatomic, copy) NSString *whetherSms;//短信
@property (nonatomic, copy) NSString *whetherSiteMail;//站内信
@property (nonatomic, weak) XFDialogFrame *dialogView;//弹出框
@property (nonatomic, strong) NSMutableDictionary *muDiction;//服务器参数字典
@property (nonatomic, strong) NSString *state;//设置状态

@end
@implementation NoticeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
/**
 *  布局
 */
- (void)layoutSubviews{
    
    //背景
    for (int i = 0; i < 3; i++) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(NavigationBarHeight+32*m6Scale+90*m6Scale*i);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, 90*m6Scale));
        }];
    }
    NSArray *array = @[@"短信通知",@"站内信通知",@"系统通知"];
   //label
    for (int j = 0; j < 3; j ++) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(44*m6Scale, NavigationBarHeight+45*m6Scale+90*m6Scale*j, 250*m6Scale, 50*m6Scale)];
        _label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _label.text = array[j];
        _label.font = [UIFont systemFontOfSize:34*m6Scale];
        [self addSubview:self.label];
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    //开关
    for (int k = 0; k < 3; k ++) {
        _swith = [[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-150*m6Scale, NavigationBarHeight+45*m6Scale+90*m6Scale*k, 116*m6Scale, 56*m6Scale)];
        _swith.tag = 10 + k;
        [_swith addTarget:self action:@selector(swith:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_swith];
        
        if (k == 0) {
            
            NSString *state = [user objectForKey:@"noteNoti"];
            NSLog(@"%@",state);
            if (state == nil) {
                _swith.on = YES;
            }else{
                if ([state isEqualToString:@"1"]) {
                    
                    _swith.on = YES;
                }else {
                    
                    _swith.on = NO;
                }
            }
        }else if (k == 1) {
            
            NSString *state = [user objectForKey:@"mailNoti"];

            if (state == nil) {
                _swith.on = YES;
            }else{
                if ([state isEqualToString:@"1"]) {
                    
                    _swith.on = YES;
                }else {
                    
                    _swith.on = NO;
                }
            }
        }else {
            
            NSString *state = [user objectForKey:@"systemNoti"];
            
            if (state == nil) {
                _swith.on = YES;
            }else{
                if ([state isEqualToString:@"1"]) {
                    
                    _swith.on = YES;
                }else {
                    
                    _swith.on = NO;
                }
            }
        }
    }
}
/**
 *  开关的点击事件
 */
- (void)swith:(UISwitch *)sender {
    
    NSUserDefaults *user = HCJFNSUser;
    
    _state = @"";
    _muDiction = [NSMutableDictionary dictionary];
    
    if (sender.on) {
        
        _state = @"1";
    }else {
        
        _state = @"0";
    }
    
    if (sender.tag == 10) {

        [_muDiction setValue:_state forKey:@"whetherSms"];//短信通知
        [user setValue:_state forKey:@"noteNoti"];
        [user synchronize];
        NSLog(@"10");
        
    }else if (sender.tag == 11){
        NSLog(@"11");
      
        [_muDiction setValue:_state forKey:@"whetherSiteMail"];//站内信短信
        [user setValue:_state forKey:@"mailNoti"];
        [user synchronize];
    }
    else{
        NSLog(@"12");
//        _whetherAppPush = _state;
//        [self dialogWithTitle:@"温馨提示!" message:@"您确定关闭推送，关闭后将收不到推送信息!" nsTag:0];
        [_muDiction setValue:_state forKey:@"whetherAppPush"];//推送
        [user setValue:_state forKey:@"systemNoti"];
        [user synchronize];
    }
    //保存用户设置
    NSLog(@"%@",_muDiction);
    [_muDiction setValue:[user objectForKey:@"userId"] forKey:@"userId"];//用户id
    [DownLoadData postWithSystem:^(id obj, NSError *error) {
        if ([obj[@"result"] isEqualToString:@"success"]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"设置成功!" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }]];
//        UIViewController *ctr = (UIViewController *)[self ViewController];
//        [ctr presentViewController:alert animated:YES completion:nil];
        }
        NSLog(@"%@",obj);
       
    } userId:_muDiction andtag:1];
}

- (void)whetherSms:(NSString *)whetherSms andwhetherSiteMail:(NSString *)whetherSiteMail andwhetherAppPush:(NSString *)whetherAppPush{
    
    NSLog(@"%@----%@----%@",whetherSms,whetherSiteMail,whetherAppPush);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:whetherSms forKey:@"noteNoti"];
    [user setValue:whetherSiteMail forKey:@"mailNoti"];
    [user setValue:whetherAppPush forKey:@"systemNoti"];
    [user synchronize];
    
}
@end
