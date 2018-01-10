//
//  LargeAmountRechangeVC.h
//  CityJinFu
//
//  Created by mic on 2017/11/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopModalFatherVC.h"

@interface LargeAmountRechangeVC : PopModalFatherVC

@property (nonatomic, strong) UIImage *bankIconImage;//银行卡图标 image

@property (nonatomic, strong) NSString *bankName;//银行卡名称以及描述

@property (nonatomic, strong) NSString *userName;

@end
