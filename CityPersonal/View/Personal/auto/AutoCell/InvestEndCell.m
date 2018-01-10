//
//  InvestEndCell.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "InvestEndCell.h"

@implementation InvestEndCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexPath:(NSInteger)indexPath {
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createViewWithTag:indexPath];
        
    }
    
    
    return self;
    
}

- (void)createViewWithTag:(NSInteger)tag {
    
    
    _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickButton.tag = 300 + tag;
    [_clickButton addTarget:self action:@selector(selectValueAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_clickButton];
    
    [_clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(- 50 * m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15 * m6Scale, 14 * m6Scale));
    }];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor grayColor];
    _messageLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:_messageLabel];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_clickButton.mas_left).offset(- 30 * m6Scale);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    
}

- (void)selectValueAction:(UIButton *)button {
    
    NSDictionary *userInfo = @{
                               @"tag" : [NSString stringWithFormat:@"%li",(long)button.tag]
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"investType" object:nil userInfo:userInfo];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
