//
//  FingermarkViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "FingermarkViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FingermarkViewController ()

@end

@implementation FingermarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LAContext *clip = [[LAContext alloc] init];
    NSError *hi = nil;
    NSString *hihihihi = @"通过验证指纹解锁";
    
    
    //TODO:TOUCHID是否存在
    if ([clip canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&hi]) {
        //TODO:TOUCHID开始运作
        [clip evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:hihihihi reply:^(BOOL succes, NSError *error)
         {
             if (succes)
             {
                 //验证通过
                 NSLog(@"验证通过");
             }
             else
             {
                 NSLog(@"验证失败");
                 //验证失败 取消
             }
         }];
    }
    else
    {
        
        NSLog(@"没有开启TOUCHID设备自行解决");
        //没有开启TOUCHID设备自行解决
    }

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
