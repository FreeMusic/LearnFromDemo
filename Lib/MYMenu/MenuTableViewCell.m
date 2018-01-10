//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 孔繁武. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = [UIColor clearColor];
    self.signImg = [[UIImageView alloc] init];
    self.signImg.clipsToBounds = YES;
    [self.contentView addSubview:self.signImg];
    
    [self.signImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(52 * m6Scale);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(45 * m6Scale, 45 * m6Scale));
    }];
    self.textLab = [UILabel new];
    self.textLab.font = [UIFont systemFontOfSize:28 * m6Scale];
    self.textLab.textColor = [UIColor lightGrayColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.textLab];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signImg.mas_right).offset(50 * m6Scale);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    self.signImg.image = [UIImage imageNamed:menuModel.imageName];
//    self.imageView.image = [UIImage imageNamed:menuModel.imageName];
    self.textLab.text = menuModel.itemName;
}

@end
