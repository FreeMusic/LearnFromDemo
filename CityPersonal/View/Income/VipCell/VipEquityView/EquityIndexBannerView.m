//
//  EquityIndexBannerView.m
//  CityJinFu
//
//  Created by mic on 2017/7/6.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "EquityIndexBannerView.h"

@implementation EquityIndexBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //会员卡背景图
        _mainImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip0"]];
        _mainImageView.frame = self.frame;
        [self addSubview:_mainImageView];
        //用户标签
        _userLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:@"VIP用户" addSubView:self];
        [_userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(110*m6Scale);
        }];
        //用户标签下方的白色划线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        [_mainImageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userLabel.mas_left);
            make.right.mas_equalTo(_userLabel.mas_right);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(_userLabel.mas_bottom).offset(10*m6Scale);
        }];
        //升级财气值
        _moneyLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"升级V1还需财气值：10000.00" addSubView:_mainImageView];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-52*m6Scale);
        }];
    }
    
    return self;
}
- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}

- (void)setBackgroundImgViewByImgName:(NSString *)imgName andVipArr:(NSArray *)array andMoney:(NSInteger)money andGrade:(NSInteger)grade andIndex:(NSInteger)index{
    _mainImageView.image = [UIImage imageNamed:imgName];//背景图
    //当会员等级小于6的时候
    if (grade < 6) {
        //判断会员卡的等级是否大于该卡片赋值时候的位置下标
        if (index <= grade) {
            //说明该用户会员等级大于卡片赋值时候的位置下标
            _moneyLabel.text = [NSString stringWithFormat:@"您的投资年化金额：%ld", money];
        }else{
            //说明该用户会员等级不大于卡片赋值时候的位置下标
            //先确定用户到下一个等级需要多少财气值
            NSString *current = @"";
            //用户从当前会员等级当前财气值到下一个会员等级所需要的财气值
            NSString *next = @"";
            if (index == 6) {
                current = array[5];
                //当滑到V6的时候，展示升级到V6需要的财气值
                next = [NSString stringWithFormat:@"%ld", current.integerValue - money];
                _moneyLabel.text = [NSString stringWithFormat:@"您升级到V6还需年化金额：%@", next];
            }else{
                if (array.count) {
                    current = array[index-1];
                }
                next = [NSString stringWithFormat:@"%ld", current.integerValue - money];
                NSLog(@"%@", next);
                _moneyLabel.text = [NSString stringWithFormat:@"您升级到V%ld还需年化金额：%@", index, next];
            }
        }
    }else{
        //会员等级为6 展示用户当前金额
        _moneyLabel.text = [NSString stringWithFormat:@"您的投资年化金额：%ld", money];
    }
}

@end
