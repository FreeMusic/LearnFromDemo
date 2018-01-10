//
//  FingerLockView.h
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FingerLockView : UIView

@property (nonatomic, strong) UIImageView *fingerImageView;

@property (nonatomic, strong) UILabel *textLabel;

- (void)hideButtonAction:(UIGestureRecognizer *)tap;

@end
