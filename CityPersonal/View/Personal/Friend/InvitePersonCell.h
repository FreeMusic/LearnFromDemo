//
//  InvitePersonCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvitePersonModel.h"

@interface InvitePersonCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;//名字
@property (nonatomic,strong) UILabel *phoneLabel;//手机号
@property (nonatomic,strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *isBidCard;//是否绑卡
@property (nonatomic, strong) UILabel *isInvest;//是否投资

- (void)cellForModel:(InvitePersonModel *)model;

@end
