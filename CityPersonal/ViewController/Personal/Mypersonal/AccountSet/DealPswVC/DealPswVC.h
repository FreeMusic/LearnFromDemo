//
//  DealPswVC.h
//  CityJinFu
//
//  Created by mic on 2017/7/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealPswVC : UIViewController

@property (nonatomic, strong) NSString *style;//假如用户 是从强制设置交易密码过来的  就不要用返回按钮  非零

@property (nonatomic, assign) NSInteger setPsw;//

@end
