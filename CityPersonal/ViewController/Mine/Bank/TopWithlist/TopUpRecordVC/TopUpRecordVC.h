//
//  TopUpRecordVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpRecordVC : UIViewController

@property (nonatomic, strong) NSString *tag;//0是充值记录  1提现记录
@property (nonatomic, copy) NSString *status;//充值提现状态
@property (nonatomic, strong) NSString *itemID;//ID

@end
