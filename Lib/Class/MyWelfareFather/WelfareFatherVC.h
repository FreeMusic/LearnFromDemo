//
//  WelfareFatherVC.h
//  CityJinFu
//
//  Created by mic on 2017/10/16.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelfareFatherVC : UIViewController

-(instancetype)initWithSubViewControllers:(NSArray *)subViewControllers;

@property(nonatomic,copy)UIColor *btnTextNomalColor;
@property(nonatomic,copy)UIColor *btnTextSeletedColor;
@property(nonatomic,copy)UIColor *sliderColor;
@property(nonatomic,copy)UIColor *topBarColor;
@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, assign) NSInteger coupon;//未用红包数量
@property (nonatomic, assign) NSInteger ticket;//未用卡券数量
@property (nonatomic, assign) NSInteger experienceGold;//未用体验金数量

- (void)setButtonPoint:(NSInteger)coupon ticket:(NSInteger)ticket experienceGold:(NSInteger)experienceGold;

@end
