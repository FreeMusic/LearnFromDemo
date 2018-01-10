//
//  InvitePersonCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/12.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "InvitePersonCell.h"

@implementation InvitePersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat width = kScreenWidth/4;
        self.selectionStyle = NO;
        //手机
        _phoneLabel = [self CreateLabelLeftDistance:0 andTitle:@"手机号码"];
        //时间
        _timeLabel = [self CreateLabelLeftDistance:1 andTitle:@"注册时间"];
        //是否绑卡
        _isBidCard = [self CreateLabelLeftDistance:2 andTitle:@""];
        //是否投资
        _isInvest = [self CreateLabelLeftDistance:3 andTitle:@""];
    }
    
    return self;
}

- (UILabel *)CreateLabelLeftDistance:(CGFloat)left andTitle:(NSString *)title{
    UILabel *label = [Factory CreateLabelWithTextColor:0.4 andTextFont:28 andText:title addSubView:self.contentView];
    label.textAlignment = NSTextAlignmentCenter;
    CGFloat width = kScreenWidth/4;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        if (left > 1) {
            make.width.mas_equalTo(width-30*m6Scale);
            make.left.mas_equalTo((width+30*m6Scale)*2+(left-2)*(width-30*m6Scale));
        }else{
            make.width.mas_equalTo(width+30*m6Scale);
            make.left.mas_equalTo((width+30*m6Scale)*left);
        }
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    return label;
}

- (void)cellForModel:(InvitePersonModel *)model{
    _nameLabel.text = [NSString stringWithFormat:@"%@", model.realName];//名字
    _phoneLabel.text = [NSString stringWithFormat:@"%@", model.mobile];//手机号
    _isBidCard.text = model.isBindCard;//是否绑卡
    _isInvest.text = model.isInvest;//是否投资
    NSString *time = [NSString stringWithFormat:@"%@", model.addtime];
    NSNumber *num = @([time integerValue]);//将字符串转化为NSNumber类型
    NSString *str = [Factory stdTimeyyyyMMddFromNumer:num andtag:53];
    _timeLabel.text = str;//时间
}

@end
