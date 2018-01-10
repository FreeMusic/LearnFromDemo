//
//  IphoneCell.m
//  CityJinFu
//
//  Created by xxlc on 17/1/19.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "IphoneCell.h"

@implementation IphoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.image = [UIImage imageNamed:@"蓝底"];
        self.iconImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.width.mas_equalTo(@(kScreenWidth));
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
