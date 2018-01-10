//
//  PlanDetailsView.h
//  CityJinFu
//
//  Created by mic on 2017/7/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDetailsView : UIView

@property (nonatomic, strong) UILabel *timeLabel;//锁定时间
@property (nonatomic, strong) UILabel *amountLabel;//锁定本金
@property (nonatomic, strong) UILabel *rateLabel;//往期年化
@property (nonatomic, strong) UILabel *joinLabel;//何时加入

@end
