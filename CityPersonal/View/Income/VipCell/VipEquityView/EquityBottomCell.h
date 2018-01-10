//
//  EquityBottomCell.h
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPagedFlowView.h"
#import "EquityIndexBannerView.h"

@interface EquityBottomCell : UITableViewCell<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic, strong) EquityIndexBannerView *bannerView;
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@property (nonatomic, strong) UILabel *titleLabel;//标题标签
@property (nonatomic, strong) UIButton *imgBtn;//六个循环创建的按钮
@property (nonatomic, strong) UILabel *label;//六个循环创建的标签
@property (nonatomic, strong) UIButton *rechargeBtn;//快去充值按钮
@property (nonatomic, strong) NSArray *equityArr;//会员权益数组


//会员可享受的权益 根据会员等级确定会员卡初始位置
- (void)cellForVipEquityByArray:(NSArray *)array andVipGrade:(NSString *)grade dictionary:(NSDictionary *)dictionary andMoney:(NSString *)monry;

@end
