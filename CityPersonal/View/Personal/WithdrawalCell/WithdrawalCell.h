//
//  WithdrawalCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/20.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithdrawalCell : UITableViewCell

@property (nonatomic, strong) UILabel *amountLabel;//充值金额标签
@property (nonatomic, strong) UITextField *textFiled;//提现金额输入框
@property (nonatomic, strong) UILabel *restLabel;//可用余额
@property (nonatomic, strong) UIButton *drawAllBtn;//全部提现

@end
