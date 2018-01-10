//
//  PictureCell.m
//  CityJinFu
//
//  Created by mic on 2017/7/26.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = NO;
        //大图
        _picImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_picImgView];
        [_picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(240*m6Scale);
        }];
    }
    return self;
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
