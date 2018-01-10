//
//  BalanceCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceCell : UITableViewCell
@property (nonatomic, strong) UILabel *balanceLab;//可用余额
@property (nonatomic, strong) UIButton *topUpBtn;//充值
@property (nonatomic, strong) UIButton *withdrawalBtn;//提现


@end
