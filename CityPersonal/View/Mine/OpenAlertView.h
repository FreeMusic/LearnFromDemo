//
//  OpenAlertView.h
//  CityJinFu
//
//  Created by xxlc on 17/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenAlertView : UIView

@property (nonatomic, strong) UILabel *messageLabel;//信息标签

@property (nonatomic, assign) BOOL showPswView;//是否要设置交易密码

@property (nonatomic, strong) NSString *mcryptKey;//加密因子

@property(nonatomic , strong) UIButton *openBtn;

@property (nonatomic, strong) NSString *setpass;//设置的交易密码

@property (nonatomic, strong) NSString *surepass;//确认的交易密码

@property (nonatomic, assign) BOOL showMyWealf;//显示我的福利按钮

@property(nonatomic,copy)void(^buttonAction)(NSInteger tag);

@end
