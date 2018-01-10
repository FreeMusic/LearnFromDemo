//
//  OpenOneCell.m
//  CityJinFu
//
//  Created by xxlc on 17/7/14.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "OpenOneCell.h"

@implementation OpenOneCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
- (void)createView{
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.intPut];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20*m6Scale);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(88*m6Scale);
        make.width.offset(218*m6Scale);
    }];
    [self.intPut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.mas_equalTo(self.title);
        make.left.mas_equalTo(self.title.mas_right);
        make.right.mas_equalTo(self.contentView).offset(-10*m6Scale);
    }];
}
- (UILabel *)title{
    if (!_title) {
        _title = [UILabel new];
        _title.textColor = UIColorFromRGB(0x434040);
        _title.font = [UIFont systemFontOfSize:28*m6Scale];
    }
    return _title;
}
- (UITextField *)intPut{
    if (!_intPut) {
        _intPut = [UITextField new];
        _intPut.clearButtonMode = UITextFieldViewModeWhileEditing;
        _intPut.font = [UIFont systemFontOfSize:30*m6Scale];
        KeyBoard *key = [[KeyBoard alloc]init];
        UIView *clip = [key keyBoardview];
        [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
        _intPut.inputAccessoryView = clip;
    }
    return _intPut;
}

/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    //提高tabView的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TaketabviewH" object:nil];
    [self endEditing:YES];
    
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
