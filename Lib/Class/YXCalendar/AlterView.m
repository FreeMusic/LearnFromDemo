//
//  AlterView.m
//  CityJinFu
//
//  Created by mic on 2017/9/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "AlterView.h"

@implementation AlterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *array = @[@"有投资的项目", @"有回款的项目"];
        for (int i = 0; i < 2; i++) {
            //圆圈标签
            UILabel *circleLabel = [Factory CreateLabelWithTextColor:1 andTextFont:0 andText:@"" addSubView:self];
            circleLabel.frame = CGRectMake(20*m6Scale+i*500*m6Scale, 39*m6Scale, 20*m6Scale, 20*m6Scale);
            
            circleLabel.layer.borderColor = (i == 0) ? UIColorFromRGB(0xff6b69).CGColor : UIColorFromRGB(0x4aa2fc).CGColor;
            circleLabel.layer.cornerRadius = 10*m6Scale;
            circleLabel.layer.masksToBounds = YES;
            circleLabel.layer.borderWidth = 1;
            
            //提示标题
            UILabel *alterLabel = [Factory CreateLabelWithTextColor:1 andTextFont:26 andText:array[i] addSubView:self];
            alterLabel.textColor = UIColorFromRGB(0x7a7a7a);
            
            [alterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(circleLabel.mas_right).offset(20*m6Scale);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
            
        }
    }
    
    return self;
}

@end
