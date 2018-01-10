//
//  ScanUserIDCard.h
//  CityJinFu
//
//  Created by mic on 2017/10/31.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)();

@interface ScanUserIDCard : UIViewController

@property (nonatomic, strong) NSString *style;//确定要拍身份证正面或者反面
@property (nonatomic, assign) NSInteger backStyle;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animateDuration;
@property (nonatomic, assign) CGFloat waitDuration;
@property (nonatomic, copy) CompleteBlock complete;
@property (nonatomic, assign) BOOL showSkipButton;

@end
