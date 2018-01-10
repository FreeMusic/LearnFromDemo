//
//  ItemView.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/9/11.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ItemView.h"

@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage title:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        //图片
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
        [self addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72 * m6Scale, 72 * m6Scale));
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(20 * m6Scale);
        }];
        //字体
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.text = title;
        textLabel.font = [UIFont systemFontOfSize:28*m6Scale];
        textLabel.textColor = Colorful(57.0, 57.0, 57.0);
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.button.mas_bottom).offset(14 * m6Scale);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    return self;
}

@end
