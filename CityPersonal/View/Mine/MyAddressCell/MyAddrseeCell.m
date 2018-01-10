//
//  MyAddrseeCell.m
//  CityJinFu
//
//  Created by mic on 2017/6/21.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyAddrseeCell.h"

@implementation MyAddrseeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //输入框
        _textFiled = [[UITextField alloc] init];
        _textFiled.textColor = UIColorFromRGB(0x333333);
        _textFiled.font = [UIFont systemFontOfSize:30*m6Scale];
        [self.contentView addSubview:_textFiled];
        [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_right).offset(5*m6Scale);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    
    return self;
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self endEditing:YES];
    
}
- (void)cellForAddress:(NSString *)address{
    _textFiled.text = address;//输入框
}
@end
