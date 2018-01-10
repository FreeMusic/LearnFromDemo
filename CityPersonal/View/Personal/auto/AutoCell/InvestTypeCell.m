//
//  InvestTypeCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InvestTypeCell.h"

@implementation InvestTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSInteger)indexPath {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createViewWithTag:indexPath];
        
    }
    
    return self;
}

- (void)createViewWithTag:(NSInteger)tag {
    
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(42 * m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
