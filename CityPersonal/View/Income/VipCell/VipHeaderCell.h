//
//  VipHeaderCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/30.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipClubModel.h"

@interface VipHeaderCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backView;//背景大图
@property (nonatomic, strong) UIButton *cardBtn;//银行卡按钮
@property (nonatomic, strong) UIImageView *userImg;//用户头像
@property (nonatomic, strong) UILabel *mobileLabel;//用户手机号标签
@property (nonatomic, strong) UILabel *integralLabel;//会员积分标签
@property (nonatomic, strong) UILabel *vipLabel;//会员等级标签
@property (nonatomic, strong) VipClubModel *model;//会员首页数据
@property (nonatomic, strong) UIButton *btn;//

@end
