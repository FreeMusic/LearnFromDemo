//
//  EquityIndexBannerView.h
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquityIndexBannerView : UIView

@property (nonatomic, strong) UIImageView *mainImageView;//会员卡背景图
@property (nonatomic, strong) UILabel *userLabel;//用户标签
@property (nonatomic, strong) UILabel *moneyLabel;//升级所需财气值

@property (nonatomic, strong) UIView *coverView;

- (void)setBackgroundImgViewByImgName:(NSString *)imgName andVipArr:(NSArray *)array andMoney:(NSInteger)money andGrade:(NSInteger)grade andIndex:(NSInteger)index;

@end
