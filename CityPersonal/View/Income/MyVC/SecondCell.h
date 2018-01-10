//
//  SecondCell.h
//  CityJinFu
//
//  Created by xxlc on 17/5/22.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenAlertView.h"

@interface SecondCell : UITableViewCell
@property (nonatomic, strong) UIButton *button;
@property (nonatomic ,strong) MBProgressHUD *hud;//网络加载
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) OpenAlertView *openAlert;
@property (nonatomic, strong) UIView *point;

@property (nonatomic, assign) NSInteger coupon;//未用红包数量
@property (nonatomic, assign) NSInteger ticket;//未用卡券数量
@property (nonatomic, assign) NSInteger experienceGold;//未用体验金数量

- (void)addWelfToPoint:(NSInteger)total;

@end
