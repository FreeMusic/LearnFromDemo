//
//  CityWalletCell.h
//  CityJinFu
//
//  Created by mic on 2017/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWaveProgressView.h"
#import "MoneyListModel.h"

@interface CityWalletCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;//标题标签
@property (nonatomic,strong) UIImageView *iconImgView;//icon图标
@property (nonatomic,strong) UILabel *rateLabel;//年化利率标签
@property (nonatomic,strong) UILabel *addRateLabel;//增加利率标签
@property (nonatomic,strong) UILabel *dataLabel;//期限标签
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *backView;//加息利率背景图
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *buyLabel;//等待开抢标签
@property (nonatomic, strong) TYWaveProgressView *waveProgressView;//波浪图
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIButton *appointBtn;//预约按钮

- (void)cellForModel:(MoneyListModel *)model;

@end
