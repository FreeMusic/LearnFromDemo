//
//  TimeOut.m
//  CityJinFu
//
//  Created by xxlc on 16/8/28.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "TimeOut.h"

@implementation TimeOut
/**
 *  验证码
 */
+ (void)timeOut:(UIButton *)button
{
    __block int  timeOut = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(sourceTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(sourceTimer, ^{
        if (timeOut <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeOut % 60;
            NSString *stringTimer = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@秒重发",stringTimer] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(sourceTimer);//使用 dispatch_resume 函数来恢复
}
/**
 *  倒计时
 */
+ (void)timeCountdown:(UILabel *)label{
    
    __block int  timeOut = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(sourceTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(sourceTimer, ^{
        if (timeOut <= 0) {
            //倒计时结束，关闭
            dispatch_source_cancel(sourceTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = @"收不到验证码，点击获取语音验证码";
                label.textColor = UIColorFromRGB(0xff5933);
                [Factory ChangeColorString:@"收不到验证码，点击获取" andLabel:label andColor:UIColorFromRGB(0x8f8f8f)];
                label.userInteractionEnabled = YES;
            });
        }
        else
        {
            int seconds = timeOut % 60;
            NSString *stringTimer = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                label.text = [NSString stringWithFormat:@"收不到验证码，点击获取  %@秒重发",stringTimer];
                label.textColor = [UIColor lightGrayColor];
                label.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(sourceTimer);//使用 dispatch_resume 函数来恢复
}

@end
