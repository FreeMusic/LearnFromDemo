//
//  PushCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/15.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PushCell.h"

@implementation PushCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = NO;
        self.backgroundColor = backGroundColor;
        //会员等级
        _gradeLabel = [self ReturnLabelLeftDicstance:0];
        //生日奖励
        _birthLabel = [self ReturnLabelLeftDicstance:1];
        //使用条件
        _useLabel = [self ReturnLabelLeftDicstance:2];
        _gradeLabel.text = @"会员等级";
        _birthLabel.text = @"生日奖励";
        _useLabel.text = @"使用条件";
        //单线
        for (int i = 0; i < 4; i++) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
            [self.contentView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i%5*((kScreenWidth-256*m6Scale)/3-1));
                make.top.bottom.mas_equalTo(0);
                make.width.mas_equalTo(1);
            }];
        }
    }
    return self;
}
/**
 *公共标签
 */
- (UILabel *)ReturnLabelLeftDicstance:(NSInteger)dictance{
    UILabel *label = [Factory CreateLabelWithTextColor:0.4 andTextFont:26 andText:@"回忆" addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kScreenWidth-256*m6Scale)/3*dictance);
        make.width.mas_equalTo((kScreenWidth-256*m6Scale)/3);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return label;
}

- (void)setCellByEquity:(NSString *)equity andIndex:(NSInteger)index{
    if (index%2) {
        self.backgroundColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = backGroundColor;
    }
    _birthLabel.text = [NSString stringWithFormat:@"%@", equity];//生日奖励
    _gradeLabel.text = [NSString stringWithFormat:@"V%ld", index];//会员等级
}

@end
