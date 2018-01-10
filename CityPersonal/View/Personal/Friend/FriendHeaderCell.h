//
//  HeaderCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/23.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteFriendModel.h"

@interface FriendHeaderCell : UITableViewCell
@property (nonatomic, strong) UILabel *titlelab;//奖励
@property (nonatomic, strong) UILabel *moneylab;//金额
@property (nonatomic, strong) UIButton *detailsBtn;//奖励详情

- (void)cellForModel:(InviteFriendModel *)model;

@end
