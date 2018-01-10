//
//  FooterViewCell.m
//  CityJinFu
//
//  Created by xxlc on 17/6/8.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "FooterViewCell.h"

@implementation FooterViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 布局
 */
- (void)creatView{
    NSArray *array = @[@"周期短",@"收益高",@"提现快",@"信息全"];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.frame = CGRectMake(((kScreenWidth/4)-65*m6Scale)/2+(kScreenWidth/4) *i, 40*m6Scale, 65*m6Scale, 65*m6Scale);
        imageview.image = [UIImage imageNamed:array[i]];
        [self.contentView addSubview:imageview];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake((kScreenWidth/4) *i, 120*m6Scale, kScreenWidth / 4, 30*m6Scale);
        label.text = array[i];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30*m6Scale];
        [self.contentView addSubview:label];
    }
    //文字
    UILabel *safeLab = [UILabel new];
    safeLab.text = @"浙江民泰商业银行存管保护资金安全";
    safeLab.textColor = [UIColor lightGrayColor];
    safeLab.font = [UIFont systemFontOfSize:30*m6Scale];
    [self.contentView addSubview:safeLab];
    [safeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20*m6Scale);
    }];
    //盾牌
    UIImageView *safeImage = [[UIImageView alloc]init];
    safeImage.image = [UIImage imageNamed:@"anquan@2x(1)"];
    [self.contentView addSubview:safeImage];
    [safeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(safeLab.mas_left).offset(-10*m6Scale);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-23*m6Scale);
        make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
