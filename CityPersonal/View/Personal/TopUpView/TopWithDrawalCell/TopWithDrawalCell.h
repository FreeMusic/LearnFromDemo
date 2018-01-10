//
//  TopWithDrawalCell.h
//  CityJinFu
//
//  Created by xxlc on 16/10/14.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopWithDrawalCell : UITableViewCell

@property (nonatomic, strong) UILabel *statusLabel;//状态
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *moneyLabel;//投资金额
@property (nonatomic, strong) UILabel *typeLabel;//在充值记录中  需要显示支付公司的名称  而提现不需要

- (void)cellForDictionary:(NSDictionary *)dictionary;

@end
