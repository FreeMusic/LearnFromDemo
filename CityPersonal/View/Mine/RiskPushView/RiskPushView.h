//
//  RiskPushView.h
//  CityJinFu
//
//  Created by mic on 2017/7/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RiskPushView : UIView

@property (nonatomic, strong) UILabel *resultLabel;//用户风险评估的结果

- (void)changeStringBytext:(NSString *)text changeStr:(NSString *)string;

@end
