//
//  YSFDemoBadgeView.h
//  YSFDemo
//
//  Created by chris on 15/9/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSFDemoBadgeView : UIView

@property (nonatomic, copy) NSString *badgeValue;
@property (nonatomic) CGFloat whiteCircleWidth; //最外层白圈的宽度

+ (instancetype)viewWithBadgeTip:(NSString *)badgeValue;


@end
