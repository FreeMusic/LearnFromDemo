//
//  DetailTableViewCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/24.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        _clipLabel = [[UILabel alloc] init];
        _clipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_clipLabel];
        
        [_clipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
