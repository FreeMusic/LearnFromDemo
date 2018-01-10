//
//  MyBankCardCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankListModel.h"

@interface MyBankCardCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;//银行卡大背景图
@property (nonatomic, strong) UIButton *unBindBtn;//解绑按钮
@property (nonatomic, strong) UILabel *cardNumLabel;//银行卡号标签

- (void)cellForModel:(BankListModel *)model;

@end
